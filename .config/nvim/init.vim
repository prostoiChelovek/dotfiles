call plug#begin('~/.vim/plugged')
" color schemes
Plug 'morhetz/gruvbox'
Plug 'NLKNguyen/papercolor-theme'

" telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

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

Plug 'tpope/vim-abolish'

Plug 'khaveesh/vim-fish-syntax'

Plug 'vim-test/vim-test'

Plug 'simeji/winresizer'
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
            \      "PLATFORM_FRAMEWORK": "hal",
            \      "BUILD_FOR_BOARD": "1"
            \    }
            \  } }

let test#strategy = "neovim"
let test#python#runner = 'python3.7 -m pytest'

set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ\\;;ABCDEFGHIJKLMNOPQRSTUVWXYZ$,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz

nnoremap <Leader>l :CMakeSelectTarget upload<CR>:CMakeBuild<CR>
nnoremap <Leader>< :CMakeSelectTarget debug<CR>:CMakeBuild<CR>

function! SwitchHeaderSource()
    let l:pathNoExt = expand("%:p:r")
    let l:ext = expand("%:e")
    if l:ext == "h"
        execute 'e' . l:pathNoExt . ".cpp"
    elseif l:ext == "cpp"
        execute 'e' . l:pathNoExt . ".h"
    endif
endfunction
nnoremap <Leader>f :silent call SwitchHeaderSource()<CR>

function! OpenExt()
    let l:pathNoExt = expand("%:p:r")
    let l:ext = input("Ext: ")
    execute 'e' . l:pathNoExt . "." . l:ext
endfunction
nnoremap <Leader><Leader>f :silent call OpenExt()<CR>

set spellfile=~/.vim/spell/en.utf-8.add
command Spellcheck :setlocal spell spelllang=ru_yo,en_us
command NoSpell :setlocal nospell

autocmd FileType help setlocal nospell

autocmd BufReadPost *.docx :%!pandoc -f docx -t markdown
autocmd BufWritePost *.docx :!pandoc -f markdown -t docx % > tmp.docx

autocmd BufEnter *.tpp :setlocal filetype=cpp

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

function! s:Pio()
    nmap <leader>c :silent exe "!tmux send-keys -t 1.1 C-c && tmux resize-pane -Z -t 1.0 Enter"<CR>
    nmap <leader>l :silent exe "!tmux resize-pane -Z -t 1.0 && tmux send -t 1.1 'pio run --target upload -e uno && pio device monitor --baud 9600' Enter"<CR>
endfunction
command! Pio silent call <SID>Pio()

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

" https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7
function! Redir(cmd, rng, start, end)
	for win in range(1, winnr('$'))
		if getwinvar(win, 'scratch')
			execute win . 'windo close'
		endif
	endfor
	if a:cmd =~ '^!'
		let cmd = a:cmd =~' %'
			\ ? matchstr(substitute(a:cmd, ' %', ' ' . expand('%:p'), ''), '^!\zs.*')
			\ : matchstr(a:cmd, '^!\zs.*')
		if a:rng == 0
			let output = systemlist(cmd)
		else
			let joined_lines = join(getline(a:start, a:end), '\n')
			let cleaned_lines = substitute(shellescape(joined_lines), "'\\\\''", "\\\\'", 'g')
			let output = systemlist(cmd . " <<< $" . cleaned_lines)
		endif
	else
		redir => output
		execute a:cmd
		redir END
		let output = split(output, "\n")
	endif
	vnew
	let w:scratch = 1
	setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
	call setline(1, output)
endfunction

command! -nargs=1 -complete=command -bar -range Redir silent call Redir(<q-args>, <range>, <line1>, <line2>)
