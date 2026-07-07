-- vim:fileencoding=utf-8:ft=lua:foldmethod=marker

require("config.lazy")

vim.cmd [[
	nn <leader><space> :e $MYVIMRC<CR>
	let g:level = get(g:, 'level', 100)

	" Look {{{
	set ruler
	set number
	set signcolumn=number
	set colorcolumn=80
	highlight ColorColumn ctermbg=darkgray
	set cursorline
	"set conceallevel=1
	" }}}
	" Search {{{
	set hlsearch
	set incsearch
	" }}}
	" Folds {{{
	set foldenable
	set foldmethod=marker
	" }}}
	" Editing {{{
	set noautoindent
	set smartindent
	set tabstop=4
	set softtabstop=4
	set shiftwidth=4
	"set spell
	inoremap <C-f> {<CR>}<C-o>O
	nnoremap <Leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>
	" }}}
	" Navigation {{{
	nnoremap 0 ^
	"nnoremap <leader>bn :bn<CR>
	"nnoremap <leader>bN :bN<CR>
	set mouse=a
	" }}}
	" Misc {{{
	set updatetime=300
	set cmdheight=2
	set shell=/bin/zsh
	" }}}
	" Templates {{{
	function AddTemplate(tmpl_file)
	    exe "0read " . a:tmpl_file
	    let substDict = {}
	    let substDict["title"] = "New Entry"
	    let substDict["author"] = $USER
	    let substDict["date"] = strftime("%FT%T%z")
	    exe '%s/{{\([^>]*\)}}/\=substDict[submatch(1)]/g'
	    set nomodified
	    normal G
	endfunction

	augroup templates
	    autocmd BufNewFile *.cpp 0r ~/Templates/ans.cpp
	    autocmd BufNewFile *.html 0r ~/Templates/page.html
	    autocmd BufNewFile *.tex 0r ~/Templates/doc.tex
	    autocmd BufNewFile *.md call AddTemplate("~/Templates/entry.md")
	augroup END
	" }}}

	" Plugin Keybindings
	" Tree {{{
	nnoremap <F2> :NvimTreeToggle<CR>
	" }}}
	" Telescope {{{
	" Find files using Telescope command-line sugar.
	nnoremap <leader>ff <cmd>Telescope find_files<cr>
	nnoremap <leader>fg <cmd>Telescope live_grep<cr>
	nnoremap <leader>fb <cmd>Telescope buffers<cr>
	nnoremap <leader>fh <cmd>Telescope help_tags<cr>
	" }}}
	" Bufferline {{{
	nnoremap <leader>db :bd<CR>
	nnoremap gb :BufferLineCycleNext<CR>
	nnoremap gB :BufferLineCyclePrev<CR>
	nnoremap <leader><tab> :BufferLineCycleNext<CR>
	nnoremap <leader><S-tab> :BufferLineCyclePrev<CR>
	" These commands will move the current buffer backwards or forwards in the bufferline
	nnoremap mb :BufferLineMoveNext<CR>
	nnoremap mB :BufferLineMovePrev<CR>
	" }}}

	" Filetype
	" LaTeX {{{
	autocmd filetype tex      call SetTexOptions()
	function SetTexOptions()
		nnoremap <buffer> <F5> :w<CR>:VimtexCompile <CR>
		if empty(v:servername) && exists('*remote_startserver')
			call remote_startserver('VIM')
		endif
	endfunction
	" }}}
	" Coq {{{
	autocmd filetype coq      call SetCoqOptions()
	function SetCoqOptions()
		nn <CR> :CoqNext<CR>
		ino <leader><CR> <ESC>:CoqNext<CR>
		"nn <leader><BS> :CoqUndo<CR>
		nn <BS> :CoqUndo<CR>
		ino <leader><BS> <ESC>:CoqUndo<CR>
		set ts=2 sts=2 sw=2 expandtab
	endfunction
	" For some reason, the highlighting only works if set before colorscheme
	augroup CoqtailHighlights
		autocmd!
		autocmd ColorScheme *
					\ hi def CoqtailChecked guibg=SeaGreen
					\| hi def CoqtailSent    ctermbg=2 guibg=DarkGreen
	augroup END
	" }}}
	" C++ {{{
	autocmd filetype cpp      call SetCppOptions()
	function SetCppOptions()
		" fsanitize debugs null pointer exceptions
		"nnoremap <F5> :w<CR>:!g++ -std=c++17 -fsanitize=address % -o %:r && ./%:r<CR>
		"nnoremap <F8> :w<CR>:!g++ -std=c++17 -fsanitize=address -g -D_GLIBCXX_DEBUG % && gdb a.out <CR>
		"let &g:makeprg="(g++ -o %:r %:r.cpp -O2 -std=c++17 -Wall -fsanitize=address && time ./%:r < %:r.in)"

		"nn  <buffer> <F5> <ESC>:wa<CR>:make!<CR>:copen<CR>
		"nn  <buffer> <F6> <ESC>:!time ./%:r < in.txt<CR>

		"" fancy rewrite using kitty
		"let g:cmd = 'kitty @ launch --cwd=current --type=window --keep-focus bash -c "'
		"let g:endcmd="read -p 'Press enter to continue'\""
		"let g:compile=g:cmd . 'g++ -o %s %s.cpp -O2 -std=c++17 -Wall -fsanitize=address && time ./%s < in.txt; ' . g:endcmd
		"let g:run=g:cmd . 'time ./%s < in.txt; ' . g:endcmd
		"nn  <buffer> <F5> <ESC>:wa<CR>:call system(printf(compile, expand('%:r'), expand('%:r'), expand('%:r')))<CR>
		"nn  <buffer> <F6> <ESC>:wa<CR>:call system(printf(run, expand('%:r')))<CR>
		"nn  <buffer> <F8> :w<CR>:!g++ -std=c++17 -Wall -fsanitize=address grader.cpp % -o %:r<CR>
		"nn  <buffer> <F9> :w<CR>:!g++ -std=c++17 -Wall -fsanitize=address grader.cpp % -o %:r && time ./%:r < in.txt<CR>
		"let g:airline#extensions#clock#format = '%H:%M:%S'
		"let g:airline#extensions#clock#updatetime = 1000
		"let g:airline#extensions#clock#mode = 'elapsed'

		" back to make
		let &g:makeprg="(g++ -o %:r %:r.cpp -O2 -std=c++17 -Wall -fsanitize=address && time ./%:r < %:r.in)"
		nn  <buffer> <F5> <ESC>:wa<CR>:make!<CR>:copen<CR>
		nn  <buffer> <F6> <ESC>:!time ./%:r < ./%:r.in<CR>

		nn  <leader>i   :30vs ./%:r.in<CR><ESC>GA
	endfunction
	" }}}


	" Colorscheme {{{	
	set background=dark
	colorscheme tokyonight
	"colorscheme tokyonight-night
	"colorscheme tokyonight-storm
	"colorscheme tokyonight-day
	"colorscheme tokyonight-moon
	"colorscheme kanagawa
	"colorscheme gruvbox
	" }}}


	silent! source config.vim   " to allow for project specific settings
	echom "flush: Started Vim level " . g:level . "!"

]]

-- ocp-indent (OCaml): prepend to runtimepath. Plain :set treats the quotes
-- literally, so do it in Lua to get a clean, expanded path.
vim.opt.rtp:prepend(vim.fn.expand("~/.opam/caml_money/share/ocp-indent/vim"))
