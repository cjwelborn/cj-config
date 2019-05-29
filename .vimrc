" Vundle requires `filetype off` (the FileType even will not be fired)
" ...syntax highlighting and other things will be set elsewhere.
" filetype off

" Disable vi-compatibility (use iMproved mode)
set nocompatible


" Normal config here. --------------------------------------------------------
filetype plugin indent on
" Allow files to set their own vim settings.
set modeline
set clipboard=unnamedplus
" No word wrapping.
set nowrap
" For gvim, follow mouse focus.
set mousefocus
" Where to place split windows.
set splitbelow
set splitright
" Show line numbers always.
set number
" Use BASH for the shell, always.
set shell=/bin/bash

" Use a tabwidth of 4.
" shiftwidth, smarttab, expandtab, etc. are set with vim-sleuth.
" vim-sleuth will use this as a preference for hard-tabs.
set tabstop=4
" This is what I would set if vim-sleuth wasn't already taking care of it:
"set tabstop=8
"set shiftwidth=4
"set softtabstop=4
"set expandtab
"set smarttab

" Configurable variables for /usr/share/vim/vim74/indent/python.vim
" Using expressions, so that shiftwidth can be changed later (with vim-sleuth probably).
" Indent after an open paren (default: '&sw * 2'):
let g:pyindent_open_paren = '&sw'
" Indent after a nested paren (default: '&sw'):
let g:pyindent_nested_paren = '&sw'
" Indent for a continuation line (default: '&sw * 2'):
let g:pyindent_continue = '&sw'

" Load packages with pathogen ------------------------------------------------
" Include the powerline binding directory.
execute pathogen#infect('bundle/{}', 'bundle/powerline/powerline/bindings/{}')


" Some key maps.. ------------------------------------------------------------
" Nerd tree:
:map <C-t> :NERDTreeToggle<CR>
" Switch panes with the tab key.
:map <Tab> <C-W>W

" In case you were wondering how to split windows:
" <C-W>S - Split horizontally
" <C-W>V - Split vertically

" Use Ctrl - JKLH instead of Ctrl + W - JKLH to move between panes.
" This provides the second of three different methods to move between panes:
" 1)    The old method: <C-W><C-H/J/K/L>
" 2)          Shortcut: <C-H/J/K/L>         (this mapping)
" 3)       Even faster: <Alt-[arrow key]>   (the next mapping)
:nnoremap <C-J> <C-W><C-J>
:nnoremap <C-K> <C-W><C-K>
:nnoremap <C-L> <C-W><C-L>
:nnoremap <C-H> <C-W><C-H>

" Use Alt + Arrow to move between panes
" This provides the third of three different methods to move between panes:
" 3)  Alt-[arrow-key]
:nmap <silent> <A-Up> :wincmd k<CR>
:nmap <silent> <A-Down> :wincmd j<CR>
:nmap <silent> <A-Left> :wincmd h<CR>
:nmap <silent> <A-Right> :wincmd l<CR>

" Use Ctrl + H/J/N to cycle tabs (and create a new one), besides PgUp/PgDown.
:map  <C-l> :tabn<CR>
:map  <C-h> :tabp<CR>
:map  <C-n> :tabnew<CR>

" Color scheme (vim-colors-solarized) ----------------------------------------
let g:solarized_termcolors=256
let g:solarized_termtrans=1
syntax enable
colorscheme solarized
set background=dark

" Explicit syntax file types -------------------------------------------------
au BufNewFile,BufRead *_sudoers_* set filetype=sudoers
au BufNewFile,BufRead .pystartup set filetype=python

" For line width -------------------------------------------------------------
augroup line_width
	autocmd!
        " Highlight characters past column 79
        " Original: autocmd FileType python,sh highlight Excess ctermbg=DarkGrey guibg=Black
        autocmd BufWinEnter * highlight Excess ctermbg=DarkGrey guibg=Black
        autocmd BufWinEnter * match Excess /\%79v.*/
augroup end
" Another type of 80 column marker:
" highlight OverLength ctermbg=red ctermfg=white guibg=#592929
" match OverLength /\%81v.\+/

" NERDTree Config ------------------------------------------------------------
" NERDTree, show hidden files by default.
let g:NERDTreeShowHidden=1

" NERDTree helpers.
augroup nerd_tree
	" Allow close if NERDTree is the only thing left open
	autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q| endif
	" Open NERDTree automatically if no file is given.
	autocmd StdinReadPre * let s:std_in=1
	autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
augroup end

" For powerline --------------------------------------------------------------
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 9
set laststatus=2

" For python-mode (disabling in favor of jedi-vim). --------------------------
" let g:pymode_syntax_print_as_function = 1

" For jedi-vim ---------------------------------------------------------------
" This is set to 1 by default,
" but I am keeping it here in case I need to disable it.
let g:jedi#auto_initialization = 1
" jedi popup mode is "1", command-line is "2"
let g:jedi#show_call_signatures = "1"
" Enable/Disable completions (default is 1)
let g:jedi#completions_enabled = 1
" Disable preview window
:set completeopt-=preview
" Auto-close preview window.
"augroup PreviewOnBottom
"    autocmd InsertEnter * set splitbelow
"    autocmd InsertLeave * set splitbelow!
"augroup END

" For vim-racer --------------------------------------------------------------
if filereadable("/home/cj/.cargo/bin/racer")
    set hidden
    let g:racer_cmd = "/home/cj/.cargo/bin/racer"
    autocmd FileType rust nmap gd <Plug>(rust-def)
    autocmd FileType rust nmap gs <Plug>(rust-def-split)
    autocmd FileType rust nmap gx <Plug>(rust-def-vertical)
    autocmd FileType rust nmap <leader>gd <Plug>(rust-doc)
endif

