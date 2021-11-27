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
inoremap <C-f> {<CR>}<C-o>O
nnoremap <Leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>

" Navigation
nnoremap 0 ^
nnoremap <leader>bn :bn<CR>
nnoremap <leader>bN :bN<CR>
nnoremap <leader>bd :bd<CR>
nnoremap gb :bn<CR>
nnoremap gB :bN<CR>
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

    Plug 'sheerun/vim-polyglot'
        "let g:polyglot_disabled = ['latex']

    " Cosmetics {{{
    Plug 'ayu-theme/ayu-vim'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'enricobacis/vim-airline-clock'
    " Airline Config {{{
        let g:airline_theme='raven'
        let g:airline#extensions#tabline#enabled=1
    " }}}
    Plug 'Yggdroot/indentLine'
    " IndentLine Config {{{
    let g:indentLine_char_list = ['|', '¦', '┆', '┊']
    " }}}
    Plug 'ryanoasis/vim-devicons'
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
        nnoremap <leader>3 :Vista!!<CR>
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

        " Make <CR> auto-select the first completion item and notify coc.nvim to
        " format on enter, <cr> could be remapped by other vim plugin
        inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                                  \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

    " }}}
    " }}}

    " Filesystem Navigation {{{
    Plug 'ctrlpvim/ctrlp.vim'
    " CtrlP Config {{{
        let g:ctrlp_map = '<c-p>'
        let g:ctrlp_cmd = 'CtrlP'
        let g:ctrlp_working_path_mode = 'ra'
        set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
        set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows

        let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
        let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
    " }}}
    Plug 'scrooloose/nerdtree'
    " NERDTree Config {{{
        let g:NERDTreeWinPos = "right"
        let g:NERDTreeQuitOnOpen = "1"
        noremap <leader>2 :NERDTreeToggle<cr>
    " }}}
    " }}}

    " Editor Upgrades {{{
    Plug 'tpope/vim-surround'
    Plug 'sirver/ultisnips'
        let g:UltiSnipsExpandTrigger = '<tab>'
        let g:UltiSnipsJumpForwardTrigger = '<tab>'
        let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
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
    " }}}

    " Fun Stuff :) {{{
    Plug 'junegunn/limelight.vim'
    " }}}
    call plug#end()

    let ayucolor="dark"   " or light or mirage
    colorscheme ayu
endif
" }}}

" Language specific options {{{
augroup templates
    autocmd BufNewFile *.cpp 0r ~/Templates/ans.cpp
    autocmd BufNewFile *.html 0r ~/Templates/page.html
    autocmd BufNewFile *.tex 0r ~/Templates/doc.tex
augroup END

autocmd filetype c        call SetCOptions()
autocmd filetype cpp      call SetCppOptions()
autocmd filetype java     nnoremap <buffer> <F5> :w<CR>:!javac % && java %:r <CR>
autocmd filetype python   nnoremap <buffer> <F5> :w<CR>:!python3 %<CR>
" Robotics stuff
"autocmd filetype python   nnoremap <buffer> <C-d> :w<CR>:!/home/lyc/Dropbox/Main/Code/Robotics/download.sh % <CR>
"autocmd filetype python   nnoremap <buffer> <C-r> :w<CR>:!/home/lyc/Dropbox/Main/Code/Robotics/downloadAndRun.sh % <CR>
autocmd filetype julia    nnoremap <buffer> <F5> :w<CR>:!julia %<CR>
autocmd filetype tex      call SetTexOptions()
autocmd filetype pug,html,css,javascript,typescript,vue call SetWebOptions()
autocmd filetype sh       nnoremap <buffer> <F5> :w<CR>:!chmod +x % &&./%<CR>

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
    nn  <buffer> <F6> <ESC>:terminal time ./%:r < in.txt<CR>
    nn  <buffer> <F8> :w<CR>:!g++ -std=c++17 -Wall -fsanitize=address grader.cpp % -o %:r<CR>
    nn  <buffer> <F9> :w<CR>:!g++ -std=c++17 -Wall -fsanitize=address grader.cpp % -o %:r && time ./%:r < in.txt<CR>
    let g:airline#extensions#clock#format = '%H:%M:%S'
    let g:airline#extensions#clock#updatetime = 1000
    let g:airline#extensions#clock#mode = 'elapsed'
    nn  <leader>i :30vs in.txt<CR><ESC>GA
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
" }}}

silent! source .vimlocal    " to allow for project specific settings
echom "flush: Started Vim level " . g:level . "!"
