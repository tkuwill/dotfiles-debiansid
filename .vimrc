" This will make esc key respond faster when having the config below.
set ttimeoutlen=70

" My default keyboard layout (已針對 Linux 註解，若未來有裝 smartim 的 Linux 版再開啟)
" let g:smartim_default = 'com.apple.keylayout.ABC'

" Background color config
set t_Co=256 
set background=light

" General config
set shortmess-=S
set cursorline
set cursorcolumn
set splitbelow splitright
set wildmenu
set number
set softtabstop=4
set smartcase
set hlsearch
set listchars=tab:>~,space:.
set cindent
set ai
syntax on

" Some funky status bar code its seems
set laststatus=2            " set the bottom status bar

function! ModifiedColor()
    if &mod == 1
        hi statusline guibg=White ctermfg=8 guifg=OrangeRed4 ctermbg=15
    else
        hi statusline guibg=White ctermfg=8 guifg=DarkSlateGray ctermbg=15
    endif
endfunction

" Formats the statusline
set statusline=%F                            " file name and path
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}] "file format
set statusline+=%y      "filetype
set statusline+=%h      "help file flag
set statusline+=[%{getbufvar(bufnr('%'),'&mod')?'modified':'saved'}]      
"modified flag

set statusline+=%r      "read only flag

set statusline+=\ %=                        " align left
set statusline+=Line:%l/%L[%p%%]            " line X of Y [percent of file]
set statusline+=\ Col:%c                    " current column
set statusline+=\ Buf:%n                    " Buffer number

" Folding for markdown
let g:markdown_folding = 1
au FileType markdown setlocal foldlevel=1
 
"Keymapping
nnoremap <C-L> :noh<CR>
nnoremap <C-A> <Home>
nnoremap <C-E> <End>
" map <F2> :NERDTreeToggle<CR>

" spelling check in English
set spelllang=en,cjk
nnoremap <F3> :set spell<CR>
nnoremap <F4> :set nospell<CR>

" For relative-number-toggle.
nnoremap <silent> <F1> :set relativenumber!<CR>

" For moving cursor in Insert mode (but not use arrow keys)
inoremap <C-F> <Right>
inoremap <C-B> <Left>
inoremap <C-A> <Home>
inoremap <C-E> <End>

" Credit from: https://vim.fandom.com/wiki/Insert_line_numbers
" 修正：加上 '<,'> 確保 GNU nl 只作用在 Debian 的選取範圍內
vnoremap <F6> :'<,'>!nl -ba -w 2 -s '. '<CR>
vnoremap <F7> :'<,'>!nl -ba -w 3 -s '. '<CR>

" Customized commands
command -nargs=1 Insertnum :'<,'>!nl -ba -w <args> -s '. '

" 讓 Ctrl-X Ctrl-E 可以編輯長指令（與您的 zshrc 完美配合）
" autoload -z edit-command-line
