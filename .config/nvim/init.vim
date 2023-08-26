" vim:fileencoding=utf-8:ft=vim:foldmethod=marker

set nocompatible
set encoding=utf-8
filetype plugin indent on
syntax on
nn <leader><space> :e $MYVIMRC<CR>
let g:level = get(g:, 'level', 100)

" Kitty Terminal Drawing {{{
" vim hardcodes background color erase even if the terminfo file does
" not contain bce (not to mention that libvte based terminals
" incorrectly contain bce in their terminfo files). This causes
" incorrect background rendering when using a color theme with a
" background color.
" See https://github.com/kovidgoyal/kitty/issues/108
let &t_ut=''

" Reload syntax highlighting
" See https://github.com/vim/vim/issues/2790
nn <leader>l :syntax sync fromstart<CR>
set redrawtime=10000
set termguicolors
" }}}
" Default Editor Settings {{{
" Look
set ruler
set number
set signcolumn=number
set colorcolumn=80
highlight ColorColumn ctermbg=darkgray
set cursorline
"set conceallevel=1

" Search
set hlsearch
set incsearch

" Folds
set foldenable
set foldmethod=marker

" Editing
set noautoindent
set smartindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
"set spell
inoremap <C-f> {<CR>}<C-o>O
nnoremap <Leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>

" Navigation
nnoremap 0 ^
"nnoremap <leader>bn :bn<CR>
"nnoremap <leader>bN :bN<CR>

set mouse=a

" Misc
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

