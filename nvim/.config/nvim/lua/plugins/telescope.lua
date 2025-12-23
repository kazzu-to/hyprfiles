vim.pack.add({
	{
		src = "https://github.com/nvim-telescope/telescope.nvim",
		version = "main",
	},
	{
		src = "https://github.com/nvim-lua/plenary.nvim",
		version = "main",
	},
})

require('telescope').setup{}
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set("n", "<leader>fg", function()
  require("telescope.builtin").live_grep({
    cwd = vim.fn.expand("%:p:h"),
  })
end)
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })