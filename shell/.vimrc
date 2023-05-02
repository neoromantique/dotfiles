" ################################
" # 2014. WTFPL.                 #
" #.vimrc by David Aizenberg     #
" # david.aizenberg@paranoici.org# 
" ################################

" put this line first in ~/.vimrc
set nocompatible | filetype indent plugin on | syn on

let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'

let g:tpipeline_statusline = '%!tpipeline#stl#line()'

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'neoclide/coc.nvim'
Plugin 'preservim/nerdtree'
Plugin 'nvim-lua/plenary.nvim'
Plugin 'jose-elias-alvarez/null-ls.nvim'
Plugin 'nathanaelkane/vim-indent-guides'
"Plugin 'nvim-lualine/lualine.nvim'
Plugin 'kyazdani42/nvim-web-devicons'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'vim-airline/vim-airline'
" Plugin 'ryanoasis/vim-devicons'
"Plugin 'Raimondi/delimitMate'
Plugin 'ekalinin/Dockerfile.vim'
" Plugin 'godlygeek/tabular'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'
" Plugin 'vimwiki/vimwiki'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'LnL7/vim-nix'
call vundle#end()

let g:copilot_assume_mapped = v:true

imap <C-c> <CR><Esc>O

" This does what it says on the tin. It will check your file on open too, not
" just on save.
" " You might not want this, so just leave it out if you don't.
let g:syntastic_check_on_open=1

let g:ycm_add_preview_to_completeopt=0
let g:ycm_confirm_extra_conf=0
set completeopt-=preview

" Scrooloose/syntastic settings 
let g:syntastic_error_symbol = '✘'
let g:syntastic_warning_symbol = "▲"

" Turn syntax highlight on.
syntax on

"for future use.
let mapleader = ","

"autocmd VimEnter * NERDTree

"bind Ctrl + E as a Toggle for NERDTree
map <C-e> :NERDTreeToggle<CR>

"Configure vim to backup files, might save sometime, definitely will not hurt.
set backup
set backupdir=~/.vim/backup
set directory=~/.vim/tmp
set autochdir


let g:NERDTreeGitStatusIndicatorMapCustom = {
                \ 'Modified'  :'✹',
                \ 'Staged'    :'✚',
                \ 'Untracked' :'✭',
                \ 'Renamed'   :'➜',
                \ 'Unmerged'  :'═',
                \ 'Deleted'   :'✖',
                \ 'Dirty'     :'✗',
                \ 'Ignored'   :'☒',
                \ 'Clean'     :'✔︎',
                \ 'Unknown'   :'?',
                \ }

" Make Vim highlight current line
set cul                          

" Enable line Numbers on left, and set their colour.
set number
highlight LineNr ctermfg=grey

" map F5 to inserting the time/date
nnoremap <F5> "=strftime("%I:%M %p %a %d/%m/%Y")<CR>p
inoremap <F5> <C-R>=strftime("%I:%M %p %a %d/%m/%Y")<CR>

"set list                        " show invisible characters
set mouse=a                     " try to use a mouse in the console (wimp!)
set autoindent                  " set the cursor at same indent as line above
set smartindent                 " try to be smart about indenting (C-style)
set noexpandtab

" ###############################
" # Language Dependent settings #
" ###############################

" Shell
autocmd FileType sh setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4

" Python
autocmd FileType python setlocal tabstop=1 shiftwidth=1 expandtab number

autocmd FileType python map <buffer> <F9> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>

" Ruby
autocmd FileType ruby setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2

" PHP
autocmd FileType php setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4

" X?HTML & XML
autocmd FileType html,xhtml,xml setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2

" JS
autocmd FileType javascript setlocal equalprg=js-beautify\ --stdin

autocmd FileType javascript map <buffer> <F9> :w<CR>:exec '!node' shellescape(@%, 1)<CR>

" CSS
autocmd FileType css setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4

" Makefiles
autocmd FileType make setlocal noexpandtab

" JavaScript
" autocmd BufRead,BufNewFile *.json setfiletype javascript
autocmd FileType javascript setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4

let python_highlight_all = 1

let javascript_enable_domhtmlcss=1

filetype plugin indent on

set autoindent


" Set 256 colour mode and Theme.
set t_Co=256
colorscheme mustang
" colorscheme desert

