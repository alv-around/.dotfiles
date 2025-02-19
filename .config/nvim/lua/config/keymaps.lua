vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex) -- set in "n"ormal mode <leader>pv as ":Ex"

-- telescope shortcuts
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

-- clear terminal window with Cntrl-l
vim.keymap.set("t", "<C-l><C-l>", [[<C-\><C-N>:lua ClearTerm(0)<CR>]], {})
vim.keymap.set("t", "<C-l><C-l><C-l>", [[<C-\><C-N>:lua ClearTerm(1)<CR>]], {})

-- navigate between multiplexer panes
-- moving between splits
-- vim.g.smart_splits_multiplexer_integration = true
vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left)
vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down)
vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up)
vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right)

function ClearTerm(reset)
	vim.opt_local.scrollback = 1

	vim.api.nvim_command("startinsert")
	if reset == 1 then
		vim.api.nvim_feedkeys("reset", "t", false)
	else
		vim.api.nvim_feedkeys("clear", "t", false)
	end
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<cr>", true, false, true), "t", true)

	vim.opt_local.scrollback = 10000
end
