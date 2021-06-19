call plug#begin('~/.vim/plugged')
" color schemes
Plug 'morhetz/gruvbox'
Plug 'NLKNguyen/papercolor-theme'

" telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'junegunn/gv.vim'

Plug 'chrisbra/vim-diff-enhanced'

Plug 'voldikss/vim-floaterm'

Plug 'ilyachur/cmake4vim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'honza/vim-snippets'

Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh' }
call plug#end()

colorscheme PaperColor
set background=light

let g:airline_theme='papercolor'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#tab_min_count = 2

lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true
  },
}
EOF

let g:nvim_tree_ignore = [ '.git', 'node_modules', '.cache' ]
let g:nvim_tree_auto_close = 1
let g:nvim_tree_follow = 1
let g:nvim_tree_git_hl = 1
let g:nvim_tree_group_empty = 1
nnoremap <C-t> :NvimTreeToggle<CR>
nnoremap <leader>tr :NvimTreeRefresh<CR>
nnoremap <leader>tn :NvimTreeFindFile<CR>

" started In Diff-Mode set diffexpr (plugin not loaded yet)
if &diff
    let &diffexpr='EnhancedDiff#Diff("git diff", "--diff-algorithm=patience")'
endif

let g:signify_sign_show_count = 0
let g:signify_sign_show_text = 1
let g:signify_sign_add               = '+'
let g:signify_sign_delete            = '_'
let g:signify_sign_delete_first_line = '‾'
let g:signify_sign_change            = '~'

let g:cmake_usr_args = '-DCMAKE_EXPORT_COMPILE_COMMANDS=1'
let g:make_arguments = '-j 8'
let g:cmake_kits = {
            \  "stm": {
            \    "cmake_usr_args": {
            \      "CUBE_PATH": "/home/chelovek/projects/STM32CubeH7",
            \      "USE_HAL_FRAMEWORK": "1",
            \      "BUILD_FOR_BOARD": "1"
            \    }
            \  } }

set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ\\;;ABCDEFGHIJKLMNOPQRSTUVWXYZ$,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz

nnoremap <Leader>l :CMakeSelectTarget upload<CR>:CMakeBuild<CR>
nnoremap <Leader>< :CMakeSelectTarget debug<CR>:CMakeBuild<CR>

set spellfile=~/.vim/spell/en.utf-8.add
command Spellcheck :setlocal spell spelllang=ru_yo,en_us
command NoSpell :setlocal nospell

autocmd FileType help setlocal nospell

autocmd BufReadPost *.docx :%!pandoc -f docx -t markdown
autocmd BufWritePost *.docx :!pandoc -f markdown -t docx % > tmp.docx

" redirect the output of a Vim or external command into a scratch buffer
" https://vi.stackexchange.com/a/16607
function! RedirIfError(cmd)
    if a:cmd =~ '^!'
        execute "let output = system('" . substitute(a:cmd, '^!', '', '') . "')"
    else
        redir => output
        execute a:cmd
        redir END
    endif
    if v:shell_error != 0
        vnew
        setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
        call setline(1, split(output, "\n"))
        put! = a:cmd
        silent put = '----'

        setlocal wrap
        normal G
    else
        echo "OK"
    endif
endfunction
" command! -nargs=1 RedirIfError silent call RedirIfError(<f-args>)

autocmd FileType tex nnoremap <buffer> <C-s> <Esc>:w <Cr>:call RedirIfError("!pdflatex -output-directory=" . expand("%:p:h") . "/out " . expand("%:p")) <Cr>

autocmd FileType text nnoremap <buffer> j gj
autocmd FileType text nnoremap <buffer> k gk

" https://stackoverflow.com/a/1618401/9577873
function! <SID>StripTrailingWhitespaces()
  if !&binary && &filetype != 'diff'
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
  endif
endfun

nnoremap <C-c> :bp\|bd #<CR>

function! s:SwitchPSCStyle()
    if &background == "light"
        set background=dark
        let g:airline_theme='angr'
    else
        set background=light
        let g:airline_theme='papercolor'
    endif
endfunction
map <silent> <F6> :call <SID>SwitchPSCStyle()<CR>

" https://zenbro.github.io/2015/06/26/review-last-commit-with-vim-and-fugitive.html
function! ReviewLastCommit()
  if exists('b:git_dir')
    Gtabedit HEAD^{}
    nnoremap <buffer> <silent> q :<C-U>bdelete<CR>
  else
    echo 'No git a git repository:' expand('%:p')
  endif
endfunction
map <silent> <F10> :call ReviewLastCommit()<CR>

augroup THE_PREMEAGENT
    autocmd!
    autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()
augroup END

