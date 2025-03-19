# live-server-bun-nvim: Plugin to Run Live Server in Neovim with Bun.js

A lightweight **Neovim plugin** to serve HTML files using **live-server**, optimized for **Bun.js**.

---

## 📜 **Requirements**

- [Bun](https://bun.sh/) (instead of npm)
- `live-server` globally installed via Bun

```sh
bun add -g live-server
```

---

## ⚡ **Installation**

Install the plugin using **lazy.nvim**:

```lua
require("lazy").setup({
  {
    "RoyRoki/live-server-bun-nvim",
    event = "VeryLazy",
    build = ":LiveServerInstall",
    config = function()
      require("live-server-nvim").setup({})
    end,
  },
})
```

---

## 🔧 **Configuration**

**live-server-nvim** works out of the box but allows customization if needed:

```lua
require("live-server-nvim").setup({
    custom = {
        "--port=8080",        -- Set custom port
        "--no-css-inject",    -- Disable CSS injection
    },
    serverPath = vim.fn.stdpath("data") .. "/live-server/", -- Default
    open = "folder",  -- "folder" | "cwd"
})
```

More customization options available:  
[🔗 live-server CLI options](https://github.com/tapio/live-server#usage-from-command-line)

---

## 🚀 **Usage**

| Command              | Description                                 |
| -------------------- | ------------------------------------------- |
| `:LiveServerStart`   | Start the server with the correct HTML file |
| `:LiveServerStop`    | Stop the server                             |
| `:LiveServerRestart` | Restart the server                          |
| `:LiveServerOpen`    | Open the served HTML file in the browser    |

---

## 🎮 **Custom Keybindings**

Example mappings:

```lua
vim.keymap.set("n", "<leader>ls", ":LiveServerStart<CR>", { noremap = true, silent = true, desc = "Start Live Server" })
vim.keymap.set("n", "<leader>lx", ":LiveServerStop<CR>", { noremap = true, silent = true, desc = "Stop Live Server" })
vim.keymap.set("n", "<leader>lr", ":LiveServerRestart<CR>", { noremap = true, silent = true, desc = "Restart Live Server" })
vim.keymap.set("n", "<leader>lo", ":LiveServerOpen<CR>", { noremap = true, silent = true, desc = "Open Live Server in Browser" })
```

---

## 📌 **How it Works**

- **Detects the correct HTML file to serve:**
  - If you're in an HTML file → serve the current file.
  - If not, it looks for `index.html` in the project.
  - If no `index.html`, it serves the first available HTML file.
  - If no HTML files are found, it shows a warning.
- **Opens the correct HTML file in your browser.**
- **Prevents multiple servers from running.**
- **Improves logging for better debugging.**

---

## 🎉 **Contributing & Thanks**

Feel free to contribute by opening an issue or PR at:  
[🔗 GitHub Repo](https://github.com/RoyRoki/live-server-bun-nvim.git)

🚀 **Happy coding!**
