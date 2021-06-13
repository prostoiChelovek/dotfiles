let mapleader = "\<Space>"

set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

set relativenumber
set nu
set scrolloff=8

" highlight exceedings of 80 chars length limit
match ColorColumn "\%80v."

set nohlsearch
set smartcase
set incsearch

set hidden

set noerrorbells

set updatetime=40

set shortmess+=c

call plug#begin('~/.vim/plugged')
" color schemes
Plug 'morhetz/gruvbox'
Plug 'NLKNguyen/papercolor-theme'

" telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
call plug#end()

colorscheme PaperColor
set background=dark

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" https://stackoverflow.com/a/1618401/9577873
function! <SID>StripTrailingWhitespaces()
  if !&binary && &filetype != 'diff'
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
  endif
endfun

augroup THE_PREMEAGENT
    autocmd!
    autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()
augroup END
