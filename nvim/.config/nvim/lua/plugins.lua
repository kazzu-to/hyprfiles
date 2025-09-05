vim.pack.add({
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }, { src = 'https://github.com/nvim-tree/nvim-tree.lua' },
  { src = 'https://github.com/nvim-lua/plenary.nvim'}, -- dependency for telescope 
  { src = 'https://github.com/nvim-telescope/telescope.nvim'}, 
  { src = 'https://github.com/AlphaTechnolog/pywal.nvim'},
  { src = 'https://github.com/nvim-lualine/lualine.nvim'}
})


local lsp = require('lspconfig')
local lualine = require('lualine')

lualine.setup {
  options = {
    theme = 'pywal-nvim'
  },
}

-- Java LSP (Eclipse JDT LS)
lsp.jdtls.setup({
  cmd = { 'jdtls' },
  root_dir = lsp.util.root_pattern('.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle'),
})

-- Enable LSP configs
vim.lsp.enable('pyright')   -- Python
vim.lsp.enable('clangd')    -- C++
vim.lsp.enable('bashls')    -- Bash

-- treesitter syntex highlighting
require('nvim-treesitter.configs').setup {
  ensure_installed = { "python", "cpp", "bash", "lua", "c", "markdown" },
  highlight = { enable = true }
}


require('nvim-tree').setup {}
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>')
