" vim:fileencoding=utf-8:ft=vim:foldmethod=marker

set nocompatible
set encoding=utf-8
filetype plugin indent on
syntax on
nn <leader><space> :e $MYVIMRC<CR>
let g:level = get(g:, 'level', 100)
" <0: Contest .vimrc
"  0: Minimal settings
" >0: Enable plugins

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

" Install Plugin-Manager {{{
" Auto installs vim-plug plugin manager
" See https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" }}}

" Minimal Contest Config {{{
if g:level == -1
    call plug#begin('~/.vim/plugged')
    Plug 'vim-airline/vim-airline'
    Plug 'enricobacis/vim-airline-clock'
        let g:airline#extensions#clock#format = '%H:%M:%S'
        let g:airline#extensions#clock#updatetime = 1000
        let g:airline#extensions#clock#mode = 'elapsed'
    call plug#end()

    syn on
    filet on
    set ts=4 sts=4 sw=4 et ai mouse=a
    set hls is
    set nu ru ls=2 stal=2 bg=dark
    au FileType cpp nn <F5> :wa<CR>:!g++ -std=c++17 -Wall -fsanitize=address % -o %:r && time ./%:r < in.txt<CR>
    au FileType cpp nn <F6> :!time ./%:r < in.txt<CR>
    colorscheme torte

    finish
endif
" }}} 

" Default Editor Settings {{{
" Look
colorscheme torte
set ruler
set number
set signcolumn=number
set colorcolumn=80
highlight ColorColumn ctermbg=darkgray
set cursorline
set conceallevel=1

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
nnoremap <leader>bd :bd<CR>
nnoremap gb :BufferLineCycleNext<CR>
nnoremap gB :BufferLineCyclePrev<CR>
" These commands will move the current buffer backwards or forwards in the bufferline
nnoremap mb :BufferLineMoveNext<CR>
nnoremap mB :BufferLineMovePrev<CR>

set mouse=a

" Filesystem Drawer
nnoremap <leader>2 :20Lexplore<CR>
let g:netrw_banner=0
let g:netrw_winsize=25
let g:netrw_liststyle=3 " tree style

" Misc
set updatetime=300
set cmdheight=2
set shell=/bin/zsh
" }}}

