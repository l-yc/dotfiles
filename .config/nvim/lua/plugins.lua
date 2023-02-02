require('packer').startup(function(use)
-- Packer can manage itself
use 'wbthomason/packer.nvim'
-- Dev {{{
use {'neoclide/coc.nvim', branch = 'release'}
use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
-- }}}
-- Navigation {{{
use {'nvim-tree/nvim-tree.lua', requires = 'nvim-tree/nvim-web-devicons', tag = 'nightly'}
use {'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = 'nvim-lua/plenary.nvim'}
-- }}}
-- Indicators {{{
--use {'akinsho/bufferline.nvim', tag = "v3.*", requires = 'nvim-tree/nvim-web-devicons'}
use {'akinsho/bufferline.nvim', requires = 'nvim-tree/nvim-web-devicons'}
use {'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true }}
use 'lukas-reineke/indent-blankline.nvim'
-- }}}
-- Colorschemes {{{
use 'folke/tokyonight.nvim'
use 'rebelot/kanagawa.nvim'
use 'ellisonleao/gruvbox.nvim'
-- }}}
-- File specific {{{
--use {'lervag/vimtex', ft={'tex'}}
--use 'whonore/Coqtail'
--use {'whonore/Coqtail', ft={'verilog'}}
-- }}}
end)

-- Plugin Config {{{
require('nvim-treesitter.configs').setup {
	-- One of "all", "maintained" (parsers with maintainers), or a list of languages
	ensure_installed = "all",

	-- Install languages synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- List of parsers to ignore installing
	ignore_install = {},

	highlight = {
		-- `false` will disable the whole extension
		enable = true,

		-- list of language that will be disabled
		disable = {},

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
}

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require("nvim-tree").setup()

require('bufferline').setup {
	options = {
		diagnostics = "coc",
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

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
  }
}

vim.opt.list = true
vim.opt.listchars:append "space:⋅"
--vim.opt.listchars:append "eol:↴"

require("indent_blankline").setup {
	space_char_blankline = " ",
	show_current_context = true,
	show_current_context_start = true,
}
-- }}}