if g:level > 0
	" Plugins (vim-plug)
	" Install Plugin-Manager {{{
	" Auto installs vim-plug plugin manager
	" See https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
	let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
	if empty(glob(data_dir . '/autoload/plug.vim'))
		silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
		autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
	endif
	" }}}
	call plug#begin('~/.vim/plugged')
    Plug 'lervag/vimtex'
        let g:tex_flavor='latex'
        let g:vimtex_view_method='zathura'
        let g:vimtex_quickfix_mode=0
        let g:vimtex_fold_enabled=1
    Plug 'KeitaNakamura/tex-conceal.vim'
        let g:tex_conceal='abdmg'
	Plug 'whonore/Coqtail'
    Plug 'jamessan/vim-gnupg'
	call plug#end()

	" Plugins (packer.nvim):
	" git clone --depth 1 https://github.com/wbthomason/packer.nvim\
	" ~/.local/share/nvim/site/pack/packer/start/packer.nvim
	" Run `:PackerInstall` after downloading
	lua require('plugins')

	" Plugin Bindings
	" Coc {{{
	" TODO this is still quite janky -- would like to clean it up a little
	let g:coc_global_extensions = ['coc-json', 'coc-git', 'coc-pyright', 'coc-rust-analyzer', 'coc-vimtex', 'coc-java']
	" Use `[g` and `]g` to navigate diagnostics
	" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
	nmap <silent> [g <Plug>(coc-diagnostic-prev)
	nmap <silent> ]g <Plug>(coc-diagnostic-next)

	" GoTo code navigation.
	nmap <silent> gd <Plug>(coc-definition)
	nmap <silent> gy <Plug>(coc-type-definition)
	nmap <silent> gi <Plug>(coc-implementation)
	nmap <silent> gr <Plug>(coc-references)

	" Symbol renaming.
	nmap <leader>rn <Plug>(coc-rename)

	" Formatting selected code.
	xmap <leader>f  <Plug>(coc-format-selected)
	nmap <leader>f  <Plug>(coc-format-selected)

	" Applying codeAction to the selected region.
	" Example: `<leader>aap` for current paragraph
	xmap <leader>a  <Plug>(coc-codeaction-selected)
	nmap <leader>a  <Plug>(coc-codeaction-selected)

	" Remap keys for applying codeAction to the current buffer.
	nmap <leader>ac  <Plug>(coc-codeaction)
	" Apply AutoFix to problem on the current line.
	nmap <leader>qf  <Plug>(coc-fix-current)

	" Use tab for trigger completion with characters ahead and navigate.
	" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
	" other plugin before putting this into your config.
	inoremap <silent><expr> <TAB>
				\ coc#pum#visible() ? coc#pum#next(1):
				\ CheckBackspace() ? "\<Tab>" :
				\ coc#refresh()
	inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

	" Make <CR> auto-select the first completion item and notify coc.nvim to
	" format on enter, <cr> could be remapped by other vim plugin
	inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
				\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

	function! CheckBackspace() abort
		let col = col('.') - 1
		return !col || getline('.')[col - 1]  =~# '\s'
	endfunction

	" Use <c-space> to trigger completion.
	if has('nvim')
		inoremap <silent><expr> <c-space> coc#refresh()
	else
		inoremap <silent><expr> <c-@> coc#refresh()
	endif

	" Use tab for trigger completion with characters ahead and navigate.
	" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
	" other plugin before putting this into your config.
	inoremap <silent><expr> <TAB>
				\ coc#pum#visible() ? coc#pum#next(1):
				\ CheckBackspace() ? "\<Tab>" :
				\ coc#refresh()
	inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

	" Make <CR> to accept selected completion item or notify coc.nvim to format
	" <C-g>u breaks current undo, please make your own choice.
	inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
				\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

	function! CheckBackspace() abort
		let col = col('.') - 1
		return !col || getline('.')[col - 1]  =~# '\s'
	endfunction

	" Use <c-space> to trigger completion.
	if has('nvim')
		inoremap <silent><expr> <c-space> coc#refresh()
	else
		inoremap <silent><expr> <c-@> coc#refresh()
	endif

	" Use `[g` and `]g` to navigate diagnostics
	" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
	nmap <silent> [g <Plug>(coc-diagnostic-prev)
	nmap <silent> ]g <Plug>(coc-diagnostic-next)

	" GoTo code navigation.
	nmap <silent> gd <Plug>(coc-definition)
	nmap <silent> gy <Plug>(coc-type-definition)
	nmap <silent> gi <Plug>(coc-implementation)
	nmap <silent> gr <Plug>(coc-references)

	" Use K to show documentation in preview window.
	nnoremap <silent> K :call ShowDocumentation()<CR>

	function! ShowDocumentation()
		if CocAction('hasProvider', 'hover')
			call CocActionAsync('doHover')
		else
			call feedkeys('K', 'in')
		endif
	endfunction

	" Highlight the symbol and its references when holding the cursor.
	autocmd CursorHold * silent call CocActionAsync('highlight')

	" Symbol renaming.
	nmap <leader>rn <Plug>(coc-rename)

	" Formatting selected code.
	xmap <leader>f  <Plug>(coc-format-selected)
	nmap <leader>f  <Plug>(coc-format-selected)

	augroup mygroup
		autocmd!
		" Setup formatexpr specified filetype(s).
		autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
		" Update signature help on jump placeholder.
		autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
	augroup end

	" Applying codeAction to the selected region.
	" Example: `<leader>aap` for current paragraph
	xmap <leader>a  <Plug>(coc-codeaction-selected)
	nmap <leader>a  <Plug>(coc-codeaction-selected)

	" Remap keys for applying codeAction to the current buffer.
	nmap <leader>ac  <Plug>(coc-codeaction)
	" Apply AutoFix to problem on the current line.
	nmap <leader>qf  <Plug>(coc-fix-current)

	" Run the Code Lens action on the current line.
	nmap <leader>cl  <Plug>(coc-codelens-action)

	" Map function and class text objects
	" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
	xmap if <Plug>(coc-funcobj-i)
	omap if <Plug>(coc-funcobj-i)
	xmap af <Plug>(coc-funcobj-a)
	omap af <Plug>(coc-funcobj-a)
	xmap ic <Plug>(coc-classobj-i)
	omap ic <Plug>(coc-classobj-i)
	xmap ac <Plug>(coc-classobj-a)
	omap ac <Plug>(coc-classobj-a)

	" Remap <C-f> and <C-b> for scroll float windows/popups.
	if has('nvim-0.4.0') || has('patch-8.2.0750')
		nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
		nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
		inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
		inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
		vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
		vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
	endif

	" Use CTRL-S for selections ranges.
	" Requires 'textDocument/selectionRange' support of language server.
	nmap <silent> <C-s> <Plug>(coc-range-select)
	xmap <silent> <C-s> <Plug>(coc-range-select)

	" Add `:Format` command to format current buffer.
	command! -nargs=0 Format :call CocActionAsync('format')

	" Add `:Fold` command to fold current buffer.
	command! -nargs=? Fold :call     CocAction('fold', <f-args>)

	" Add `:OR` command for organize imports of the current buffer.
	command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

	" Add (Neo)Vim's native statusline support.
	" NOTE: Please see `:h coc-status` for integrations with external plugins that
	" provide custom statusline: lightline.vim, vim-airline.
	set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

	" Mappings for CoCList
	" Show all diagnostics.
	nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
	" Manage extensions.
	nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
	" Show commands.
	nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
	" Find symbol of current document.
	nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
	" Search workspace symbols.
	nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
	" Do default action for next item.
	nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
	" Do default action for previous item.
	nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
	" Resume latest coc list.
	nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

	"autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')
	"autocmd BufWritePre *.go :call CocAction('format')
	"autocmd FileType go nmap gtj :CocCommand go.tags.add json<cr>
	"autocmd FileType go nmap gty :CocCommand go.tags.add yaml<cr>
	"autocmd FileType go nmap gtx :CocCommand go.tags.clear<cr>
	" }}}
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
	nnoremap <leader>bd :bd<CR>
	nnoremap gb :BufferLineCycleNext<CR>
	nnoremap gB :BufferLineCyclePrev<CR>
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
else
	colorscheme torte
endif

silent! source config.vim   " to allow for project specific settings
echom "flush: Started Vim level " . g:level . "!"
