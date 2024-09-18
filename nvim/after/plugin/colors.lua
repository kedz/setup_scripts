function SetColors(color)
	require('rose-pine').setup({
	--- @usage 'auto'|'main'|'moon'|'dawn'
		variant = 'moon',
	})
       color = color or "rose-pine"
       vim.cmd.colorscheme(color)

       vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
       vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

SetColors()
