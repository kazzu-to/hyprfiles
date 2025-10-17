vim.pack.add({
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }, { src = 'https://github.com/nvim-tree/nvim-tree.lua' },
  { src = 'https://github.com/nvim-lua/plenary.nvim'}, -- dependency for telescope 
  { src = 'https://github.com/nvim-telescope/telescope.nvim'}, 
  { src = 'https://github.com/AlphaTechnolog/pywal.nvim'},
  { src = 'https://github.com/nvim-lualine/lualine.nvim'}
})


local lualine = require('lualine')

lualine.setup {
  options = {
    theme = 'pywal-nvim'
  },
}

vim.lsp.config('rust_analyzer', {
  -- Server-specific settings. See `:help lsp-quickstart`
  settings = {
    ['rust-analyzer'] = {},
  },
})

vim.lsp.config('pyright', {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "off",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  }})

vim.lsp.enable('pyright')
vim.lsp.enable('rust_analyzer')
vim.lsp.inline_completion.enable(true)

-- treesitter syntex highlighting
require('nvim-treesitter.configs').setup {
  ensure_installed = { "python", "cpp", "bash", "lua", "c", "markdown" },
  highlight = { enable = true }
}


require('nvim-tree').setup {}
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>')


