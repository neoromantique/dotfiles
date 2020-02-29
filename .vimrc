" ################################
" # 2014. WTFPL.                 #
" #.vimrc by David Aizenberg     #
" # david.aizenberg@paranoici.org# 
" ################################

" #Requirements: Pathogen, Airline, NERDTree, Mustang colour theme

" put this line first in ~/.vimrc
set nocompatible | filetype indent plugin on | syn on

set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" Turn syntax highlight on.
syntax on

"for future use.
let mapleader = ","

"Enable Pathongen
execute pathogen#infect() 

"Enable Airline
set laststatus=2
let g:airline_powerline_fonts = 1 

"autocmd VimEnter * NERDTree

"bind Ctrl + E as a Toggle for NERDTree
map <C-e> :NERDTreeToggle<CR>

"Configure vim to backup files, might save sometime, definitely will not hurt.
set backup
set backupdir=~/.vim/backup
set directory=~/.vim/tmp
set autochdir

" Make Vim highlight current line
set cul                          

" Enable line Numbers on left, and set their colour.
set number
highlight LineNr ctermfg=grey

" map F5 to inserting the time/date
nnoremap <F5> "=strftime("%I:%M %p %a %d/%m/%Y")<CR>p
inoremap <F5> <C-R>=strftime("%I:%M %p %a %d/%m/%Y")<CR>

"set list                        " show invisible characters
"set mouse=a                     " try to use a mouse in the console (wimp!)
set autoindent                  " set the cursor at same indent as line above
set smartindent                 " try to be smart about indenting (C-style)
set noexpandtab

" use blowfish for file encryption
set cm=blowfish


" ###############################
" # Language Dependent settings #
" ###############################

" Shell
autocmd FileType sh setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4

" Ruby
autocmd FileType ruby setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2

" PHP
autocmd FileType php setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4

" X?HTML & XML
autocmd FileType html,xhtml,xml setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2

" CSS
autocmd FileType css setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4

" Makefiles
autocmd FileType make setlocal noexpandtab

" JavaScript
" autocmd BufRead,BufNewFile *.json setfiletype javascript
autocmd FileType javascript setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
let javascript_enable_domhtmlcss=1
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 1


" Set 256 colour mode and Theme.
set t_Co=256
colorscheme mustang


