syntax on                " turn syntax highlighting on
set backspace=indent,eol,start    " make backspace work as expected (can remove indentation, eol, and start of line like everywhere else)
set enc=utf-8            " set UTF-8 encoding
set fenc=utf-8           " set UTF-8 encoding
set termencoding=utf-8   " set UTF-8 encoding
set guifont=Andale\ Mono\ 12    "set font and size
set nocompatible        " disable vi compatibility (emulation of old bugs, required for Vundle)
set number              " turn line numbers on
set showmatch           " highlight matching braces
set comments=sl:/*,mb:\ *,elx:\ */     " intelligent comments
set mouse=a             " set mouse mode on
set scrolloff=5         " Show a few lines of context around the cursor.  Note that this makes the text scroll if you mouse-click near the start or end of the window.
set novisualbell        " turn off screen flashing (it's really really annoying)
set hlsearch            " highlight searches
set ruler               " show the cursor position all the time
set showcmd             " display incomplete commands
set wildmenu            " display completion matches in a status line
set laststatus=2        " always show status line
set smartindent         " use smartindent
set timeout             " enable timeout for escape sequences
set timeoutlen=1000     " lower the timeout length to 1000ms
set textwidth=0         " dont autowrap code
set wrapmargin=0        " "
"set colorcolumn=121    " put a vertical column at 121 characters (encourage 120 char max lines)
"set autochdir          " automatically change directory to the current file
set clipboard=unnamedplus   " use system clipboard for vim (only works if +clipboard in vim --version)

" Tab Width
set tabstop=4
set shiftwidth=4
set expandtab

" Makefiles need tabs
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0 tabstop=8

" Space to remove highlight
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" compare with original file in veritical split
command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis

" With the following mappings, you can press Alt-Left or Alt-Right scroll through tabs
nnoremap <A-Left> :tabprevious<CR>
nnoremap <A-Right> :tabnext<CR>
" press Ctrl-Left or Ctrl-Right to go scroll through buffers
nnoremap <C-Left> :bprevious<CR>
nnoremap <C-Right> :bnext<CR>

" remove the annoying behavior where indentation removed when you enter a #
inoremap # X#

" set the runtime path to include Vundle and initialize
filetype off                  " required
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'tpope/vim-fugitive'
Plugin 'flazz/vim-colorschemes'
Plugin 'sonph/onehalf', {'rtp': 'vim/'}  " all for an extra colorscheme :P
Plugin 'godlygeek/tabular'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'vim-airline/vim-airline'  " show buffer bar
Plugin 'vim-airline/vim-airline-themes'
Plugin 'kien/rainbow_parentheses.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

"" colorschemes
set t_Co=256

" Dark themes
set background=dark
colorscheme wombat256ln         " original version by Lars Neilson from which wombat256i broke, I fixed ColorColumn
"colorscheme wombat256i
"colorscheme gruvbox
"colorscheme zenburn
"colorscheme onehalfdark        " extrememly well supported (works virtually everywhere)

" Light themes
"set background=light
"colorscheme summerfruit256      " very bright
"colorscheme primary             " google's colors
"colorscheme onehalflight        " extremely well supported (works virtually everywhere)

" YouCompleteMe
let g:ycm_global_ycm_extra_conf = '${HOME}/.vim/bundle/YouCompleteMe/.ycm_extra_conf.py'
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_confirm_extra_conf = 0
let g:ycm_log_level = "DEBUG"
let g:ycm_server_python_interpreter = '/opt/local/stow/Python-2.7.8/bin/python2'
let g:ycm_goto_buffer_command = 'same-buffer'
" map <\><d> to GoTo and <\><f> to FixIt. Use <C-o> to go back
noremap <leader>d :YcmCompleter GoToDefinitionElseDeclaration<CR>
noremap <leader>g :YcmCompleter GoToDeclaration<CR>
noremap <leader>f :YcmCompleter FixIt<CR>
" finish completion with <C-y> (the default) or Enter
let g:ycm_key_list_stop_completion = ['<C-y>', '<CR>']

" make YCM compatible with UltiSnips
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']

" Utilisnips (and vim-snippets)
" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" Syntastic
let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_auto_refresh_includes = 1
let g:syntastic_enable_signs = 1
" configuration for flake8 is at ~/.config/flake8, to create local config make either .flake8 or tox.ini in the root of the project
let g:syntastic_python_checkers=['flake8']   " To install use pip install flake8, should be installed for each virtualenv
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" NERDCommenter
let g:NERDSpaceDelims = 0            " no spaces after comment
let g:NERDDefaultAlign = 'left'      " flush left when commenting rather than staying aligned with code
let g:NERDCommentEmptyLines = 1      " allow commenting empty lines

" NERDTree, use <C-d> to toggle directory structure
noremap <C-d> :NERDTreeToggle<CR>

" tabularize
" select text and press <\><a><=,:> to align with respect to the given token
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a: :Tabularize /:\zs<CR>
vmap <Leader>a: :Tabularize /:\zs<CR>

" vim-airline
let g:airline_section_b = airline#section#create_left(['file'])
let g:airline_section_c = airline#section#create_left(['path'])
let g:airline_section_y = 'BN: %{bufnr("%")}'
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'wombat'

" rainbow
let g:rbpt_loadcmd_toggle = 1
let g:rbpt_max = 18
let g:rbpt_colorpairs = [
    \ ['gray',   '#c654ff'],
    \ ['green',  '#ff8921'],
    \ ['brown',  '#dbffa6'],
    \ ['white',  '#4778ff'],
    \ ['blue',   '#ff91f0'],
    \ ['magenta','#ffcfa6'],
    \ ['cyan',   '#54ff8d'],
    \ ['yellow', '#9eb8ff'],
    \ ['red',    '#ff3083'],
    \ ['gray',   '#c654ff'],
    \ ['green',  '#ff8921'],
    \ ['brown',  '#dbffa6'],
    \ ['white',  '#4778ff'],
    \ ['blue',   '#ff91f0'],
    \ ['magenta','#ffcfa6'],
    \ ['cyan',   '#54ff8d'],
    \ ['yellow', '#9eb8ff'],
    \ ['red',    '#ff3083']
    \ ]

au VimEnter * RainbowParenthesesActivate
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
au Syntax * RainbowParenthesesLoadChevrons

" ctrlp
" work from nearest parent with .git, .svm, .idea, etc.. otherwise from cwd
let g:ctrlp_working_path_mode = 'rw'
" adds additional search markers
let g:ctrlp_root_markers = ['.idea', '.ycm_extra_conf.py']
" if a file is already open, open it again in a new pane instead of switching to the existing pane
let g:ctrlp_switch_buffer = 'et'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" Resume from previous line
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