" Plugins {{{
if g:level > 0
    call plug#begin('~/.vim/plugged')

	if g:level > 80
		Plug 'tpope/vim-sleuth'
		"Plug 'sheerun/vim-polyglot' " really slow for some reason
			" To make vim-tex work properly
			" See https://github.com/sheerun/vim-polyglot/issues/204
			let g:polyglot_disabled = ['latex', 'todo']
	endif
	"Plug 'tpope/vim-sleuth' " replacement?
	"Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
	" doesn't work with markdown :(

    " Cosmetics {{{
    Plug 'luxed/ayu-vim'
        "Plug 'ayu-theme/ayu-vim' " no longer maintained
	"Plug 'Shatur/neovim-ayu' " has some issues with windows
	"Plug 'mhartington/oceanic-next' " another theme?
    Plug 'akinsho/bufferline.nvim'
    Plug 'nvim-lualine/lualine.nvim'
    "Plug 'vim-airline/vim-airline'
    "Plug 'vim-airline/vim-airline-themes'
    "Plug 'enricobacis/vim-airline-clock'
    " Airline Config {{{
        let g:airline_theme='raven'
        let g:airline#extensions#tabline#enabled=1
    " }}}
    Plug 'Yggdroot/indentLine'
    " IndentLine Config {{{
    let g:indentLine_char_list = ['|', '¦', '┆', '┊']
    " }}}
    "Plug 'ryanoasis/vim-devicons'
    Plug 'kyazdani42/nvim-web-devicons' " Recommended (for coloured icons)
    " }}}

    " Dev Tools {{{
    Plug 'liuchengxu/vista.vim'
    " Vista Config {{{
        let g:vista_sidebar_width = 50
        let g:vista_default_executive = 'coc'
        let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
        let g:vista#renderer#enable_icon = 1
        let g:vista#renderer#icons = {
        \   "function": "\uf794",
        \   "variable": "\uf71b",
        \  }
        nnoremap <F3> :Vista!!<CR>
    " }}}
    Plug 'dense-analysis/ale'
    " ALE Config {{{
        let g:ale_linters = {'javascript': ['eslint'], 'python': ['pylint']}
        let g:ale_fixers = {'javascript': ['eslint'], 'python': ['pylint']}
        let g:ale_sign_column_always = 1
        let g:ale_sign_error = '❌'
        "let g:ale_sign_warning = '⚡'
        let g:ale_sign_warning = '💡'
        highlight clear ALEErrorSign
        highlight clear ALEWarningSign
        let g:airline#extensions#ale#enabled = 1
    " }}}
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " CoC Config {{{
        let g:coc_global_extensions = ['coc-json', 'coc-git', 'coc-pyright', 'coc-rust-analyzer', 'coc-vimtex', 'coc-java']
        "" Use `[g` and `]g` to navigate diagnostics
        "" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
        "nmap <silent> [g <Plug>(coc-diagnostic-prev)
        "nmap <silent> ]g <Plug>(coc-diagnostic-next)
        "
        "" GoTo code navigation.
        "nmap <silent> gd <Plug>(coc-definition)
        "nmap <silent> gy <Plug>(coc-type-definition)
        "nmap <silent> gi <Plug>(coc-implementation)
        "nmap <silent> gr <Plug>(coc-references)

        "" Symbol renaming.
        "nmap <leader>rn <Plug>(coc-rename)

        "" Formatting selected code.
        "xmap <leader>f  <Plug>(coc-format-selected)
        "nmap <leader>f  <Plug>(coc-format-selected)

        "" Applying codeAction to the selected region.
        "" Example: `<leader>aap` for current paragraph
        "xmap <leader>a  <Plug>(coc-codeaction-selected)
        "nmap <leader>a  <Plug>(coc-codeaction-selected)

        "" Remap keys for applying codeAction to the current buffer.
        "nmap <leader>ac  <Plug>(coc-codeaction)
        "" Apply AutoFix to problem on the current line.
        "nmap <leader>qf  <Plug>(coc-fix-current)

        "" Use tab for trigger completion with characters ahead and navigate.
        "" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
        "" other plugin before putting this into your config.
        "inoremap <silent><expr> <TAB>
        "            \ coc#pum#visible() ? coc#pum#next(1):
        "            \ CheckBackspace() ? "\<Tab>" :
        "            \ coc#refresh()
        "inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

        "" Make <CR> auto-select the first completion item and notify coc.nvim to
        "" format on enter, <cr> could be remapped by other vim plugin
        "inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
        "                          \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

        "function! CheckBackspace() abort
        "    let col = col('.') - 1
        "    return !col || getline('.')[col - 1]  =~# '\s'
        "endfunction

        "" Use <c-space> to trigger completion.
        "if has('nvim')
        "    inoremap <silent><expr> <c-space> coc#refresh()
        "else
        "    inoremap <silent><expr> <c-@> coc#refresh()
        "endif

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

        autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')
        autocmd BufWritePre *.go :call CocAction('format')
        autocmd FileType go nmap gtj :CocCommand go.tags.add json<cr>
        autocmd FileType go nmap gty :CocCommand go.tags.add yaml<cr>
        autocmd FileType go nmap gtx :CocCommand go.tags.clear<cr>
    " }}}
    "Plug 'github/copilot.vim'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    " }}}

    " Filesystem Navigation {{{
    Plug 'liuchengxu/vim-clap', { 'do': { -> clap#installer#force_download() } }
    "    nn <C-p> :Clap files<CR>
    "    nn <C-space> :Clap quick_open<CR>
    "    let g:clap_provider_quick_open = {
    "                \ 'source': ['~/.config/nvim/init.vim', '~/.zshrc'],
    "                \ 'sink': 'e',
    "                \ 'description': 'Quick open some dotfiles',
    "                \ }
    Plug 'ctrlpvim/ctrlp.vim'
    " CtrlP Config {{{
        let g:ctrlp_map = '<c-p>'
        let g:ctrlp_cmd = 'CtrlP'
        let g:ctrlp_working_path_mode = 'ra'
        set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
        set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows

        let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
        "let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
        let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
    " }}}
    "Plug 'scrooloose/nerdtree'
    " NERDTree Config {{{
        let g:NERDTreeWinPos = "left"
        let g:NERDTreeWinSize = 25
        let g:NERDTreeQuitOnOpen = 0
        let g:NERDTreeMinimalUI = 0
        "noremap <F2> :NERDTreeToggle<cr>
        nnoremap <F2> :NvimTreeToggle<CR>
    " }}}
    Plug 'kyazdani42/nvim-tree.lua'
    " }}}

    " Editor Upgrades {{{
    Plug 'tpope/vim-surround'
    "Plug 'sirver/ultisnips'
    "    let g:UltiSnipsExpandTrigger = '<tab>'
    "    let g:UltiSnipsJumpForwardTrigger = '<tab>'
    "    let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
    Plug 'godlygeek/tabular'
    " Tabular Config {{{
        " See https://gist.github.com/tpope/287147
        vn  <leader>:   :Tabularize/:\zs/<CR>
        ino <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

        function! s:align()
          let p = '^\s*|\s.*\s|\s*$'
          if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
            let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
            let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
            Tabularize/|/l1
            normal! 0
            call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
          endif
        endfunction
    " }}}
    " }}}

    " FileType Addons {{{
    " LaTeX {{{
    Plug 'lervag/vimtex'
        let g:tex_flavor='latex'
        let g:vimtex_view_method='zathura'
        let g:vimtex_quickfix_mode=0
        let g:vimtex_fold_enabled=1
    Plug 'KeitaNakamura/tex-conceal.vim'
        let g:tex_conceal='abdmg'
    " }}}
    " Markdown {{{
    Plug 'plasticboy/vim-markdown' " is included in vim-polyglot
    " vim-markdown config {{{
        let g:vim_markdown_folding_disabled = 1
        let g:vim_markdown_frontmatter = 1 " for Hugo Blog Posts
        let g:vim_markdown_conceal_code_blocks = 0
        let g:vim_markdown_strikethrough = 1
        let g:vim_markdown_math = 1
    " }}}
    Plug 'ferrine/md-img-paste.vim'
        let g:mdip_imgdir = 'img'
    Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  } " need node.js and yarn
        let g:mkdp_browser = 'qutebrowser'
        "let g:mkdp_markdown_css = ''
    Plug 'junegunn/goyo.vim'
    Plug 'junegunn/limelight.vim'
        autocmd! User GoyoEnter Limelight
        autocmd! User GoyoLeave Limelight!
    " }}}
    " Golang {{{
    " }}} 
    " Coq {{{
    Plug 'whonore/Coqtail'
    " }}}
    " }}}

    " Specials {{{
    Plug 'jamessan/vim-gnupg'
    " }}}
    call plug#end()

    set background=dark
    let ayucolor="dark"   " or light or mirage
    colorscheme ayu
    "colorscheme OceanicNext
endif
" }}}

" Language specific options {{{
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

autocmd filetype c        call SetCOptions()
autocmd filetype cpp      call SetCppOptions()
autocmd filetype java     nnoremap <buffer> <F5> :w<CR>:!javac % && java %:r <CR>
"autocmd filetype python   nnoremap <buffer> <F5> :w<CR>:!python3 %<CR>
autocmd filetype python   call SetPythonOptions()
" Robotics stuff
"autocmd filetype python   nnoremap <buffer> <C-d> :w<CR>:!/home/lyc/Dropbox/Main/Code/Robotics/download.sh % <CR>
"autocmd filetype python   nnoremap <buffer> <C-r> :w<CR>:!/home/lyc/Dropbox/Main/Code/Robotics/downloadAndRun.sh % <CR>
autocmd filetype julia    nnoremap <buffer> <F5> :w<CR>:!julia %<CR>
autocmd filetype tex      call SetTexOptions()
autocmd filetype pug,html,css,javascript,typescript,vue call SetWebOptions()
autocmd filetype sh       nnoremap <buffer> <F5> :w<CR>:!chmod +x % &&./%<CR>
autocmd filetype markdown call SetMarkdownOptions()
autocmd filetype coq      call SetCoqOptions()

" ocaml
let g:opamshare = substitute(system('opam var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"

function SetCOptions()
    let &g:makeprg="(gcc -o %:r %:r.c -std=c99 -Wall -lm)"
    nn  <buffer> <F9> <ESC>:wa<CR>:make!<CR>:vertical botright copen 50<CR>
    nn  <buffer> <F5> <ESC>:!time ./%:r<CR>
    nn  <buffer> <F6> <ESC>:!time ./%:r < %:r.in<CR>
endfunction

function SetCppOptions()
    " fsanitize debugs null pointer exceptions
    let &g:makeprg="(g++ -o %:r %:r.cpp -O2 -std=c++17 -Wall -fsanitize=address)"
    nn  <buffer> <F5> <ESC>:wa<CR>:make!<CR>:copen<CR>
    nn  <buffer> <F6> <ESC>:!time ./%:r < in.txt<CR>
    "nn  <buffer> <F6> <ESC>:terminal time ./%:r < in.txt<CR>
    nn  <buffer> <F8> :w<CR>:!g++ -std=c++17 -Wall -fsanitize=address grader.cpp % -o %:r<CR>
    nn  <buffer> <F9> :w<CR>:!g++ -std=c++17 -Wall -fsanitize=address grader.cpp % -o %:r && time ./%:r < in.txt<CR>
    let g:airline#extensions#clock#format = '%H:%M:%S'
    let g:airline#extensions#clock#updatetime = 1000
    let g:airline#extensions#clock#mode = 'elapsed'
    nn  <leader>i :30vs in.txt<CR><ESC>GA
endfunction

tnoremap <Esc> <C-\><C-n>
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" navigation
function SetPythonOptions()
    augroup Terminal
        au!
        au TermOpen * let g:last_terminal_job_id = b:terminal_job_id
    augroup END

    function! s:get_visual_selection()
        " Why is this not a built-in Vim script function?!
        let [line_start, column_start] = getpos("'<")[1:2]
        let [line_end, column_end] = getpos("'>")[1:2]
        let lines = getline(line_start, line_end)
        if len(lines) == 0
            return ''
        endif
        let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
        let lines[0] = lines[0][column_start - 1:]
        return join(lines, "\n")
    endfunction

    function! REPLSend(lines)
        call jobsend(g:last_terminal_job_id, a:lines[0])
        call jobsend(g:last_terminal_job_id, "\r") " needed for the way REPL handles the input
    endfunction

    command! REPLSendLine call REPLSend([getline('.')])
    command! REPLSendSelection call REPLSend([s:get_visual_selection() . "\r"])

    nnoremap <buffer> <F5> :w<CR>:!python3 %<CR>
    nnoremap <buffer> <F6> :vs term://zsh -c python3<CR>
        \ :let g:terminal_job_id = b:terminal_job_id<CR>
        \ <C-w>r<C-w>h
        \ :echom "launched terminal (id=" . g:terminal_job_id . ")"<CR>
    nnoremap <buffer> <C-s> :REPLSendLine<CR>
    vnoremap <buffer> <C-s> :<C-U>REPLSendSelection<CR>
        \ :echom "[" . strftime("%Y-%m-%d %H:%M:%S") . "] sent selection!"<CR>
endfunction

function SetTexOptions()
    nnoremap <buffer> <F5> :w<CR>:VimtexCompile <CR>
    if empty(v:servername) && exists('*remote_startserver')
        call remote_startserver('VIM')
    endif
endfunction

function SetWebOptions()
    iabbrev </ </<C-X><C-O>
    iabbrev GET router.get('', function(req, res, next) {
    iabbrev POST router.post('', function(req, res, next) {
endfunction

function SetMarkdownOptions()
    nn <buffer><silent> <leader>p :call mdip#MarkdownClipboardImage()<CR>
    nn <buffer> <F5> :w<CR>:MarkdownPreview<CR>
endfunction

function SetCoqOptions()
    nn <leader><CR> :CoqNext<CR>
    ino <leader><CR> <ESC>:CoqNext<CR>
    nn <leader><BS> :CoqUndo<CR>
    ino <leader><BS> <ESC>:CoqUndo<CR>

    set ts=2 sts=2 sw=2 expandtab

    augroup CoqtailHighlights
        autocmd!
        autocmd ColorScheme *
            \  hi def CoqtailChecked ctermbg=236
            \| hi def CoqtailSent    ctermbg=237
    augroup END
endfunction
" }}}

lua <<EOF
-- require('navigator').setup {}

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

  rainbow = {
    enable = true,
    colors = require('ayu').rainbow_colors
  }
}

require('nvim-tree').setup {}

require('bufferline').setup {
    options = {
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left"
          }
        }
    }
}

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
  }
}
EOF

silent! source config.vim   " to allow for project specific settings
echom "flush: Started Vim level " . g:level . "!"
