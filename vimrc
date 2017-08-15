" === vim-plug ============================================
" === 插件列表 =================
call plug#begin('~/.vim/plugged')

Plug 'https://github.com/vim-syntastic/syntastic'
" Plug 'https://github.com/davidhalter/jedi-vim'
" Plug 'https://github.com/ervandew/supertab'
Plug 'https://github.com/Valloric/YouCompleteMe'

call plug#end()

" === 插件配置=================
" ----- syntastic -------------
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['pyflakes']

" ----- jedi-vim ------------------
"let g:jedi#auto_initialization = 0
let g:jedi#popup_on_dot = 1
let g:jedi#completions_command= "<C-/>"

" 是否匹配括号
set nocompatible

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 显示相关  
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 一行超过120个字符，背景色变红色
highlight OverLength ctermbg=red ctermfg=white guibg=#592929 
match OverLength /\%121v.\+/

" set shortmess=atI   " 启动的时候不显示那个援助乌干达儿童的提示  
" winpos 5 5          " 设定窗口位置  
" set lines=40 columns=155    " 设定窗口大小  
set number              " 显示行号  
syntax on           " 语法高亮  
" 配色方案
 color ron
" color desert
"color torte

set ruler           " 显示标尺  
set cul
set cuc
autocmd InsertEnter * se cul
set cursorline              " 突出显示当前行, 当前行下划线

set showcmd         " 输入的命令显示出来，看的清楚些  
set cmdheight=2     " 命令行（在状态行下）的高度，设置为1  
set whichwrap+=<,>,h,l   " 允许backspace和光标键跨越行边界(不建议)  
" set novisualbell    " 不要闪烁(不明白)  
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}   "状态行显示的内容  
set laststatus=2    " 启动显示状态行(1),总是显示状态行(2)  
set foldenable      " 允许折叠  
set foldmethod=manual   " 手动折叠  
" set background=dark "背景使用黑色 
""set nocompatible  "去掉讨厌的有关vi一致性模式，避免以前版本的一些bug和局限  
" 显示中文帮助
if version >= 603
    set helplang=cn
    set encoding=utf-8
endif

set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936
set fileencoding=utf-8

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""新文件标题""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"新建.c,.h,.sh,.java文件，自动插入文件头 
autocmd BufNewFile *.cpp,*.[ch],*.py,*.sh,*.java exec ":call SetTitle()" 
""定义函数SetTitle，自动插入文件头 
func SetTitle() 
    "如果文件类型为.sh文件 
    if &filetype == 'sh' 
        call setline(1,"\#########################################################################") 
        call append(line("."), "\# File Name: ".expand("%")) 
        call append(line(".")+1, "\# Author: Liuxd") 
        call append(line(".")+2, "\# Created Time: ".strftime("%c")) 
        call append(line(".")+3, "\#########################################################################") 
        call append(line(".")+4, "\#!/bin/bash") 
        call append(line(".")+5, "") 
    elseif &filetype == 'cpp'
        call setline(1,"#include<iostream>")
        call append(line("."), "using namespace std;")
        call append(line(".")+1, "") 
    elseif &filetype == 'c'
        call setline(1,"#include<stdio.h>")
        call append(line("."), "")
    elseif &filetype == 'python'
        call setline(1,"# coding: uf-8")
	call append(line("."), "")
    endif
    "新建文件后，自动定位到文件末尾
    autocmd BufNewFile * normal G
endfunc 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"键盘命令
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 按F10编译运行程序
map <F10> :call CompileRunGcc()<CR>
func! CompileRunGcc()
    exec "w"
    if &filetype == 'python'
        exec "!time python %"
    elseif &filetype == 'c'
        exec "!g++ % -o %<"
        exec "! ./%<"
    elseif &filetype == 'cpp'
        exec "!g++ % -o %<"
        exec "! ./%<"
    elseif &filetype == 'java' 
        exec "!javac %" 
        exec "!java %<"
    elseif &filetype == 'sh'
        :!./%
    endif
endfunc
"C,C++的调试
map <F8> :call Rungdb()<CR>
func! Rungdb()
    exec "w"
    exec "!g++ % -g -o %<"
    exec "!gdb ./%<"
endfunc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""实用设置

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 增强模式中命令行自动完成操作
set wildmenu
" 使回格键（backspace)正常处理indent, eol, start等
set backspace=2
" 设置当文件被改动时自动载入
set autoread
" quickfix模式
autocmd FileType c,cpp map <buffer> <leader><space> :w<cr>:make<cr>
"
"允许插件  
filetype plugin on
"共享剪贴板  
set clipboard+=unnamed 
"make 运行
:set makeprg=g++\ -Wall\ \ %
"自动保存
set autowrite
"set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ %{&encoding}\ %c:%l/%L%)\

" 在处理未保存或只读文件的时候，弹出确认
set confirm
" 历史记录数
set history=1000
"搜索逐字符高亮
set hlsearch
set incsearch

filetype on
" 可以在buffer的任何地方使用鼠标（类似office中在工作区双击鼠标定位）
set mouse=a
set selection=exclusive
set selectmode=mouse,key
" 通过使用: commands命令，告诉我们文件的哪一行被改变过
set report=0
" 在被分割的窗口间显示空白，便于阅读
set fillchars=vert:\ ,stl:\ ,stlnc:\
" 高亮显示匹配的括号
set showmatch
" 匹配括号高亮的时间（单位是十分之一秒）
set matchtime=1
" 光标移动到buffer的顶部和底部时保持7行距离
set scrolloff=7

" tab替换为空格
nmap tt:%s/\t/    /g<CR>
" 自动缩进
set autoindent
set cindent
" tab键的宽度
set softtabstop=4
set shiftwidth=4
" 使用空格代替制表符
set expandtab
" 在行和段开始处使用制表符
set smarttab

filetype plugin indent on 
"打开文件类型检测, 加了这句才可以用智能补全
set completeopt=longest,menu

" ==========================================================
" key-map
" ==========================================================
" Smart way between windows
map <C-j> <C-w>j
map <C-h> <C-w>h
map <C-k> <C-w>k
map <C-l> <C-w>l

