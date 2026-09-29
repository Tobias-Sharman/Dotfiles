-- ============================================================================
-- Colour scheme
-- ============================================================================

local palettes = require("ink.palettes")
local state = require("ink.state")

vim.api.nvim_create_user_command("Ink", function(opts)
	local palette = opts.args

	if not palettes.has(palette) then
		vim.notify("Unknown ink palette: " .. palette, vim.log.levels.ERROR)
		return
	end

	vim.g.ink_palette = palette
	state.set_palette(palette)

	require("ink.highlights").apply(palette)
end, {
	nargs = 1,
	complete = function()
		return palettes.names()
	end,
})

-- ============================================================================
-- Cmake toolings
-- ============================================================================

local M = {}

local function run(command)
	vim.cmd("!" .. command)
end

function M.cmake_configure()
	run("cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON && ln -sf build/compile_commands.json compile_commands.json")
end

function M.cmake_build()
	run("cmake --build build")
end

function M.cmake_configure_and_build()
	run(
		"cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON && ln -sf build/compile_commands.json compile_commands.json && cmake --build build"
	)
end

function M.cmake_test()
	run("ctest --test-dir build --output-on-failure")
end

-- ============================================================================
-- Clang-tidy project diagnostics
-- ============================================================================

local clang_tidy_namespace = vim.api.nvim_create_namespace("ink_clang_tidy_project")
local clang_tidy_results = {}
local clang_tidy_refreshing = false

local function is_project_file(path, root)
	return vim.startswith(path, root .. "/") and not path:find("/build/", 1, true) and not path:find("/_deps/", 1, true)
end

local tidy_running = false
local tidy_summary = nil

local header_extensions = { h = true, hh = true, hpp = true, hxx = true }

local function real_path(path)
	return vim.uv.fs_realpath(path) or path
end

local function entry_path(entry)
	if vim.startswith(entry.file, "/") then
		return entry.file
	end

	return vim.fs.normalize(entry.directory .. "/" .. entry.file)
end

local function project_sources(database, root)
	local ok, entries = pcall(vim.json.decode, table.concat(vim.fn.readfile(database), "\n"))
	local sources = {}
	local seen = {}
	local dependency_entries = 0

	if not ok then
		return nil, 0
	end

	for _, entry in ipairs(entries) do
		local path = real_path(entry_path(entry))

		if not is_project_file(path, root) then
			dependency_entries = dependency_entries + 1
		elseif not seen[path] then
			seen[path] = true
			table.insert(sources, path)
		end
	end

	return sources, dependency_entries
end

local function project_headers(root)
	local headers = {}
	local result = vim.system({
		"git",
		"ls-files",
		"--cached",
		"--others",
		"--exclude-standard",
		"--",
		"*.h",
		"*.hh",
		"*.hpp",
		"*.hxx",
	}, { cwd = root, text = true }):wait()

	if result.code == 0 then
		for relative in result.stdout:gmatch("[^\n]+") do
			table.insert(headers, root .. "/" .. relative)
		end
	else
		for relative, kind in
			vim.fs.dir(root, {
				depth = math.huge,
				skip = function(directory)
					local name = vim.fs.basename(directory)

					return name ~= "build" and name ~= "_deps" and not vim.startswith(name, ".")
				end,
			})
		do
			if kind == "file" and header_extensions[vim.fn.fnamemodify(relative, ":e")] then
				table.insert(headers, root .. "/" .. relative)
			end
		end
	end

	return vim.tbl_filter(function(path)
		return is_project_file(path, root)
	end, headers)
end

local function run_queue(items, limit, run_item, on_done)
	local next_index = 1
	local running = 0

	if #items == 0 then
		on_done()
		return
	end

	local function start()
		while running < limit and next_index <= #items do
			local item = items[next_index]

			next_index = next_index + 1
			running = running + 1

			run_item(item, function()
				running = running - 1

				if running == 0 and next_index > #items then
					on_done()
				else
					start()
				end
			end)
		end
	end

	start()
end

local function parse_clang_tidy_line(line, root)
	local path, lnum, col, severity, message, check = line:match("^(.-):(%d+):(%d+): (%a+): (.-) %[([^%]]+)%]$")

	if path == nil or (severity ~= "warning" and severity ~= "error") or not is_project_file(path, root) then
		return nil
	end

	return path,
		{
			lnum = tonumber(lnum) - 1,
			col = tonumber(col) - 1,
			severity = severity == "error" and vim.diagnostic.severity.ERROR or vim.diagnostic.severity.WARN,
			message = message,
			source = "clang-tidy",
			code = check,
		}
