source ~/.vim/bundles.vim

let mapleader=","
set nocompatible
syntax on
set nu
set hlsearch
set showmatch
set incsearch
set ignorecase
set showcmd
set history=256  " Number of things to remember in history.
set autowrite  " Writes on make/shell commands
set wildmenu
set showmode
set t_Co=256
let g:Powerline_colorscheme = 'solarized256'
set backspace=indent,eol,start
imap <ESC>oA <ESC>ki
imap <ESC>oB <ESC>ji
imap <ESC>oC <ESC>li
imap <ESC>oD <ESC>hi

",ev to open config file
nmap <silent> <leader>ev :vsplit $MYVIMRC<CR>
",sv to reload config file
nmap <silent> <leader>sv :so $MYVIMRC<CR>:echom 'Resourced vimrc file'<CR>
"When .vimrc is edited, reload it 
autocmd! bufwritepost $MYVIMRC source $MYVIMRC
colorscheme desert

function! LoadSetting()
let pj_file = findfile("project.vim", ".;")
if (!empty(pj_file))
  let path = strpart(pj_file, 0, match(pj_file, "/project.vim$"))
  " add any database in current directory
  if filereadable(pj_file)
    exec "so ".pj_file
  else
    exec "so ~/.vim/project_default.vim"
  endif
else
  exec "so ~/.vim/project_default.vim"
