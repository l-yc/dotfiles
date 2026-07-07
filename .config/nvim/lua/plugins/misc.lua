return {
	{
		'lervag/vimtex',
		config = function()
			vim.cmd[[
				let g:tex_flavor='latex'
				let g:vimtex_view_method='zathura'
				let g:vimtex_quickfix_mode=0
				let g:vimtex_fold_enabled=1
			]]
		end,
	},
	{
		'KeitaNakamura/tex-conceal.vim',
		config = function()
			vim.cmd[[
				let g:tex_conceal='abdmg'
			]]
		end,
	},
	{
		'whonore/Coqtail',
	},
	{
		'jamessan/vim-gnupg',
	},
	{
		'Olical/conjure',
	},
}
