let mapleader = ","

filetype plugin indent on
set t_Co=256
colorscheme lucius
set nocompatible
set autoindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab
set textwidth=79
set cc=+1
set laststatus=2
set statusline=%t\ %{fugitive#statusline()}\ %y\ format:\ %{&ff};\ [%c,%l]
set wildchar=<Tab>
set whichwrap=h,l
set formatoptions=l
set lbr
set modeline
syntax on
set incsearch
set gfn=Monaco:h12
set number

" Replace selected text in visual mode
vnoremap <C-r> "hy:%s/<C-r>h/gc<left><left><left>

" Quicker key shortcuts
nnoremap <silent> <Leader>w :w<CR>
inoremap <Leader><Leader> <esc>
nnoremap <silent> <Leader>c :q<CR>
nnoremap <silent> <Leader>p :set paste<CR>
nnoremap <silent> <Leader>n :set nopaste<CR>

" Code Folding
set foldmethod=indent
set foldlevel=99
nnoremap <silent> f za<CR>
nnoremap <silent> F zA<CR>

set guioptions-=T

" HTML
autocmd FileType html setlocal shiftwidth=2
autocmd FileType html setlocal tabstop=2
autocmd FileType html setlocal softtabstop=2
autocmd FileType html setlocal textwidth=0
" CSS
autocmd FileType css setlocal shiftwidth=2
autocmd FileType css setlocal tabstop=2
autocmd FileType css setlocal softtabstop=2
autocmd FileType css setlocal textwidth=0
" JavaScript
autocmd FileType javascript setlocal shiftwidth=2
autocmd FileType javascript setlocal tabstop=2
autocmd FileType javascript setlocal softtabstop=2
autocmd FileType javascript setlocal textwidth=0

au BufRead,BufNewFile *.pegjs set filetype=javascript

" use html for MDN editing
autocmd BufNewFile,BufRead developer.mozilla.org.*.txt setlocal filetype=html

highlight BadWhitespace ctermbg=red guibg=red
au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
let python_highlight_all=1

" Fuzzy Finder
let g:fuf_coveragefile_exclude = '\v\~$|\.(o|exe|dll|bak|orig|swp|jpg|png|gif)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])|vendor/|_site|node_modules|^tmp'
nnoremap <silent> <Leader>f :FufCoverageFile<CR>
nnoremap <silent> <Leader>b :FufBuffer<CR>
nnoremap <silent> <Leader>r :FufMruFile<CR>
nnoremap <silent> <Leader>: :FufMruCmd<CR>

" YankRing
nnoremap <silent> <Leader>v :YRShow<CR>

" Gist
let g:gist_clip_command='pbcopy'
let g:gist_detect_filetype=1
nnoremap <silent> <Leader>V :'<,'>Gist<CR>

" toggle line numbers
nnoremap <silent> <Leader>l :set invnumber<CR>

" Taglist vars
" Display function name in status bar:
let g:ctags_statusline=1
" Automatically start script
let generate_tags=1
set tags+=$HOME/.vim/tags/python.ctags
" Displays taglist results in a vertical window:
let Tlist_Use_Horiz_Window=0
" Shorter commands to toggle Taglist display
nnoremap <silent> <F3> :TlistToggle<CR>
" Various Taglist display config:
let Tlist_Use_Right_Window=1
let Tlist_Compact_Format=1
let Tlist_Exit_OnlyWindow=1
let Tlist_GainFocus_On_ToggleOpen=1
let Tlist_File_Fold_Auto_Close=1
let Tlist_Inc_Winwidth=0

" let g:miniBufExplMapWindowNavVim = 1
" let g:miniBufExplMapWindowNavArrows = 1
" let g:miniBufExplMapCTabSwitchBufs = 1
" let g:miniBufExplModSelTarget = 1

" NERDTree
nnoremap <silent> <F2> :NERDTreeToggle<CR>
let g:netrw_list_hide=".*\.pyc$"

" OmniComplete
if version > 700
    autocmd FileType python set ofu=pythoncomplete#Complete
    autocmd FileType javascript set ofu=javascriptcomplete#CompleteJS
    autocmd FileType html set ofu=htmlcomplete#CompleteTags
    autocmd FileType css set ofu=csscomplete#CompleteCSS
    inoremap <expr> <C-Space> pumvisible() \|\| &omnifunc == '' ?
    \ "\<lt>C-n>" :
    \ "\<lt>C-x>\<lt>C-o><c-r>=pumvisible() ?" .
    \ "\"\\<lt>c-n>\\<lt>c-p>\\<lt>c-n>\" :" .
    \ "\" \\<lt>bs>\\<lt>C-n>\"\<CR>"
    imap <C-@> <C-Space>
    if has("colorcolumn")
        set colorcolumn=80
    endif
endif
" set ofu=syntaxcomplete#Complete

function <SID>PythonGrep(tool)
  set lazyredraw
  " Close any existing cwindows.
  cclose
  let l:grepformat_save = &grepformat
  let l:grepprogram_save = &grepprg
  set grepformat&vim
  set grepformat&vim
  let &grepformat = '%f:%l:%m'
  if a:tool == "pep8"
    let &grepprg = 'pep8 -r'
  elseif a:tool == "pylint"
    let &grepprg = 'pylint --output-format=parseable --reports=n'
  elseif a:tool == "pyflakes"
    let &grepprg = 'pyflakes'
  elseif a:tool == "pychecker"
    let &grepprg = 'pychecker --quiet -q'
  else
    echohl WarningMsg
    echo "PythonGrep Error: Unknown Tool"
    echohl none
  endif
  if &readonly == 0 | update | endif
  silent! grep! %
  let &grepformat = l:grepformat_save
  let &grepprg = l:grepprogram_save
  let l:mod_total = 0
  let l:win_count = 1
  " Determine correct window height
  windo let l:win_count = l:win_count + 1
  if l:win_count <= 2 | let l:win_count = 4 | endif
  windo let l:mod_total = l:mod_total + winheight(0)/l:win_count |
        \ execute 'resize +'.l:mod_total
  " Open cwindow
  execute 'belowright copen '.l:mod_total
  nnoremap <buffer> <silent> c :cclose<CR>
  set nolazyredraw
  redraw!
endfunction

function! s:ExecuteInShell(command, bang)
    let _ = a:bang != '' ? s:_ : a:command == '' ? '' : join(map(split(a:command), 'expand(v:val)'))

    if (_ != '')
        let s:_ = _
        let bufnr = bufnr('%')
        let winnr = bufwinnr('^' . _ . '$')
        silent! execute  winnr < 0 ? 'new ' . fnameescape(_) : winnr . 'wincmd w'
        setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap
        silent! :%d
        let message = 'Execute ' . _ . '...'
        call append(0, message)
        echo message
        silent! 2d | resize 1 | redraw
        silent! execute 'silent! %!'. _
        silent! execute 'resize ' . line('$')
        silent! execute 'syntax on'
        silent! execute 'autocmd BufUnload <buffer> execute bufwinnr(' . bufnr . ') . ''wincmd w'''
        silent! execute 'autocmd BufEnter <buffer> execute ''resize '' .  line(''$'')'
        silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . _ . ''', '''')<CR>'
        silent! execute 'nnoremap <silent> <buffer> <LocalLeader>g :execute bufwinnr(' . bufnr . ') . ''wincmd w''<CR>'
        silent! syntax on
    endif
endfunction

command! -complete=shellcmd -nargs=* -bang Shell call s:ExecuteInShell(<q-args>, '<bang>')
cabbrev shell Shell

if ( !hasmapto('<SID>PythonGrep(pyflakes)') && (maparg('<F4>') == '') )
  map <F4> :call <SID>PythonGrep('pyflakes-2.6')<CR>
  map! <F4> :call <SID>PythonGrep('pyflakes-2.6')<CR>
else
  if ( !has("gui_running") || has("win32") )
    echo "Python Pyflakes Error: No Key mapped.\n".
          \ "<F4> is taken and a replacement was not assigned."
  endif
endif

if ( !hasmapto('<SID>PythonGrep(pep8)') && (maparg('<F8>') == '') )
  map <F8> :call <SID>PythonGrep('pep8')<CR>
  map! <F8> :call <SID>PythonGrep('pep8')<CR>
else
  if ( !has("gui_running") || has("win32") )
    echo "Python pep8 Error: No Key mapped.\n".
          \ "<F8> is taken and a replacement was not assigned."
  endif
endif

nnoremap <silent> <F5> :Gstatus<CR>
nnoremap <silent> <F6> :Shell git diff<CR>
noremap <C-g><C-h> :Gbrowse<CR>
noremap <C-g><C-b> :Gblame<CR>
noremap <C-g><C-s> :Gstatus<CR>
noremap <C-g><C-d> :Gdiff<CR>
noremap <C-d><C-l> :diffget 2<CR>:diffupdate<CR>
noremap <C-d><C-r> :diffget 5<CR>:diffupdate<CR>
noremap <C-d><C-p> :dp<CR>:diffupdate<CR>