endif
endfunction
autocmd VimEnter /* call LoadSetting()

let g:ProjectSession_File=""

fu! SaveSess()
  set sessionoptions-=curdir
  set sessionoptions+=sesdir
  set sessionoptions+=slash
  set sessionoptions+=unix
  set sessionoptions-=options
  execute 'mksession! '.g:ProjectSession_File
endfunction

fu! RestoreSess()
  execute 'source '.g:ProjectSession_File
endfunction

function! LoadProject()
let pj_file = findfile("filenametags", ".;")
if (!empty(pj_file))
  let path = strpart(pj_file, 0, match(pj_file, "/filenametags$"))
  " add any database in current directory
  if filereadable(pj_file)
    let g:LookupFile_TagExpr=string(pj_file)
  endif
else
  let g:LookupFile_TagExpr=string("./filenametags")
endif
if (!empty(path))
  cd path
endif

let session_file = "./session.vim"
let g:ProjectSession_File=session_file
if filereadable(session_file)
  call RestoreSess()
else
  call SaveSess()
endif

autocmd VimLeave * call SaveSess()

exec "silent !echo 'Generating Tags...'"
exec "silent !~/.vim/bin/mktags.sh"
call LoadSetting()
redraw!
echo "Done!"
endfunction
"au BufEnter /* call LoadProject()
nmap <silent> <leader>lp :call LoadProject()<cr>

"" 右下角显示光标位置
set ruler
"" 总是显示状态行
set laststatus=2
"" 自定义状态行
"set statusline=
"set statusline=%F%m%r%h%w
"set statusline+=[%L]
"set statusline+=[%{strlen(&ff)?&ff:'none'}]
"set statusline+=%=
"set statusline+=0x%-8B
"set statusline+=%-14(%l,%c%V%)
"set statusline+=%<%P

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" cscope setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" if has("cscope")
"   set csprg=/usr/local/bin/cscope
"   set csto=1
"   set cst
"   set nocsverb
"   " add any database in current directory
"   if filereadable("cscope.out")
"       cs add cscope.out
"   endif
"   set csverb
" endif
"
" nmap <C-@>s :cs find s <C-R>=expand("<cword>")<CR><CR>
" nmap <C-@>g :cs find g <C-R>=expand("<cword>")<CR><CR>
" nmap <C-@>c :cs find c <C-R>=expand("<cword>")<CR><CR>
" nmap <C-@>t :cs find t <C-R>=expand("<cword>")<CR><CR>
" nmap <C-@>e :cs find e <C-R>=expand("<cword>")<CR><CR>
" nmap <C-@>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
" nmap <C-@>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
" nmap <C-@>d :cs find d <C-R>=expand("<cword>")<CR><CR>
set cscopeprg=gtags-cscope
set cscopetag
"set cscopequickfix=c-,d-,e-,f-,g0,i-,s-,t-
au BufWritePost *.[ch] call UpdateGtags(expand('<afile>'))
au BufWritePost *.[ch]pp call UpdateGtags(expand('<afile>'))
au BufWritePost *.[ch]xx call UpdateGtags(expand('<afile>'))
au BufWritePost *.java call UpdateGtags(expand('<afile>'))
au BufWritePost *.cc call UpdateGtags(expand('<afile>'))
function! UpdateGtags(f)
  let dir = fnamemodify(a:f, ':p:h')
  exe 'silent !cd ' . dir . ' && global -u &> /dev/null &'
endfunction

function! LoadCscope()
let db = findfile("GTAGS", ".;")
if (!empty(db))
  let path = strpart(db, 0, match(db, "/GTAGS$"))
  set nocsverb " suppress 'duplicate connection' error
  set csto=0
  set cst
  " add any database in current directory
  if filereadable(db)
     exe "cs add " . db . " " . path
     nmap <C-c>s :cs find s <C-R>=expand("<cword>")<CR><CR>
     nmap <C-c>g :cs find g <C-R>=expand("<cword>")<CR><CR>
     nmap <C-c>c :cs find c <C-R>=expand("<cword>")<CR><CR>
     nmap <C-c>t :cs find t <C-R>=expand("<cword>")<CR><CR>
     nmap <C-c>e :cs find e <C-R>=expand("<cword>")<CR><CR>
     nmap <C-c>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
     nmap <C-c>i :cs find i <C-R>=expand("<cfile>")<CR><CR>
     "nmap <C-c>d :cs find d <C-R>=expand("<cword>")<CR><CR>
  " else add database pointed to by environment
  elseif $CSCOPE_DB != ""
     cs add $CSCOPE_DB
  endif
  set csverb
endif
endfunction
au BufEnter /* call LoadCscope()

" use F8 to toggle taglist
nnoremap <silent> <F8> :TlistToggle<CR>
let Tlist_GainFocus_On_ToggleOpen=1
let Tlist_Close_On_Select=0
let Tlist_Show_One_File = 1
let Tlist_Exit_OnlyWindow=1

""""""""""""""""""""""""""""""
" lookupfile setting
""""""""""""""""""""""""""""""
let g:LookupFile_MinPatLength = 2               "最少输入2个字符才开始查找
let g:LookupFile_PreserveLastPattern = 0        "不保存上次查找的字符串
let g:LookupFile_PreservePatternHistory = 1     "保存查找历史
let g:LookupFile_AlwaysAcceptFirst = 1          "回车打开第一个匹配项目
let g:LookupFile_AllowNewFiles = 0              "不允许创建不存在的文件
if filereadable("./filenametags")                "设置tag文件的名字
let g:LookupFile_TagExpr = '"./filenametags"'
endif

" lookup file with ignore case
function! LookupFile_IgnoreCaseFunc(pattern)
let _tags = &tags
try
let &tags = eval(g:LookupFile_TagExpr)
let newpattern = '\c' . a:pattern
let tags = taglist(newpattern)
catch
echohl ErrorMsg | echo "Exception: " . v:exception | echohl NONE
return ""
finally
let &tags = _tags
endtry
" Show the matches for what is typed so far.
let files = map(tags, 'v:val["filename"]')
return files
endfunction

let g:LookupFile_LookupFunc = 'LookupFile_IgnoreCaseFunc'
"映射LookupFile为,lk
nmap <silent> <leader>lf :LUTags<cr>
"映射LUBufs为,ll
nmap <silent> <leader>lb :LUBufs<cr>
"映射LUWalk为,lw
nmap <silent> <leader>lw :LUWalk<cr>

"===============================
"YCM
"===============================
let g:ycm_confirm_extra_conf = 0
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
map <F11> :YcmDiags<CR>
map <F12> :YcmForceCompileAndDiagnostics<CR>

"===============================
"ctrlp
"===============================
let g:ctrlp_by_filename = 1
let g:ctrlp_regexp = 1
let g:ctrlp_working_path_mode=''
let g:ctrlp_root_markers='.ctrlp'
let g:ctrlp_max_files = 0
let g:ctrlp_tabpage_position = 'ac'
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*        " Linux/MacOSX
let g:ctrlp_custom_ignore = {
            \ 'dir':  '\v[\/]\.(git|hg|svn)$',
            \ 'file': '\v\.(exe|so|dll|o|a|dylib)$',
            \ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
            \ }
let g:ctrlp_prompt_mappings = {
            \ 'PrtBS()':              ['<bs>', '<c-]>'],
            \ 'PrtDelete()':          ['<del>'],
            \ 'PrtDeleteWord()':      ['<c-w>'],
            \ 'PrtClear()':           ['<c-u>'],
            \ 'PrtSelectMove("j")':   ['<c-j>', '<down>'],
            \ 'PrtSelectMove("k")':   ['<c-k>', '<up>'],
            \ 'PrtSelectMove("t")':   ['<Home>', '<kHome>'],
            \ 'PrtSelectMove("b")':   ['<End>', '<kEnd>'],
            \ 'PrtSelectMove("u")':   ['<PageUp>', '<kPageUp>'],
            \ 'PrtSelectMove("d")':   ['<PageDown>', '<kPageDown>'],
            \ 'PrtHistory(-1)':       ['<c-n>'],
            \ 'PrtHistory(1)':        ['<c-p>'],
            \ 'AcceptSelection("e")': ['<cr>', '<2-LeftMouse>'],
            \ 'AcceptSelection("h")': ['<c-x>', '<c-cr>', '<c-s>'],
            \ 'AcceptSelection("t")': ['<c-t>'],
            \ 'AcceptSelection("v")': ['<c-v>', '<RightMouse>'],
            \ 'ToggleFocus()':        ['<s-tab>'],
            \ 'ToggleRegex()':        ['<c-r>'],
            \ 'ToggleByFname()':      ['<c-d>'],
            \ 'ToggleType(1)':        ['<c-f>', '<c-up>'],
            \ 'ToggleType(-1)':       ['<c-b>', '<c-down>'],
            \ 'PrtExpandDir()':       ['<tab>'],
            \ 'PrtInsert("c")':       ['<MiddleMouse>', '<insert>'],
            \ 'PrtInsert()':          ['<c-\>'],
            \ 'PrtCurStart()':        ['<c-a>'],
            \ 'PrtCurEnd()':          ['<c-e>'],
            \ 'PrtCurLeft()':         ['<c-h>', '<left>', '<c-^>'],
            \ 'PrtCurRight()':        ['<c-l>', '<right>'],
            \ 'PrtClearCache()':      ['<F5>'],
            \ 'PrtDeleteEnt()':       ['<F7>'],
            \ 'CreateNewFile()':      ['<c-y>'],
            \ 'MarkToOpen()':         ['<c-z>'],
            \ 'OpenMulti()':          ['<c-o>'],
            \ 'PrtExit()':            ['<esc>', '<c-c>', '<c-g>'],
            \ }

"===============================
"tabbar
"===============================
noremap tl :tabnext<CR>
noremap th :tabprev<CR>
noremap tn :tabnew<CR>
noremap td :tabclose<CR>"

"===============================
"Easymotion
"===============================

"===============================
"NerdComment
"===============================
filetype plugin on

"===============================
"NerdTree
"===============================
map <F9> :NERDTreeToggle<CR>

"
"autocmd VimEnter * wincmd p
"" NERDTree configuration
"let NERDTreeWinSize=35
"map  to toggle NERDTree window
