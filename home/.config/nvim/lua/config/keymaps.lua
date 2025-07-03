vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex) -- set in "n"ormal mode <leader>pv as ":Ex"

-- telescope shortcuts
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

-- Move to window using the <ctrl> hjkl keys
local function map(mode, lhs, rhs, opts)
	opts = opts or {}
	vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", {}, opts))
end

map("n", "<C-h>", function()
	require("smart-splits").move_cursor_left()
end, { desc = "Go to left window", remap = true })
map("n", "<C-j>", function()
	require("smart-splits").move_cursor_down()
end, { desc = "Go to lower window", remap = true })
map("n", "<C-k>", function()
	require("smart-splits").move_cursor_up()
end, { desc = "Go to upper window", remap = true })
map("n", "<C-l>", function()
	require("smart-splits").move_cursor_right()
end, { desc = "Go to right window", remap = true })

-- clear terminal window with Cntrl-l
vim.keymap.set("t", "<C-l><C-l>", [[<C-\><C-N>:lua ClearTerm(0)<CR>]], {})
vim.keymap.set("t", "<C-l><C-l><C-l>", [[<C-\><C-N>:lua ClearTerm(1)<CR>]], {})

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