end

local function sorted_counts(counts)
	local sorted = {}

	for name, count in pairs(counts) do
		table.insert(sorted, { name = name, count = count })
	end

	table.sort(sorted, function(left, right)
		if left.count ~= right.count then
			return left.count > right.count
		end

		return left.name < right.name
	end)

	return sorted
end

local function is_analyzer(diagnostic)
	return vim.startswith(diagnostic.code or "", "clang-analyzer-")
end

local function check_names(diagnostic)
	local names = {}

	for name in tostring(diagnostic.code or ""):gmatch("[^,]+") do
		names[name] = true
	end

	return names
end

local function reported_elsewhere(diagnostic, others)
	local names = check_names(diagnostic)

	for _, other in ipairs(others) do
		if other.lnum == diagnostic.lnum then
			for name in pairs(check_names(other)) do
				if names[name] then
					return true
				end
			end
		end
	end

	return false
end

local function now_seconds()
	local time = vim.uv.clock_gettime("realtime")

	return time.sec + (time.nsec / 1e9)
end

local function changed_since(bufnr, started)
	local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(bufnr))

	return stat ~= nil and stat.mtime.sec + (stat.mtime.nsec / 1e9) > started
end

function M.clang_tidy_refresh(bufnr)
	local results = clang_tidy_results[bufnr]

	if results == nil or clang_tidy_refreshing then
		return
	end

	if changed_since(bufnr, results.started) then
		M.clang_tidy_clear(bufnr)
		return
	end

	local others = vim.tbl_filter(function(diagnostic)
		return diagnostic.namespace ~= clang_tidy_namespace
	end, vim.diagnostic.get(bufnr))

	local kept = vim.tbl_filter(function(diagnostic)
		return not reported_elsewhere(diagnostic, others)
	end, results.diagnostics)

	clang_tidy_refreshing = true
	vim.diagnostic.set(clang_tidy_namespace, bufnr, kept)
	clang_tidy_refreshing = false
end

function M.clang_tidy_clear(bufnr)
	clang_tidy_results[bufnr] = nil
	vim.diagnostic.reset(clang_tidy_namespace, bufnr)
end

local function status(message, highlight)
	local width = math.max(vim.o.columns - 12, 20)

	if #message > width then
		message = message:sub(1, width - 3) .. "..."
	end

	vim.api.nvim_echo({ { message, highlight } }, false, {})
end

local function diagnostic_key(diagnostic)
	return table.concat({ diagnostic.lnum, diagnostic.col, tostring(diagnostic.code) }, ":")
end

