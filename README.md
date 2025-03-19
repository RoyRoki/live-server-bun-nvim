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

**live-server-nvim** requires setup before use:

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

| Command             | Description          |
| ------------------- | -------------------- |
| `:LiveServerStart`  | Start the server     |
| `:LiveServerStop`   | Stop the server      |
| `:LiveServerToggle` | Toggle server on/off |

---

## 🎮 **Custom Keybindings**

Example mapping:

```lua
vim.keymap.set("n", "<leader>lt", function()
    require("live-server-nvim").toggle()
end)
```

---

## 🎉 **Contributing & Thanks**

Feel free to contribute by opening an issue or PR at:  
[🔗 GitHub Repo](https://github.com/RoyRoki/live-server-bun-nvim.git)

🚀 **Happy coding!**
