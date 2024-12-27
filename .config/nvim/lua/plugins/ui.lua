return {
	{
		"folke/tokyonight.nvim",
		lazy = true,
	},
	{
		'akinsho/bufferline.nvim',
		version = '*',
		dependencies = {
			'nvim-tree/nvim-web-devicons',
		},
		config = function()
			vim.opt.termguicolors = true
			require('bufferline').setup {
				options = {
					offsets = {
						{
							filetype = "NvimTree",
							text = "File Explorer",
							highlight = "Directory",
							text_align = "left",
						}
					},
				}
			}
		end,
	},
	{
		'nvim-lualine/lualine.nvim', 
		dependencies = {
			'kyazdani42/nvim-web-devicons',
		},
		config = function()
			require('lualine').setup {
				options = {
					icons_enabled = true,
					theme = 'auto',
				}
			}
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
	}
}
