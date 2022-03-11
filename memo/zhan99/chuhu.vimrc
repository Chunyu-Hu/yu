"set tags=/root/git/linux/tags;./tags;
"set tags=./tags;
"set autochdir
syntax on
filetype plugin indent on    " required
filetype plugin on
" plugin management
set nocompatible

"colo evening
set nu
set autoindent
set tabstop=4
set shiftwidth=4
set mouse=a
"set hlsearch

" 执行特定命令并保留光标位置及搜索历史
function! Preserve(command)
    let _s=@/
    let l = line(".")
    let c = col(".")
 execute a:command

 let @/=_s
        call cursor(l, c)
    endfunction
" 格式化全文
function! FullFormat()
 call Preserve("normal gg=G")
endfunction
nmap <M-F9> :call FullFormat()<CR>

if has("cscope")
	"set csprg=/usr/bin/cscope
	set csto=0
	set cst
	set nocsverb
	" add any database in current directory
	if filereadable("cscope.out")
		cs add cscope.out
	" else add database pointed to by environment
	elseif $CSCOPE_DB != ""
		cs add $CSCOPE_DB
	endif
	set csverb
endif

set ruler
set cursorline " 突出显示当前行
"imap <TAB> <C-X><C-N>
map <C-F12> :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
set cscopequickfix=s-,c-,d-,i-,t-,e-

nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-\>i :cs find i <C-R>=expand("<cfile>")<CR><CR>
nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>

"nmap <C-\>s :scs find s <C-R>=expand("<cword>")<CR><CR>

nmap <C-\><C-\>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-\><C-\>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-\><C-\>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-\><C-\>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-\><C-\>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-\><C-\>i :vert scs find i <C-R>=expand("<cfile>")<CR><CR>
nmap <C-\><C-\>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>n :cn<CR>
nmap <C-\>p :cp<CR>

map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
map <silent> <F9> :TlistToggle<cr> 
map <F3> :NERDTreeMirror<CR>
map <F3> :NERDTreeToggle<CR>

" 文件树设置 {{{
" 关闭NERDTree快捷键
let g:mapleader=','
let g:mapLeader=','

map ,ee :tabnew ~/.vimrc <CR><CR>
map ,ss :source ~/.vimrc <CR><CR>
map ,nd :NERDTree <CR>
map ,wm :WMToggle <CR>
map ,qd :WMToggle <CR>

let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1
let g:miniBufExplMoreThanOne=0


highlight Pmenu    guibg=darkgrey  guifg=black
highlight PmenuSel guibg=lightgrey guifg=black
" 自动关闭补全窗口
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
call vundle#begin('~/vim_plugins')
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
"Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
"Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
"Plugin 'ascenator/L9', {'name': 'newL9'}


" plug-in for YCM
"Plugin 'Valloric/YouCompleteMe'


" YCM-generator
"Plugin 'rdnetto/YCM-Generator'

" super-tab
Plugin 'ervandew/supertab'

" air-line
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" NerdTree
Plugin 'scrooloose/nerdtree'
" Plugin 'preservim/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
"Plugin 'The-NERD-tree'

" tag
Plugin 'ctags.vim'
Plugin 'minibufexpl.vim'

" tagbar
"Plugin 'majutsushi/tagbar'
Plugin 'taglist.vim'
Plugin 'winmanager'

" color
Plugin 'flazz/vim-colorschemes'
Plugin 'altercation/vim-colors-solarized'
Plugin 'morhetz/gruvbox'
Plugin 'dracula/vim'

" syntastic
"Plugin 'scrooloose/syntastic'
Plugin 'fedorenchik/qt-support.vim'
Plugin 'thinktainer/omnicppcomplete'
Plugin 'xaizek/vim-qthelp'
Plugin 'tyru/open-browser.vim'
Plugin 'dbeniamine/vim-compile'
Plugin 'https://github.com/voldikss/vim-translate-me'


"color_code
" Plugin 'jeaye/color_coded'

"tmux
" Plugin 'tmux-plugins/vim-tmux'

"cscope
" Plugin 'steffanc/cscopemaps.vim'
" Plugin 'cscope.vim'

"Latex
"  Plugin 'lervag/vimtex'
"文件树


