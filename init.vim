" Automatic vim-plug install
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  silent !mkdir -p ~/.vim/autoload
  silent !ln -s ~/.local/share/nvim/site/autoload/plug.vim ~/.vim/autoload/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

set nocompatible
set title

call plug#begin('~/.local/share/nvim/plugged')
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'dsznajder/vscode-es7-javascript-react-snippets'
Plug 'frankier/neovim-colors-solarized-truecolor-only'
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'leafgarland/typescript-vim'
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
Plug 'pangloss/vim-javascript'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'HerringtonDarkholme/yats.vim'
call plug#end()

set termguicolors
set background=dark
colorscheme solarized

command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)
syntax on
let c_comment_strings=1
set cursorline
set path+=**

set mouse=a

let g:typescript_indent_disable = 0

set makeprg="make --silent debug"

set tabstop=8 		" show <TAB> as eight spaces wide
set softtabstop=2	" indent two columns when tab is pressed
set shiftwidth=2	" indent two columns with operations and automatically
set expandtab		" use spaces, not <TAB>

set number			" show line numbers
set relativenumber		" make line numbers relative

set scrolloff=5

set ignorecase
set smartcase

filetype plugin indent on	" load filetype-specific indentation file

set foldenable			" enables folding
set foldlevelstart=10		" closes folds at level 10 and more at start
set foldnestmax=10		" disables folding more than 10 nests

set splitright
set splitbelow

set wildmenu			" show command autocompletions

set showmatch			" highlight the matching paren when cursoring over

set incsearch			" search as characters are entered
let &colorcolumn=80

let mapleader=" "
map <leader>w <C-w>
" enable yanking to system clipboard
set clipboard=unnamed
" paste from system clipboard
nmap <leader>p "+p
nmap <leader>y "+y

" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>

" stop highlighting matches
nnoremap <leader>sc :nohlsearch<CR>

" json
nnoremap <leader>jq :%!jq ''<left>
nnoremap <leader>jg :%!gron --no-sort<CR>
nnoremap <leader>ju :%!gron -u --no-sort<CR>

nnoremap <leader>is :source $MYVIMRC<CR>
nnoremap <leader>ie :tabe $MYVIMRC<CR>
nnoremap <leader>t <Esc>:tabnew<CR>

" Do not deselect when indenting
vnoremap < <gv
vnoremap > >gv

" Navigate between windows
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l
nnoremap <leader>o :only<CR>
nnoremap <leader>f <C-w>F
nnoremap <leader>gf <C-w>gF
nnoremap <silent> <leader>g :Gstatus<CR>

" start insert mode when entering terminal buffer
autocmd BufWinEnter term://* startinsert
" leave terminal mode with escape
tnoremap <Esc> <C-\><C-n>

if exists("g:gui_oni")
  set number
  set noshowmode
  set noruler
  set laststatus=0
  set noshowcmd
  set mouse=a
endif

" if hidden is not set, TextEdit might fail.
set hidden

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
vmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
