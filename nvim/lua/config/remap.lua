vim.g.mapleader = " "

-- View netrw directory explorer.
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Trigger formatter.
vim.keymap.set({ "n", "v" }, "<leader>f", function()
	local conform = require("conform")
	conform.format({
		lsp_fallback = true,
		async = false,
		timeout_ms = 5000,
	})
end, { desc = "Format file or range (in visual mode)" })

-- Get Git status.
vim.keymap.set({ "n" }, "<leader>gs", function()
	vim.cmd.Git()
end, { desc = "See Git project information" })

-- Set up harpoon.
vim.keymap.set({ "n" }, "<leader>ha", function()
	require("harpoon.mark").add_file()
end, { desc = "Mark file with harpoon" })
vim.keymap.set({ "n" }, "<leader>hn", function()
	require("harpoon.ui").nav_next()
end, { desc = "Go to next harpoon mark" })
vim.keymap.set({ "n" }, "<leader>hp", function()
	require("harpoon.ui").nav_prev()
end, { desc = "Go to previous harpoon mark" })
vim.keymap.set({ "n" }, "<leader>hm", function()
	require("harpoon.ui").toggle_quick_menu()
end, { desc = "Show harpoon marks" })
vim.keymap.set("n", "<leader>1", function()
	require("harpoon.ui").nav_file(1)
end)
vim.keymap.set("n", "<leader>2", function()
	require("harpoon.ui").nav_file(2)
end)
vim.keymap.set("n", "<leader>3", function()
	require("harpoon.ui").nav_file(3)
end)
vim.keymap.set("n", "<leader>4", function()
	require("harpoon.ui").nav_file(4)
end)
vim.keymap.set("n", "<leader>5", function()
	require("harpoon.ui").nav_file(5)
end)
vim.keymap.set("n", "<leader>6", function()
	require("harpoon.ui").nav_file(6)
end)
vim.keymap.set("n", "<leader>7", function()
	require("harpoon.ui").nav_file(7)
end)
vim.keymap.set("n", "<leader>8", function()
	require("harpoon.ui").nav_file(8)
end)
vim.keymap.set("n", "<leader>9", function()
	require("harpoon.ui").nav_file(9)
end)

-- Telescope keymaps.
vim.keymap.set({ "n" }, "<leader>pf", function()
	require("telescope.builtin").find_files()
end, { desc = "Project find" })
vim.keymap.set({ "n" }, "<leader>gf", function()
	require("telescope.builtin").git_files()
end, { desc = "Git find" })
vim.keymap.set({ "n" }, "<leader>pg", function()
	require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
end, { desc = "Project grep" })

-- Undo tree.
vim.keymap.set("n", "<leader>u", function()
	vim.cmd.UndotreeToggle()
end, { desc = "Toggle undo tree panel" })
