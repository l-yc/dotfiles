silent! so .vimlocal    " to allow for project specific settings

" vim hardcodes background color erase even if the terminfo file does
" not contain bce (not to mention that libvte based terminals
" incorrectly contain bce in their terminfo files). This causes
" incorrect background rendering when using a color theme with a
" background color.
let &t_ut=''

"" set Vim-specific sequences for RGB colors
"let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
"let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" C-r to fix syntax highlighting when it breaks
" See: https://github.com/vim/vim/issues/2790
nn <leader>l :syntax sync fromstart<CR>
set redrawtime=10000

" General colors (to work with kitty)
if has('gui_running') || has('nvim') 
    hi Normal 		guifg=#f6f3e8 guibg=#242424 
    set termguicolors
else
    " Set the terminal default background and foreground colors, thereby
    " improving performance by not needing to set these colors on empty cells.
    hi Normal guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE
    "let &t_ti = &t_ti . "\033]10;#f6f3e8\007\033]11;#242424\007"
    "let &t_te = &t_te . "\033]110\007\033]111\007"
endif

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
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
else
    " normal vimrc
    nn <leader><space> :e ~/.vimrc<CR>
    
    " VimPlug config
    " curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    call plug#begin('~/.vim/plugged')

    " Look
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    let g:airline_theme='raven'
    let g:airline#extensions#tabline#enabled=1
    Plug 'enricobacis/vim-airline-clock'

    Plug 'Yggdroot/indentLine'
    " IndentLine {{
    "let g:indentLine_char = '|'
    "let g:indentLine_first_char = '|'
    let g:indentLine_char_list = ['|', '¦', '┆', '┊']
    "let g:indentLine_showFirstIndentLevel = 1
    "let g:indentLine_setColors = 0
    " }}

    Plug 'ryanoasis/vim-devicons'
    "Plug 'tomasr/molokai'
    Plug 'ayu-theme/ayu-vim' " or other package manager

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

    Plug 'liuchengxu/vista.vim'
    nnoremap <leader>3 :Vista!!<CR>
    let g:vista_sidebar_width = 50

    " Executive used when opening vista sidebar without specifying it.
    " See all the avaliable executives via `:echo g:vista#executives`.
    let g:vista_default_executive = 'coc'

    " How each level is indented and what to prepend.
    " This could make the display more compact or more spacious.
    " e.g., more compact: ["▸ ", ""]
    " Note: this option only works for the kind renderer, not the tree renderer.
    let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]

    " Ensure you have installed some decent font to show these pretty symbols, then you can enable icon for the kind.
    let g:vista#renderer#enable_icon = 1

    " The default icons can't be suitable for all the filetypes, you can extend it as you wish.
    let g:vista#renderer#icons = {
    \   "function": "\uf794",
    \   "variable": "\uf71b",
    \  }

    "Plug 'majutsushi/tagbar'
    "nnoremap <leader>3 :TagbarToggle<CR>

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

    set signcolumn=number
    Plug 'dense-analysis/ale'       " linter
    let g:ale_linters = {'javascript': ['eslint'], 'python': ['pylint']}
    let g:ale_fixers = {'javascript': ['eslint'], 'python': ['pylint']}
    let g:ale_sign_column_always = 1
    let g:ale_sign_error = '❌'
    "let g:ale_sign_warning = '⚡'
    let g:ale_sign_warning = '💡'
    highlight clear ALEErrorSign
    highlight clear ALEWarningSign
    let g:airline#extensions#ale#enabled = 1

    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " Use `[g` and `]g` to navigate diagnostics
    " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)
    "
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

    set cmdheight=2
    set updatetime=300
    " Make <CR> auto-select the first completion item and notify coc.nvim to
    " format on enter, <cr> could be remapped by other vim plugin
    inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
    
    "Plug 'Shougo/deoplete.nvim'
    "Plug 'roxma/nvim-yarp'
    "Plug 'roxma/vim-hug-neovim-rpc'
    "let g:deoplete#enable_at_startup = 1

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
    "set tabstop=4
    "set softtabstop=4
    "set shiftwidth=4

    set mouse=a

    nnoremap 0 ^
    inoremap <C-f> {<CR>}<C-o>O

    " Look
    "colorscheme molokai
    "let g:molokai_original = 1
    "let g:rehash256=1

    "let ayucolor="light"  " for light version of theme
    "let ayucolor="mirage" " for mirage version of theme
    let ayucolor="dark"   " for dark version of theme
    colorscheme ayu
    set cursorline
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


    " Language specific options
    autocmd filetype c        call SetCOptions()
    autocmd filetype cpp      call SetCppOptions()
    autocmd filetype go       call SetGoOptions()
    autocmd filetype java     nnoremap <buffer> <F5> :w<CR>:!javac % && java %:r <CR>
    autocmd filetype python   nnoremap <buffer> <F5> :w<CR>:!python3 %<CR>
    autocmd filetype julia    nnoremap <buffer> <F5> :w<CR>:!julia %<CR>
    " Robotics stuff
    "autocmd filetype python   nnoremap <buffer> <C-d> :w<CR>:!/home/lyc/Dropbox/Main/Code/Robotics/download.sh % <CR>
    "autocmd filetype python   nnoremap <buffer> <C-r> :w<CR>:!/home/lyc/Dropbox/Main/Code/Robotics/downloadAndRun.sh % <CR>

    autocmd filetype tex      call SetTexOptions()

    autocmd filetype pug,html,css,javascript,typescript,vue call SetWebOptions()

    autocmd filetype sh       nnoremap <buffer> <F5> :w<CR>:!chmod +x % &&./%<CR>

    function SetCOptions()
        "let &g:makeprg="(gcc -o %:r %:r.c -std=c99 -Wall -fsanitize=address)"
        let &g:makeprg="(gcc -o %:r %:r.c -std=c99 -Wall -lm)"
        nn  <buffer> <F9> <ESC>:wa<CR>:make!<CR>:vertical botright copen 50<CR>
        nn  <buffer> <F5> <ESC>:!time ./%:r<CR>
        nn  <buffer> <F6> <ESC>:!time ./%:r < %:r.in<CR>
    endfunction

    function SetCppOptions()
        " fsanitize debugs null pointer exceptions
        "nnoremap <F5> :w<CR>:!g++ -std=c++17 -fsanitize=address % -o %:r && ./%:r<CR>
        "nnoremap <F8> :w<CR>:!g++ -std=c++17 -fsanitize=address -g -D_GLIBCXX_DEBUG % && gdb a.out <CR>
        "let &g:makeprg="(g++ -o %:r %:r.cpp -O2 -std=c++17 -Wall -fsanitize=address && time ./%:r < %:r.in)"

        "nn  <buffer> <F5> <ESC>:wa<CR>:make!<CR>:copen<CR>
        "nn  <buffer> <F6> <ESC>:!time ./%:r < in.txt<CR>
        
        " fancy rewrite using kitty
        let g:cmd = 'kitty @ launch --cwd=current --type=window --keep-focus bash -c "'
        let g:endcmd="read -p 'Press enter to continue'\""
        let g:compile=g:cmd . 'g++ -o %s %s.cpp -O2 -std=c++17 -Wall -fsanitize=address && time ./%s < in.txt; ' . g:endcmd
        let g:run=g:cmd . 'time ./%s < in.txt; ' . g:endcmd
        nn  <buffer> <F5> <ESC>:wa<CR>:call system(printf(compile, expand('%:r'), expand('%:r'), expand('%:r')))<CR>
        nn  <buffer> <F6> <ESC>:wa<CR>:call system(printf(run, expand('%:r')))<CR>
        nn  <buffer> <F8> :w<CR>:!g++ -std=c++17 -Wall -fsanitize=address grader.cpp % -o %:r<CR>
        nn  <buffer> <F9> :w<CR>:!g++ -std=c++17 -Wall -fsanitize=address grader.cpp % -o %:r && time ./%:r < in.txt<CR>
        let g:airline#extensions#clock#format = '%H:%M:%S'
        let g:airline#extensions#clock#updatetime = 1000
        let g:airline#extensions#clock#mode = 'elapsed'

        nn  <leader>i   :30vs in.txt<CR><ESC>GA
        ":30vs in.txt<CR>
        "wincmd l
        "bel term
        "wincmd k
        ":res 20
    endfunction

    function SetGoOptions()
        set noexpandtab
    endfunction

    function SetTexOptions()
        nnoremap <buffer> <F5> :w<CR>:VimtexCompile <CR>
        if empty(v:servername) && exists('*remote_startserver')
            call remote_startserver('VIM')
        endif
    endfunction

    function SetWebOptions()
        "setlocal ts=2 sts=2 sw=2
        iabbrev </ </<C-X><C-O>
        iabbrev GET router.get('', function(req, res, next) {
        iabbrev POST router.post('', function(req, res, next) {
    endfunction
endif

"" wayland
"xnoremap "+y y:call system("wl-copy", @")<cr>
"nnoremap "+p :let @"=substitute(system("wl-paste --no-newline"), '<C-v><C-m>', '', 'g')<cr>p
"nnoremap "*p :let @"=substitute(system("wl-paste --no-newline --primary"), '<C-v><C-m>', '', 'g')<cr>p
