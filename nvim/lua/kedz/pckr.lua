local function bootstrap_pckr()
	local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"

	if not (vim.uv or vim.loop).fs_stat(pckr_path) then
		print("Installing pckr")
		vim.fn.system({
			'git',
			'clone',
			"--filter=blob:none",
			'https://github.com/lewis6991/pckr.nvim',
			pckr_path
		})
	end
	vim.opt.rtp:prepend(pckr_path)
end

bootstrap_pckr()

require('pckr').add{
	{
		'nvim-telescope/telescope.nvim', tag = '0.1.8',
		-- or                            , branch = '0.1.x',
		requires = { {'nvim-lua/plenary.nvim'} }
	};
	{ "rose-pine/neovim", name = "rose-pine" };
	{ "nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" } };
	{ "nvim-treesitter/playground" };
	{ "theprimeagen/harpoon" };
	{ "mbbill/undotree" };
	{ "tpope/vim-fugitive" };
}

