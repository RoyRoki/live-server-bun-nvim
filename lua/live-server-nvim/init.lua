local M = {}

local defaultConfig = {
	custom = {},
	serverPath = vim.fn.stdpath("data") .. "/live-server/",
	open = "folder", -- cwd
}

local function show_message(level, message)
	vim.notify(message, level, { title = "live-server-nvim" })
end

local function find_html_file()
	local current_file = vim.fn.expand("%:p")
	if current_file:match("%.html$") then
		return current_file
	end

	local project_root = vim.fn.getcwd()
	local index_html = vim.fn.glob(project_root .. "/index.html")
	if index_html ~= "" then
		return index_html
	end

	local all_html = vim.fn.glob(project_root .. "/*.html", true, true)
	if #all_html > 0 then
		return all_html[1]
	end

	show_message(vim.log.levels.WARN, "⚠️ No HTML file found in the project!")
	return nil
end

local function buildCommandList(html_file)
	local cmdTable = { "bunx", "live-server", html_file }
	for _, option in ipairs(defaultConfig.custom) do
		table.insert(cmdTable, option:gsub("%s", ""))
	end
	return cmdTable
end

local function onStdout(_, data, _)
	for _, line in ipairs(data) do
		if line:match("http://") then
			M.server_url = line:match("(http://[%d%.:%d]+)")
			show_message(vim.log.levels.INFO, "🌍 Live Server running at: " .. M.server_url)
		end
	end
end

M.install = function()
	show_message(vim.log.levels.INFO, "📦 Installing live-server using Bun...")
	vim.fn.jobstart({ "bun", "add", "-g", "live-server" }, {
		on_exit = function(_, code)
			if code == 0 then
				show_message(vim.log.levels.INFO, "✅ live-server installed successfully!")
			else
				show_message(vim.log.levels.ERROR, "❌ Installation failed! Ensure Bun is installed.")
			end
		end,
	})
end

M.start = function()
	local html_file = find_html_file()
	if not html_file then
		return
	end

	if SESSION_JOB then
		show_message(vim.log.levels.WARN, "⚠️ live-server is already running!")
		return
	end

	local cmdTable = buildCommandList(html_file)
	SESSION_JOB = vim.fn.jobstart(cmdTable, { on_stdout = onStdout })
	show_message(vim.log.levels.INFO, "🔥 Starting live-server for: " .. html_file)
end

M.open = function()
	if M.server_url then
		vim.fn.jobstart({ "xdg-open", M.server_url }, { detach = true })
		show_message(vim.log.levels.INFO, "🌍 Opening browser: " .. M.server_url)
	else
		show_message(vim.log.levels.ERROR, "⚠️ Server URL not found. Start the server first!")
	end
end

M.stop = function()
	if SESSION_JOB then
		vim.fn.jobstop(SESSION_JOB)
		SESSION_JOB = nil
		show_message(vim.log.levels.INFO, "⛔ Stopped live-server!")
	else
		show_message(vim.log.levels.WARN, "⚠️ live-server is not running!")
	end
end

M.restart = function()
	M.stop()
	vim.defer_fn(M.start, 500) -- Restart after a short delay
end

M.setup = function(config)
	defaultConfig = vim.tbl_deep_extend("force", defaultConfig, config)
end

vim.cmd("command! LiveServerStart lua require'live-server-nvim'.start()")
vim.cmd("command! LiveServerOpen lua require'live-server-nvim'.open()")
vim.cmd("command! LiveServerRestart lua require'live-server-nvim'.restart()")
vim.cmd("command! LiveServerStop lua require'live-server-nvim'.stop()")
vim.cmd("command! LiveServerInstall lua require'live-server-nvim'.install()")

return M
