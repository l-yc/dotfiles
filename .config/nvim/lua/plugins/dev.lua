return {
	-- {
	-- 	'github/copilot.nvim',
	-- },
	{
		'tpope/vim-sleuth',
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = function()
			require("nvim-treesitter.install").update({ with_sync = true })()
		end,
		config = function()
			require("nvim-treesitter.configs").setup {
				ensure_installed = { "lua", "vim", "vimdoc", "c", "cpp", "python", "bash", "markdown", "markdown_inline", "typescript", "tsx", "javascript" },
				highlight = { enable = true },
				indent = { enable = true },
			}
		end,
	},
	{
		'nvim-treesitter/nvim-treesitter-context',
	}
}
