silent! so .vimlocal    " to allow for project specific settings

" vim hardcodes background color erase even if the terminfo file does
" not contain bce (not to mention that libvte based terminals
" incorrectly contain bce in their terminfo files). This causes
" incorrect background rendering when using a color theme with a
" background color.
let &t_ut=''

" set Vim-specific sequences for RGB colors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" General colors (to work with kitty)
if has('gui_running') || has('nvim') 
    hi Normal 		guifg=#f6f3e8 guibg=#242424 
else
    " Set the terminal default background and foreground colors, thereby
    " improving performance by not needing to set these colors on empty cells.
    hi Normal guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE
    let &t_ti = &t_ti . "\033]10;#f6f3e8\007\033]11;#242424\007"
    let &t_te = &t_te . "\033]110\007\033]111\007"
endif

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
    set ts=4 sts=4 sw=4 et ai mouse=a
    set hls is
    set nu ru ls=2 stal=2 bg=dark
    au FileType cpp nn <F5> :wa<CR>:!g++ -std=c++17 -Wall -fsanitize=address % -o %:r && time ./%:r < in.txt<CR>
    au FileType cpp nn <F6> :!time ./%:r < in.txt<CR>
    colorscheme torte
    "colorscheme evening
    "hi Normal ctermbg=0
    "hi Visual ctermbg=1
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
    nnoremap <Leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>

    Plug 'tpope/vim-surround'

    "Plug 'scrooloose/nerdtree' 		" maybe will use this
    "" Toggle NERDTree on the right side by C-n
    "noremap  <c-n> :NERDTreeToggle<cr>
    "" Place NERDTree to right
    "let g:NERDTreeWinPos = "right"
    "let g:NERDTreeQuitOnOpen = "1"

    nnoremap <leader>2 :20Lexplore<CR>
    let g:netrw_banner=0
    let g:netrw_winsize=25
    let g:netrw_liststyle=3 " tree style

    Plug 'majutsushi/tagbar'
    nnoremap <leader>3 :TagbarToggle<CR>

    let g:ctrlp_map = '<c-p>'
    let g:ctrlp_cmd = 'CtrlP'
    let g:ctrlp_working_path_mode = 'ra'
    set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
    set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows

    let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
    let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
    Plug 'ctrlpvim/ctrlp.vim'

    nnoremap <leader>bn :bn<CR>
    nnoremap <leader>bN :bN<CR>
    nnoremap <leader>bd :bd<CR>

    nnoremap gb :bn<CR>
    nnoremap gB :bN<CR>

    " Extras
    Plug 'junegunn/limelight.vim'

    Plug 'sirver/ultisnips'
        let g:UltiSnipsExpandTrigger = '<tab>'
        let g:UltiSnipsJumpForwardTrigger = '<tab>'
        let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

    Plug 'KeitaNakamura/tex-conceal.vim'
        set conceallevel=1
        let g:tex_conceal='abdmg'
        hi Conceal ctermbg=none

    Plug 'lervag/vimtex'
        let g:tex_flavor='latex'
        let g:vimtex_view_method='zathura'
        let g:vimtex_quickfix_mode=0
        let g:vimtex_fold_enabled=1

    "set conceallevel=1
    "hi Conceal ctermbg=16
    "" because molokai screws up the background
    "set concealcursor=nvc
    "let g:tex_conceal='abdmgs'

    Plug 'sheerun/vim-polyglot'     " syntax highlighting for everything :D
    let g:polyglot_disabled = ['latex']
    "Plug 'dense-analysis/ale'       " linter
    "let b:ale_linters = {'javascript': ['eslint'], 'python': ['pylint']}
    "let b:ale_fixers = {'javascript': ['eslint'], 'python': ['pylint']}

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

    set mouse=a

    nnoremap 0 ^
    inoremap <C-f> {<CR>}<C-o>O

    " Language specific options
    autocmd filetype c        call SetCOptions()
    autocmd filetype cpp      call SetCppOptions()
    autocmd filetype java     nnoremap <buffer> <F5> :w<CR>:!javac % && java %:r <CR>
    autocmd filetype python   nnoremap <buffer> <F5> :w<CR>:!python3 %<CR>
    autocmd filetype julia    nnoremap <buffer> <F5> :w<CR>:!julia %<CR>
    " Robotics stuff
    "autocmd filetype python   nnoremap <buffer> <C-d> :w<CR>:!***REMOVED***/download.sh % <CR>
    "autocmd filetype python   nnoremap <buffer> <C-r> :w<CR>:!***REMOVED***/downloadAndRun.sh % <CR>

    autocmd filetype tex      call SetTexOptions()

    autocmd filetype pug      call SetPugOptions()
    autocmd filetype html     call SetHTMLOptions()
    autocmd filetype css      call SetCSSOptions()
    autocmd filetype javascript call SetJavascriptOptions()
    autocmd filetype vue      call SetJavascriptOptions()

    autocmd filetype sh       nnoremap <buffer> <F5> :w<CR>:!chmod +x % &&./%<CR>

    function SetCOptions()
        "let &g:makeprg="(gcc -o %:r %:r.c -std=c99 -Wall -fsanitize=address)"
        let &g:makeprg="(gcc -o %:r %:r.c -std=c99 -Wall -lm)"
        nn  <buffer> <F9> <ESC>:wa<CR>:make!<CR>:vertical botright copen 50<CR>
        ino <buffer> <F9> <ESC>:wa<CR>:make!<CR>:vertical botright copen 50<CR>
        nn  <buffer> <F5> <ESC>:!time ./%:r<CR>
        ino <buffer> <F5> <ESC>:!time ./%:r<CR>
        nn  <buffer> <F6> <ESC>:!time ./%:r < %:r.in<CR>
        ino <buffer> <F6> <ESC>:!time ./%:r < %:r.in<CR>
    endfunction

    function SetCppOptions()
        "nnoremap <F5> :w<CR>:!g++ -std=c++17 -D_GLIBCXX_DEBUG % -o %:r && ./%:r <CR>
        "nnoremap <F8> :w<CR>:!g++ -std=c++17 -g -D_GLIBCXX_DEBUG % && gdb a.out <CR>
        "fsanitize debugs null pointer exceptions
        "nnoremap <F5> :w<CR>:!g++ -std=c++17 -fsanitize=address % -o %:r && ./%:r<CR>
        "let &g:makeprg="(g++ -o %:r %:r.cpp -O2 -std=c++17 -Wall -fsanitize=address && time ./%:r < %:r.in)"
        "let &g:makeprg="(g++ -o %:r %:r.cpp -O2 -std=c++17 -Wall -fsanitize=address && time ./%:r < in.txt)"
        "let &g:makeprg="(g++ -o %:r %:r.cpp -O2 -std=c++17 -Wall && time ./%:r < in.txt)"
        "let &g:makeprg="make d"

        "nn  <buffer> <F5> <ESC>:wa<CR>:make!<CR>:copen<CR>
        "ino <buffer> <F5> <ESC>:wa<CR>:make!<CR>:copen<CR>
        "nn  <buffer> <F6> <ESC>:!time ./%:r < in.txt<CR>
        "ino <buffer> <F6> <ESC>:!time ./%:r < in.txt<CR>
        
        " fancy rewrite using kitty
        let g:cmd = 'kitty @ launch --cwd=current --type=window --keep-focus bash -c "'
        let g:endcmd="read -p 'Press enter to continue'\""
        let g:compile=g:cmd . 'g++ -o %s %s.cpp -O2 -std=c++17 -Wall -fsanitize=address && time ./%s < in.txt; ' . g:endcmd
        let g:run=g:cmd . 'time ./%s < in.txt; ' . g:endcmd
        nn  <buffer> <F5> <ESC>:wa<CR>:call system(printf(compile, expand('%:r'), expand('%:r'), expand('%:r')))<CR>
        ino <buffer> <F5> <ESC>:wa<CR>:call system(printf(compile, expand('%:r'), expand('%:r'), expand('%:r')))<CR>
        nn  <buffer> <F6> <ESC>:wa<CR>:call system(printf(run, expand('%:r')))<CR>
        ino <buffer> <F5> <ESC>:wa<CR>:call system(printf(run, expand('%:r')))<CR>

        nnoremap <buffer> <F8> :w<CR>:!g++ -std=c++17 -Wall -fsanitize=address grader.cpp % -o %:r<CR>
        nnoremap <buffer> <F9> :w<CR>:!g++ -std=c++17 -Wall -fsanitize=address grader.cpp % -o %:r && time ./%:r < in.txt<CR>
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

    function SetHTMLOptions()
        setlocal ts=2 sts=2 sw=2
        iabbrev </ </<C-X><C-O>
    endfunction

    function SetCSSOptions()
        setlocal ts=2 sts=2 sw=2
        iabbrev </ </<C-X><C-O>
    endfunction

    function SetJavascriptOptions()
        setlocal ts=2 sts=2 sw=2
        iabbrev GET router.get('', function(req, res, next) {
        iabbrev POST router.post('', function(req, res, next) {
    endfunction

    " Look
    let g:molokai_original = 1
    let g:rehash256=1
    set cursorline
    colorscheme molokai
    set colorcolumn=80		" highlight column 80
    highlight ColorColumn ctermbg=darkgray

    " NEW: Template Files
    if has("autocmd")
        augroup templates
            autocmd BufNewFile *.cpp 0r ~/Templates/ans.cpp
            autocmd BufNewFile *.html 0r ~/Templates/page.html
            autocmd BufNewFile *.tex 0r ~/Templates/doc.tex
        augroup END
    endif
endif

"" wayland
"xnoremap "+y y:call system("wl-copy", @")<cr>
"nnoremap "+p :let @"=substitute(system("wl-paste --no-newline"), '<C-v><C-m>', '', 'g')<cr>p
"nnoremap "*p :let @"=substitute(system("wl-paste --no-newline --primary"), '<C-v><C-m>', '', 'g')<cr>p