" All of your Plugins must be added before the following line
call vundle#end()            " required
" To ignore plugin indent changes, instead use:
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
set rtp+=/root/vim_plugins/nerdtree-git-plugin/nerdtree_plugin/git_status.vim
:if getfsize(".vimscript")>0
source .vimscript
:endif

"let g:mapleader=','
"let g:mapLeader=','

let g:NERDTree_title="[NERDTree]"
"let g:winManagerWindowLayout="NERDTree|TagList"
"let g:winManagerWindowLayout='FileExplorer'
let g:winManagerWindowLayout='NERDTree|TagList'

map <leader>t :NERDTreeToggle<CR>
""当NERDTree为剩下的唯一窗口时自动关闭
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" autocmd vimenter * NERDTree
""修改树的显示图标
let g:NERDTreeDirArrows=2
let g:NERDTreeDirArrowExpandable = '►'
let g:NERDTreeDirArrowCollapsible = '▼'
let NERDTreeAutoCenter=1
" 显示行号
let NERDTreeShowLineNumbers=1
" 是否显示隐藏文件
let NERDTreeShowHidden=0
" 设置宽度
let NERDTreeWinSize=35
" 在终端启动vim时，共享NERDTree
let g:nerdtree_tabs_open_on_console_startup=1
" 忽略一下文件的显示
let NERDTreeIgnore=['\.pyc','\~$','\.swp', '\.cmd', '\.o']
"let g:NERDTreeShowIgnoredStatus = 1
let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }
" }}}

let Tlist_Show_One_File=1    "只显示当前文件的tags
let Tlist_WinWidth=40        "设置taglist宽度
let Tlist_Exit_OnlyWindow=1  "tagList窗口是最后一个窗口，则退出Vim
let Tlist_Use_Right_Window=1 "在Vim窗口右侧显示taglist窗口

let g:SuperTabDefaultCompletionType="context"  
let g:SuperTabRetainCompletionType=2
let g:SuperTabDefaultCompletionType=""

let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " 显示函数参数列表
let OmniCpp_MayCompleteDot = 1   " 输入 .  后自动补全
let OmniCpp_MayCompleteArrow = 1 " 输入 -> 后自动补全
let OmniCpp_MayCompleteScope = 1 " 输入 :: 后自动补全
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]

let g:qthelp_browser = 'qutebrowser &>/dev/null'

let g:netrw_nogx = 1
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

let g:openbrowser_browser_commands = [
\   {'name': 'qutebrowser',
\    'args': ["{browser}", "{uri}"]}
\]

let g:openbrowser_search_engines = extend(
\ get(g:, 'openbrowser_search_engines', {}),
\ {
\   'cppreference': 'https://en.cppreference.com/mwiki/index.php?title=Special%3ASearch&search={query}',
\   'qt': 'https://doc.qt.io/qt-5/search-results.html?q={query}',
\ },
\ 'keep'
\)
nnoremap <silent> <leader>cpp :call openbrowser#smart_search(expand('<cword>'), "cppreference")<CR>
nnoremap <silent> <leader>qt :call openbrowser#smart_search(expand('<cword>'), "qt")<CR>
nnoremap <C-\>q :call openbrowser#smart_search(expand('<cword>'), "qt")<CR>
nnoremap <C-\>h :QHelpOnThis<CR><CR>:redr!<CR>

let g:VimCompileCustomBuilder='make.sh'
let g:VimCompileCustomBuilderCompile='./make.sh'


" Translate
nmap <silent> <Leader>t <Plug>Translate
vmap <silent> <Leader>t <Plug>TranslateV
" Leader>w 翻译光标下的文本，在窗口中显示
nmap <silent> <Leader>w <Plug>TranslateW
vmap <silent> <Leader>w <Plug>TranslateWV
" " Leader>r 替换光标下的文本为翻译内容
nmap <silent> <Leader>r <Plug>TranslateR
vmap <silent> <Leader>r <Plug>TranslateRV


"autocmd BufRead *.html map <F5> :exe ':silent !open -a /Applications/Firefox.app %'<CR>:redr!<CR>

function! NERDTree_Start()
    exec 'NERDTree'
endfunction

function! NERDTree_IsValid()
 return 1
endfunction
