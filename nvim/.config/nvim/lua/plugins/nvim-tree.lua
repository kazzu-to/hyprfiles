-- lua/plugins/nvim_tree.lua
-- Make sure this file is loaded by init.lua
-- For example: require("plugins.nvim_tree")

local M = {}

function M.setup()
  -- 1) Add the plugin using vim.pack.add()
  vim.pack.add({
    {src = "https://github.com/nvim-tree/nvim-tree.lua"},
    {src = "https://github.com/nvim-tree/nvim-web-devicons"},
})

  -- 3) After add, configure it (must be after pack is loaded)
  -- Delay until the module is available
  vim.schedule(function()
    -- Disable netrw so it won’t conflict
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- Enable true color support
    vim.opt.termguicolors = true

    -- Setup nvim‑tree
    local ok, nvim_tree = pcall(require, "nvim-tree")
    if not ok then
      vim.notify("nvim-tree not found!", vim.log.levels.ERROR)
      return
    end

    nvim_tree.setup({
      sort_by = "name",
      view = {
        width = 30,
        side = "left",
      },
      renderer = {
        group_empty = true,
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
        },
      },
      filters = {
        dotfiles = false,
        custom = {},
      },
    })
  end)
end

function M.keymaps()
  -- 4) Keymaps to open / toggle the tree
  vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle Nvim‑Tree Explorer" })
  vim.keymap.set("n", "<leader>E", ":NvimTreeFindFileToggle<CR>", { desc = "Find in Nvim‑Tree" })
end

return M
