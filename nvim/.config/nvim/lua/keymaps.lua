-- Se ':help vim.keymaps.set()'


local function map(mode, lhs, rhs, desc, opts)
	opts = opts or {}
	opts.silent = opts.silent ~= false
	opts.noremap = true
	if desc then opts.desc = desc end
	vim.keymap.set(mode, lhs, rhs, opts)
end

-- 1–3: Save / Quit
map('n', '<leader>w', '<cmd>write<CR>', 'Save file')
map('n', '<leader>q', '<cmd>quit<CR>', 'Quit window')
map('n', '<leader>x', '<cmd>x<CR>', 'Save and quit')

-- 4: Toggle spell
map('n', '<leader>ts', '<cmd>set spell!<CR>', 'Toggle spell')

-- 5: Clear search highlight
map('n', '<leader>/', '<cmd>nohlsearch<CR>', 'Clear search highlight')

-- 6: Explorer (netrw)
map('n', '<leader>e', '<cmd>Ex<CR>', 'Open file explorer')

-- 7–10: Buffers
map('n', ']b', '<cmd>bnext<CR>', 'Next buffer')
map('n', '[b', '<cmd>bprevious<CR>', 'Previous buffer')
map('n', '<leader>bd', '<cmd>bdelete<CR>', 'Delete buffer')
map('n', '<leader><Tab>', '<cmd>b#<CR>', 'Alternate buffer')

-- 11–12: Splits
map('n', '<leader>sh', '<cmd>split<CR>', 'Horizontal split')
map('n', '<leader>sv', '<cmd>vsplit<CR>', 'Vertical split')

-- 13: Window navigation
map('n', '<C-h>', '<C-w>h', 'Window left')
map('n', '<C-j>', '<C-w>j', 'Window down')
map('n', '<C-k>', '<C-w>k', 'Window up')
map('n', '<C-l>', '<C-w>l', 'Window right')

-- 14: Window resizing
map('n', '<C-Up>',    '<cmd>resize -2<CR>', 'Shrink height')
map('n', '<C-Down>',  '<amt>resize +2<CR>', 'Grow height')
map('n', '<C-Left>',  '<cmd>vertical resize -2<CR>', 'Shrink width')
map('n', '<C-Right>', '<cmd>vertical resize +2<CR>', 'Grow width')

-- 15–16: System clipboard
map('v', '<leader>y', '"+y', 'Yank to clipboard')
map('n', '<leader>p', '"+p', 'Paste from clipboard')

-- 17: Move current line
map('n', '<A-j>', ':m .+1<CR>==', 'Move line down')
map('n', '<A-k>', ':m .-2<CR>==', 'Move line up')

-- 18: Move selected lines
map('x', '<A-j>', ":m '>+1<CR>gv=gv", 'Move selection down')
map('x', '<A-k>', ":m '<-2<CR>gv=gv", 'Move selection up')

-- Move lines up and down in Insert Mode
vim.api.nvim_set_keymap('i', '<A-Up>', '<Esc>:m .-2<CR>i', { noremap = true })
vim.api.nvim_set_keymap('i', '<A-Down>', '<Esc>:m .+1<CR>i', { noremap = true })

-- 19: Reindent whole file
map('n', '<leader>=', 'gg=G', 'Reindent file')

-- 20: Replace word under cursor
map('n', '<leader>r', [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]], 'Replace word under cursor')

--vim.keymap.del('n', '<leader>s')

