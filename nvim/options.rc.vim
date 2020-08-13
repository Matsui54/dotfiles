filetype plugin indent on
syntax enable

set number
set title

set expandtab
set tabstop=2
set shiftwidth=0
set smartindent

set clipboard=unnamedplus

set smartcase
set ignorecase

set showmatch
set matchpairs+=<:>

set undofile

set termguicolors

set completeopt-=preview

set splitright

if exists('&inccommand')
  set inccommand=nosplit
endif

if exists('&pumblend')
  set pumblend=30
endif

if exists('&winblend')
  set winblend=30
endif

if has('nvim')
  colorscheme iceberg
  highlight clear MatchParen
  highlight MatchParen cterm=underline, gui=underline
endif

function! s:is_wsl()
  return executable('cmd.exe')
endfunction

if has('unix') && !s:is_wsl()
  augroup im_change
    autocmd!
    autocmd InsertEnter * call system('fcitx-remote -c')
    autocmd InsertLeave * call system('fcitx-remote -o')
    autocmd VimEnter * call system('fcitx-remote -o')
    autocmd VimLeave * call system('fcitx-remote -c')
    autocmd CmdlineLeave * call system('fcitx-remote -o')
    autocmd CompleteChanged * call system('fcitx-remote -c')
  augroup END
elseif has('win32') || has('win64')
  " for windows
  py3file <sfile>:h/autoload/win_ime_con.py
  python3 wic = WinImeCon()

  augroup win_ime_con
    autocmd!
    autocmd BufWinEnter * let b:win_ime_con_is_active = 0
    autocmd BufWinEnter * let b:win_ime_con_is_insert = 0
    autocmd InsertEnter * call vimrc#on_insert_enter()
    autocmd InsertLeave * call vimrc#disable_ime()
    autocmd CmdlineLeave * call vimrc#disable_ime()
  augroup END
endif

augroup MyAutoCmd
  autocmd!
  autocmd VimLeavePre,BufWrite * mksession! ~/.vim/sessions/saved_session.vim
augroup END

" netrw settings
let g:netrw_preview=1
autocmd FileType netrw call s:netrw_my_settings()
function! s:netrw_my_settings()
  nmap <buffer>l <CR>
  nmap <buffer>h -
endfunction

" tabline settiong
set showtabline=2
set tabline=%!tabline#MyTabLine()
