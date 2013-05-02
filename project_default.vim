"if !exists("*LoadSession")
"function! LoadSession()
"if !filereadable("./session.vim")                "设置session文件的名字
"set sessionoptions-=curdir        "在session option中去掉curdir
"set sessionoptions+=sesdir        "在session option中加入sesdir
"mksession ./session.vim           "创建一个会话文件
"else
"exe "so ./session.vim"
"" source ./session.vim
"endif
"endfunction
"endif
"
"nmap <silent> <leader>ls :call LoadSession()<cr>

"if !filereadable("./filenametags")                "设置tag文件的名字
"exe "! ~/.vim/bin/mktags.sh"
"endif
"let g:LookupFile_TagExpr = '"./filenametags"'
