set nocompatible
filetype off

if empty(glob('~/.vim/autoload/plug.vim'))
  silent call system('mkdir -p ~/.vim/{autoload,bundle,cache,undo,backups,swaps}')
  silent call system('curl -fLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
  execute 'source  ~/.vim/autoload/plug.vim'
  augroup plugsetup
    au!
    autocmd VimEnter * PlugInstall
  augroup end
endif

call plug#begin('~/.vim/plugged')
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'endel/vim-github-colorscheme'
Plug 'kshenoy/vim-signature'
Plug 'terryma/vim-expand-region'
Plug 'tpope/vim-abolish'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-syntastic/syntastic'
Plug 'vimwiki/vimwiki'
Plug 'vito-c/jq.vim'
call plug#end()

filetype plugin indent on

" Persistent undo
set undofile
set undodir=~/.vim/undo
set undolevels=1000
set undoreload=10000

" Line wrapping and numbering
set nowrap number relativenumber

" Whitespace Management
set expandtab tabstop=4 paste

" Syntax Highlighting
filetype on
filetype plugin on
syntax enable

" Searching
set incsearch hlsearch smartcase
highlight Search cterm=NONE ctermbg=Yellow ctermfg=Black

" Setting toggle for word wrapping and line numbering. Useful for copying
" from vim buffer to clipboard.
noremap <F3> :set invrelativenumber invnumber invwrap<CR>

" Load visually selected text into / buffer.
vnoremap // y/<C-R>"<CR>

" Base color scheme
colorscheme desert
set t_Co=256
if &diff
  colorscheme github
endif

" Popup Mentu
highlight Pmenu ctermbg=darkgrey guibg=darkgrey

highlight ColorColumn ctermbg=darkred ctermfg=black
call matchadd('ColorColumn', '\%80v', 100)

" Highlight the active buffer's current line number.
highlight clear CursorLine
highlight CursorLineNR ctermbg=grey ctermfg=black

autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline

" Configuring vimwiki
let g:vimwiki_list = [{'path': '~/local/vimwiki/',
                     \ 'syntax': 'default',
                     \ 'folding': '',
                     \ 'ext': '.md'},
                     \{'path': '~/local/vimwiki-personal/',
                     \ 'syntax': 'default',
                     \ 'folding': '',
                     \ 'ext': '.md'}]

" Open help in a vertical split.
autocmd FileType help wincmd L
autocmd FileType jq setlocal expandtab

" FZF configurations
nnoremap <silent> <C-p> :FZF<CR>

" LSP configurations
function! s:on_lsp_buffer_enabled() abort
    " setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd :LspDefinition<CR>
    nmap <buffer> gr :LspReferences<CR>
    nmap <buffer> gi :LspImplementation<CR>
    nmap <buffer> gt :LspTypeDefinition<CR>

    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> <leader>d :LspDocumentDiagnostics<CR>

    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)

    nmap <buffer> K <plug>(lsp-hover)

    let g:lsp_format_sync_timeout = 1000

    let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
    let g:lsp_document_highlight_enabled = 1
    let g:lsp_highlights_enabled = 1
    let g:lsp_log_file = expand('~/vim-lsp.log')
    let g:lsp_semantic_enabled = 1
    let g:lsp_signs_enabled = 1           " enable diagnostics signs in the gutter

    let g:lsp_preview_float = 1
    let g:lsp_show_workspace_edits = 1
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" Google specific configurations.
if filereadable(expand("~/.google.vimrc"))
    source ~/.google.vimrc
endif
