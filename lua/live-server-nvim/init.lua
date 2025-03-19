local M = {}

local defaultConfig = {
	custom = {},
	serverPath = vim.fn.stdpath("data") .. "/live-server/",
	open = "folder", -- cwd
}

local function show_message(level, message)
	vim.notify(message, level, { title = "live-server-nvim" })
end

local function getOpen()
	return defaultConfig.open == "folder" and vim.fn.expand("%:p:h") or vim.fn.getcwd()
end

local function buildCommandList()
	local cmdTable = { "bunx", "live-server" }
	for _, option in ipairs(defaultConfig.custom) do
		table.insert(cmdTable, option:gsub("%s", ""))
	end
	return cmdTable
end

local function onStdout(_, data, _)
	local output = table.concat(data)
	if output:match("http") then
		show_message(vim.log.levels.INFO, output)
	end
end

M.install = function()
	show_message(vim.log.levels.INFO, "Installing live-server using Bun...")
	vim.fn.jobstart({ "bun", "add", "-g", "live-server" }, {
		on_exit = function(_, code)
			if code == 0 then
				show_message(vim.log.levels.INFO, "live-server installed successfully!")
			else
				show_message(vim.log.levels.ERROR, "Failed to install live-server. Ensure Bun is installed.")
			end
		end,
	})
end

M.start = function()
	local cmdTable = buildCommandList()
	local realPath = getOpen()
	table.insert(cmdTable, realPath)
	SESSION_JOB = vim.fn.jobstart(cmdTable, { on_stdout = onStdout })
end

M.stop = function()
	if SESSION_JOB then
		vim.fn.jobstop(SESSION_JOB)
		SESSION_JOB = nil
		show_message(vim.log.levels.INFO, "Stopped live-server!")
	else
		show_message(vim.log.levels.WARN, "live-server is not running!")
	end
end

M.toggle = function()
	if SESSION_JOB then
		M.stop()
	else
		M.start()
	end
end

M.setup = function(config)
	defaultConfig = vim.tbl_deep_extend("force", defaultConfig, config)
end

vim.cmd("command! LiveServerStart lua require'live-server-nvim'.start()")
vim.cmd("command! LiveServerStop lua require'live-server-nvim'.stop()")
vim.cmd("command! LiveServerToggle lua require'live-server-nvim'.toggle()")
vim.cmd("command! LiveServerInstall lua require'live-server-nvim'.install()")

return M
