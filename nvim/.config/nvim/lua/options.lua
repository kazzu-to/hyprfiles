--See ':help vim.opt'
--For more options see ':help option-list'

local opt = vim.opt

--mouse support in all mode(visual, normal, insert)
opt.mouse = 'a'

--saves undo history even after closing files 
opt.undofile = true


--smartcase finds only exact matching case if search starts with upper case
opt.smartcase = true
opt.ignorecase = true

--adds number in editor for each line
opt.number = true
opt.relativenumber = true

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

--autocompletion

vim.opt.completeopt = { "menuone", "noselect", "popup" }
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    vim.lsp.completion.enable(true, args.data.client_id, args.buf, { autotrigger = true })
  end
})

opt.signcolumn = 'yes'
opt.smartindent = true
opt.clipboard = 'unnamedplus'

