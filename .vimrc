silent! so .vimlocal    " to allow for project specific settings

if exists('g:vimMinimal')
    " contest vimrc
    call plug#begin('~/.vim/plugged')
    Plug 'vim-airline/vim-airline'
    Plug 'enricobacis/vim-airline-clock'
    let g:airline#extensions#clock#format = '%H:%M:%S'
    let g:airline#extensions#clock#updatetime = 1000
    let g:airline#extensions#clock#mode = 'elapsed'
    call plug#end()

    syn on
    filet on
    set ts=4 sts=4 sw=4 et ai
    set hls is
    set nu ru ls=2 stal=2 bg=dark
    au FileType cpp nn <F5> :w<CR>:!g++ -std=c++11 -Wall -fsanitize=address % -o %:r && time ./%:r < in.txt<CR>
    colorscheme evening
else
    " normal vimrc
    "
    " VimPlug config
    " curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    call plug#begin('~/.vim/plugged')
    " Look
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    let g:airline_theme='ouo'
    let g:airline#extensions#tabline#enabled=1
    Plug 'enricobacis/vim-airline-clock'
    Plug 'tomasr/molokai'

    " Tools
    " Plug 'scrooloose/nerdtree' 		" maybe will use this
    " nnoremap <leader>2 :20Lexplore<CR>
    " let g:netrw_liststyle= 3 " tree style
    nnoremap <leader>2 :Lexplore<CR>
    nnoremap <leader>3 :TagbarToggle<CR>
    nnoremap <Leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>
    let g:netrw_banner=0
    let g:netrw_winsize=25
    let g:netrw_liststyle=3 " tree style
    Plug 'majutsushi/tagbar'

    " Extras
    Plug 'junegunn/limelight.vim'

    Plug 'lervag/vimtex'
    let g:tex_flavor='latex'
    let g:vimtex_view_method='zathura'
    let g:vimtex_quickfix_mode=0
    set conceallevel=1
    hi Conceal ctermbg=16
    " because molokai screws up the background
    let g:tex_conceal='abdmg'

    Plug 'sheerun/vim-polyglot'     " syntax highlighting for everything :D
    Plug 'dense-analysis/ale'       " linter
    let b:ale_linters = {'javascript': ['eslint']}
    let b:ale_fixers = {'javascript': ['eslint']}

    call plug#end()

    " Global options
    set encoding=utf-8
    set nocompatible
    filetype plugin indent on

    syntax on
    set incsearch
    set autoindent
    set ruler
    set number

    set expandtab
    set tabstop=4
    set softtabstop=4
    set shiftwidth=4

    nnoremap 0 ^
    inoremap <C-f> {<CR>}<C-o>O

    " Language specific options
    autocmd filetype cpp      call SetCppOptions()
    autocmd filetype java     nnoremap <buffer> <F5> :w<CR>:!javac % && java %:r <CR>
    autocmd filetype python   nnoremap <buffer> <F5> :w<CR>:!python3 %<CR>
    " Robotics stuff
    autocmd filetype python   nnoremap <buffer> <C-d> :w<CR>:!***REMOVED***/download.sh % <CR>
    autocmd filetype python   nnoremap <buffer> <C-r> :w<CR>:!***REMOVED***/downloadAndRun.sh % <CR>

    autocmd filetype tex      call SetTexOptions()

    autocmd filetype pug      call SetPugOptions()
    autocmd filetype html     iabbrev </ </<C-X><C-O>
    autocmd filetype javascript call SetJavascriptOptions()

    autocmd filetype sh       nnoremap <buffer> <F5> :w<CR>:!chmod +x % &&./%<CR>

    function SetCppOptions()
        "nnoremap <F5> :w<CR>:!g++ -std=c++11 -D_GLIBCXX_DEBUG % -o %:r && ./%:r <CR>
        "nnoremap <F8> :w<CR>:!g++ -std=c++11 -g -D_GLIBCXX_DEBUG % && gdb a.out <CR>
        "fsanitize debugs null pointer exceptions
        "nnoremap <F5> :w<CR>:!g++ -std=c++11 -fsanitize=address % -o %:r && ./%:r<CR>
        "let &g:makeprg="(g++ -o %:r %:r.cpp -O2 -std=c++11 -Wall -fsanitize=address && time ./%:r < %:r.in)"
        let &g:makeprg="(g++ -o %:r %:r.cpp -O2 -std=c++11 -Wall -fsanitize=address && time ./%:r < in.txt)"
        "let &g:makeprg="make d"
        nn  <buffer> <F5> <ESC>:wa<CR>:make!<CR>:copen<CR>
        ino <buffer> <F5> <ESC>:wa<CR>:make!<CR>:copen<CR>

        nnoremap <buffer> <F8> :w<CR>:!g++ -std=c++11 grader.cpp % -o %:r && ./%:r<CR>
        nnoremap <buffer> <F9> :w<CR>:!g++ -std=c++11 grader.cpp % -o %:r && ./%:r < in.txt<CR>
        let g:airline#extensions#clock#format = '%H:%M:%S'
        let g:airline#extensions#clock#updatetime = 1000
        let g:airline#extensions#clock#mode = 'elapsed'
        ":30vs in.txt<CR>
        "wincmd l
        "bel term
        "wincmd k
        ":res 20
    endfunction

    function SetTexOptions()
        nnoremap <buffer> <F5> :w<CR>:VimtexCompile <CR>
        if empty(v:servername) && exists('*remote_startserver')
            call remote_startserver('VIM')
        endif
    endfunction

    function SetPugOptions()
        setlocal ts=2 sts=2 sw=2
    endfunction

    function SetJavascriptOptions()
        iabbrev GET router.get('', function(req, res, next) {
        iabbrev POST router.post('', function(req, res, next) {
    endfunction

    " Look
    let g:rehash256=1
    set cursorline
    colorscheme molokai
    set colorcolumn=80		" highlight column 80
    highlight ColorColumn ctermbg=darkgray

    " NEW: Template Files
    if has("autocmd")
        augroup templates
            autocmd BufNewFile *.cpp 0r ~/Templates/ans.cpp
        augroup END
    endif
endif
