" for vundle..
filetype off
set nocompatible
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

" Bundles go here.
Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Bundle 'tpope/vim-fugitive', {'rtp': 'vim-fugitive/plugin'}
Bundle 'tpope/vim-sensible', {'rtp': 'vim-sensible/plugin'}
Bundle 'scrooloose/nerdtree', {'rtp': 'nerdtree'}
" Disabling python-mode in favor of jedi-vim.
"Bundle 'klen/python-mode', {'rtp': 'python-mode'}
Bundle 'davidhalter/jedi-vim'

" Normal config here.
filetype plugin indent on
set modeline
execute pathogen#infect()

" Some key maps..
" Nerd tree:
:map <C-t> :NERDTreeToggle<CR>

" For gvim, follow mouse focus.
:set mousefocus

" Color scheme
let g:solarized_termcolors=256
let g:solarized_termtrans=1
syntax enable
colorscheme solarized
set background=dark

" For line width
augroup line_width
	autocmd!
        " Highlight characters past column 79
        " Original: autocmd FileType python,sh highlight Excess ctermbg=DarkGrey guibg=Black
        autocmd BufWinEnter * highlight Excess ctermbg=DarkGrey guibg=Black
        autocmd BufWinEnter * match Excess /\%79v.*/
augroup end

" NERDTree helpers.
augroup nerd_tree
	" Allow close if NERDTree is the only thing left open
	autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q| endif
	" Open NERDTree automatically if no file is given.
	autocmd StdinReadPre * let s:std_in=1
	autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
augroup end

" Another type of 80 column marker:
" highlight OverLength ctermbg=red ctermfg=white guibg=#592929
" match OverLength /\%81v.\+/

" No word wrapping.
set nowrap

" For powerline
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 9
set laststatus=2

" For python-mode (disabling in favor of jedi-vim.
" let g:pymode_syntax_print_as_function = 1

" For jedi-vim
" This is set to 1 by default,
" but I am keeping it here in case I need to disable it.
let g:jedi#auto_initialization = 1
" jedi popup mode is "1", command-line is "2"
let g:jedi#show_call_signatures = "1"
" Enable/Disable completions (default is 1)
let g:jedi#completions_enabled = 1