local function summarise(root, label)
	local by_check = {}
	local by_file = {}
	local total = 0
	local errors = 0

	for bufnr, results in pairs(clang_tidy_results) do
		local path = vim.api.nvim_buf_get_name(bufnr):sub(#root + 2)

		for _, diagnostic in ipairs(results.diagnostics) do
			local check = tostring(diagnostic.code)

			total = total + 1
			by_check[check] = (by_check[check] or 0) + 1
			by_file[path] = by_file[path] or { count = 0, checks = {} }
			by_file[path].count = by_file[path].count + 1
			by_file[path].checks[check] = (by_file[path].checks[check] or 0) + 1

			if diagnostic.severity == vim.diagnostic.severity.ERROR then
				errors = errors + 1
			end
		end
	end

	local lines = { string.format("clang-tidy (%s): %d diagnostic(s), %d error(s)", label, total, errors) }

	if total > 0 then
		table.insert(lines, "By check:")

		for _, entry in ipairs(sorted_counts(by_check)) do
			table.insert(lines, string.format("%5d  %s", entry.count, entry.name))
		end

		local file_counts = {}

		for path, entry in pairs(by_file) do
			file_counts[path] = entry.count
		end

		table.insert(lines, "By file:")

		for _, file in ipairs(sorted_counts(file_counts)) do
			local breakdown = {}

			for _, check in ipairs(sorted_counts(by_file[file.name].checks)) do
				table.insert(breakdown, string.format("%s x%d", check.name, check.count))
			end

			table.insert(lines, string.format("%5d  %s  (%s)", file.count, file.name, table.concat(breakdown, ", ")))
		end
	end

	return lines, total, errors
end

local function run_clang_tidy(include_analyzer)
	if tidy_running then
		vim.notify("A clang-tidy run is already in progress", vim.log.levels.WARN)
		return
	end

	local database = vim.fs.find("compile_commands.json", {
		upward = true,
		path = vim.fn.getcwd(),
		limit = 1,
	})[1]

	if database == nil then
		vim.notify("No compile_commands.json found above the working directory", vim.log.levels.WARN)
		return
	end

	if vim.fn.executable("clang-tidy") == 0 then
		vim.notify("clang-tidy not found on PATH", vim.log.levels.ERROR)
		return
	end

	local root = vim.fs.dirname(database)
	local sources, dependency_entries = project_sources(database, root)

	if sources == nil then
		vim.notify("Could not read " .. database, vim.log.levels.ERROR)
		return
	end

	local dependency_note = dependency_entries > 0 and string.format(", %d third-party DB entries", dependency_entries)
		or ""

	local files = vim.list_extend(sources, project_headers(root))
	local options = { "clang-tidy", "-p", root, "-quiet" }

	if vim.fn.has("mac") == 1 then
		local sdk = vim.trim(vim.fn.system({
			"xcrun",
			"--show-sdk-path",
		}))

		table.insert(options, "-extra-arg=-isysroot" .. sdk)
	end

	if not include_analyzer then
		table.insert(options, "-checks=-clang-analyzer-*")
	end

	local label = include_analyzer and "full" or "fast"
	local started = now_seconds()
	local preserved = {}
	local seen = {}

	if not include_analyzer then
		for bufnr, results in pairs(clang_tidy_results) do
			if not changed_since(bufnr, results.started) then
				preserved[vim.api.nvim_buf_get_name(bufnr)] = vim.tbl_filter(is_analyzer, results.diagnostics)
			end
		end
	end

	vim.diagnostic.reset(clang_tidy_namespace)
	clang_tidy_results = {}
	tidy_running = true

	local function add(path, diagnostics)
		local bufnr = vim.fn.bufadd(path)
		local results = clang_tidy_results[bufnr] or { started = started, diagnostics = {} }

		seen[bufnr] = seen[bufnr] or {}

		for _, diagnostic in ipairs(diagnostics) do
			local key = diagnostic_key(diagnostic)

			if not seen[bufnr][key] then
				seen[bufnr][key] = true
				table.insert(results.diagnostics, diagnostic)
			end
		end

		clang_tidy_results[bufnr] = results
		M.clang_tidy_refresh(bufnr)
	end

	for path, diagnostics in pairs(preserved) do
		add(path, diagnostics)
	end

	local started_files = 0

	local function check(file, on_done)
		started_files = started_files + 1
		status(string.format("clang-tidy (%s) %d/%d: %s", label, started_files, #files, file:sub(#root + 2)))

		vim.system(vim.list_extend(vim.deepcopy(options), { file }), {
			cwd = root,
			text = true,
		}, function(result)
			vim.schedule(function()
				local by_path = {}

				for line in (result.stdout or ""):gmatch("[^\n]+") do
					local path, diagnostic = parse_clang_tidy_line(line, root)

					if path ~= nil then
						by_path[path] = by_path[path] or {}
						table.insert(by_path[path], diagnostic)
					end
				end

				for path, diagnostics in pairs(by_path) do
					add(path, diagnostics)
				end

				on_done()
			end)
		end)
	end

	run_queue(files, vim.uv.available_parallelism(), check, function()
		tidy_running = false

		local lines, total, errors = summarise(root, label)

		tidy_summary = lines
		status(
			string.format(
				"clang-tidy (%s): %d diagnostic(s), %d error(s)%s  :ClangTidySummary",
				label,
				total,
				errors,
				dependency_note
			),
			(errors > 0 or dependency_entries > 0) and "WarningMsg" or nil
		)
	end)
end

vim.api.nvim_create_user_command("ClangTidySummary", function()
	if tidy_summary == nil then
		vim.notify("No clang-tidy project run yet", vim.log.levels.INFO)
		return
	end

	vim.notify(table.concat(tidy_summary, "\n"), vim.log.levels.INFO)
end, {})

function M.clang_tidy_fast()
	run_clang_tidy(false)
end

function M.clang_tidy_full()
	run_clang_tidy(true)
end

return M
