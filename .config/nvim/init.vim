" Plugins
call plug#begin(stdpath('data') . '/plugged')
Plug 'SirVer/ultisnips'
Plug 'andymass/vim-matchup'
Plug 'nvim-lua/plenary.nvim'

Plug 'pificaria/preto'
Plug 'pificaria/vim-sunbather'

Plug 'rmagatti/auto-session'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'vijaymarupudi/nvim-fzf'

Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'chentoast/marks.nvim'

Plug 'fhill2/telescope-ultisnips.nvim'
Plug 'skywind3000/asyncrun.vim'
Plug 'junegunn/limelight.vim', { 'on':  'Limelight' }
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'lervag/vimtex'

" Plug 'preservim/vim-markdown'
Plug 'ixru/nvim-markdown'
Plug 'jakewvincent/mkdnflow.nvim'
Plug 'SidOfc/mkdx'
" Plug 'arthurxavierx/vim-unicoder'

" Plug 'itchyny/calendar.vim'

Plug 'davidgranstrom/scnvim', { 'do': { -> scnvim#install() } }
Plug 'madskjeldgaard/supercollider-h4x-nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-refactor'

Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
Plug 'neovim/nvim-lspconfig'
Plug 'ms-jpq/coq_nvim', { 'branch': 'coq' }
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}

Plug 'akinsho/toggleterm.nvim', {'tag' : 'v2.*'}
call plug#end()

" Coq
let g:coq_settings = { 'auto_start': 'shut-up' }
lua << EOF
require("coq_3p") {
  { src = "nvimlua", short_name = "nLUA" },
  { src = "vimtex", short_name = "vTEX" },
}
EOF

" Setup lspconfig.
" Use an on_attach function to only map the following keys
" after the language server attaches to the current buffer
lua<<EOF
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      -- disable virtual text
      virtual_text = false,

      -- show signs
      signs = true,

      -- delay update diagnostics
      update_in_insert = false,
      -- display_diagnostic_autocmds = { "InsertLeave" },

    }
)

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

local coq = require("coq").lsp_ensure_capabilities(vim.lsp.protocol.make_client_capabilities())
require'lspconfig'.gopls.setup {
  on_attach = on_attach,
  capabilities = capabilities
}
require'lspconfig'.tsserver.setup {
  on_attach = on_attach,
  capabilities = capabilities
}
require'lspconfig'.clangd.setup {
  on_attach = on_attach,
  capabilities = capabilities
}
require'lspconfig'.texlab.setup {
  on_attach = on_attach,
  capabilities = capabilities
}
require'lspconfig'.rust_analyzer.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { os.getenv("HOME").."/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin/rust-analyzer" },
  settings = {
      ["rust-analyzer"] = {
    	  ["checkOnSave"] = {
    		["allTargets"] = "false"
  	      }
      }
  }
}
EOF

" Tree-sitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
	ensure_installed = {
		'bibtex', 
		'comment', 
		'c', 
		'cpp', 
		'go', 
		'html', 
		'javascript', 
		'python', 
		'rust',
		'ocaml',
		'typescript', 
		'tsx', 
		'css',
		'html',
		'latex',
		'markdown',
		'markdown_inline',
		'lua',
		'supercollider',
	},
	highlight = {
		enable = true,
		disable = { 'markdown' },
		additional_vim_regex_highlighting = true,
	},
	indent = {
		enable = false,
	},
	matchup = { enable = true, },
	refactor = {
		smart_rename = {
			enable = true,
			keymaps = {
				smart_rename = "grr",
				},
			},
		navigation = {
			enable = true,
			keymaps = {
				goto_definition = "gnd",
				list_definitions = "gnD",
				list_definitions_toc = "gO",
				goto_next_usage = "<a-*>",
				goto_previous_usage = "<a-#>",
				},
			},
		},
}
EOF

" Basic 
set title
set encoding=utf-8
let mapleader=" "
set backspace=2
set history=50
set ruler
set showcmd
set incsearch
set autowrite
set hidden
set nu
set cursorline
syn on
set inccommand=nosplit
set whichwrap+=<,>,h,l

" Terminal colors
set termguicolors

" Define how many spaces tab will use, and the maximum line width
set shiftwidth=4
set softtabstop=4
set tabstop=4
set tw=80
set nowrap
set formatoptions-=t
set autoindent
set nolist
set listchars=tab:>-

" Folding
set foldmethod=syntax
set foldlevel=99

" FZF Configs
nnoremap <leader>ff :Files<Cr>
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
imap <c-x><c-l> <plug>(fzf-complete-line)
nmap <C-b> :Buffers<CR>

" Go to paste position
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" Statusline
set laststatus=2
set statusline=\ %n\ %M\ %R\ %<%{mode()}\ %<%f\ %=%{strftime(\"%d.%m\ %H:%M\")}\;\ %c\,\ %l\/%L\ %Y%W\ 

" Deactivate autoindent to paste
set pastetoggle=<F2>

" Expand %% to pwd 
cabbr %% <C-R>=expand('%:p:h')<CR>

" Alt-f and Alt-b on insert mode
imap f <S-Right>
imap b <S-Left>

" Plugin indent on
filetype plugin indent on

" Don't know what this is
let g:is_posix = 1

" Enable colors and set theme
" set t_Co=256
colorscheme sunbather

" Better search options
" set sw=1
set is hls ic scs
set sm
set shm=filmrwxt
set wildmode=longest,list

" wq = Wq = wQ ...
cab W w
cab Wq wq
cab wQ wq
cab WQ wq
cab Q q

" Filetype on
filetype on

" Haskell
let g:haskell_indent_if=4
let g:haskell_indent_case=4

" Eel
au BufWinEnter,BufRead,BufNewFile *.jsfx set filetype=eel2
au BufWinEnter,BufRead,BufNewFile *.jsfx-inc set filetype=eel2

" Faust
au BufWinEnter,BufRead,BufNewFile *.lib set filetype=faust
au BufWinEnter,BufRead,BufNewFile *.dsp set filetype=faust

" Python
let g:pyindent_open_paren = 'shiftwidth()'
let g:pyindent_nested_paren = 'shiftwidth()'
let g:pyindent_continue = 'shiftwidth()'

" HTML
autocmd BufWinEnter,BufRead,BufNewFile *.html setlocal filetype=html
autocmd FileType html,css setlocal tabstop=4 softtabstop=2 shiftwidth=2

" Ocaml
autocmd FileType ocaml setlocal nowrap 

" Makefiles
autocmd FileType make setlocal noexpandtab list

" Ledger
au BufNewFile,BufRead *.ldg,*.ledger setf ledger 

" UltiSnips
let g:UltiSnipsExpandTrigger = '<c-z>'
let g:UltiSnipsJumpForwardTrigger = '<c-z>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
let g:UltiSnipsSnippetDirectories=[$HOME.'/.config/nvim/UltiSnips', 'scnvim-data']

" Rust
function! Rusty()
    nnoremap <C-e> :terminal cargo run<cr>
    inoremap <C-e> <esc>:terminal cargo run<cr>
endfunction 

augroup rust
    autocmd!
  "  autocmd FileType rust call Rusty()
	autocmd FileType rust call YcmStuff()
augroup end

let g:rustfmt_command = "cargo fmt -- "

" Typescript
autocmd FileType typescript set shiftwidth=2 | set softtabstop=2 | set tabstop=2 | setlocal indentkeys+=0
autocmd FileType typescriptreact set shiftwidth=2 | set softtabstop=2 | set tabstop=2 | setlocal indentkeys+=0
autocmd FileType javascript set shiftwidth=2 | set softtabstop=2 | set tabstop=2 | setlocal indentkeys+=0
autocmd FileType javascriptreact set shiftwidth=2 | set softtabstop=2 | set tabstop=2 | setlocal indentkeys+=0
let g:typescript_opfirst='\%([<>=,?^%|*/&]\|\([-:+]\)\1\@!\|!=\|in\%(stanceof\)\=\>\)'
" let g:typescript_indent_disable = 1

" Latex
au BufWinEnter,BufRead,BufNewFile *.tex setf tex
au FileType tex setlocal wrap
let g:tex_flavor='latex'
" let g:vimtex_view_method='zathura'
let g:vimtex_view_enabled = 0
let g:vimtex_view_general_viewer = 'zathura'
let g:vimtex_quickfix_mode=2
let g:vimtex_quickfix_open_on_warning=0
let g:vimtex_compiler_latexmk_engines = {
    \ '_'                : '-xelatex',
    \}
let g:tex_conceal='abdmg'
hi clear Conceal

function! TexHighlights()
	hi! link texItalStyle Underlined
	hi! link texEmphStyle Underlined
	hi! link texBoldItalStyle Underlined
	hi! link texItalBoldStyle Underlined
endfunction

augroup TexColors
	autocmd!
	autocmd Filetype tex call TexHighlights()
augroup END

" Conceal
au FileType tex,markdown setlocal conceallevel=2

" Mouse
set mouse=a

" Shaders
autocmd BufRead,BufNewFile *.vert set filetype=cpp
autocmd BufRead,BufNewFile *.frag set filetype=cpp

" Julia
autocmd BufRead,BufNewFile *.ij set filetype=julia

" PHP
autocmd BufRead,BufNewFile *.php filetype plugin indent off
command! PhpFmt :1,$!phpcbf --standard=PEAR - 

" Modeline
set modeline

" C++
" au FileType cpp setlocal cino=:0l1g0t0
let g:clang_format#auto_formatexpr = 1
let g:clang_format#code_style = "google"

" Matchparen
let g:matchup_override_vimtex = 1
let g:matchup_matchparen_deferred = 1

" jsx-pretty
let g:vim_jsx_pretty_disable_tsx = 1

" Goyo
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!
nmap <Leader>g :Goyo<CR>
nmap <Leader>l :Limelight!!<CR>

" Terminal mode
nmap <Leader>tv :vsplit term://bash<CR>
nmap <Leader>ts :split term://bash<CR>

" Supercollider
augroup scnvim_settings
	autocmd FileType supercollider setlocal tabstop=4 softtabstop=4 shiftwidth=4
	autocmd BufNewFile,BufFilePre,BufRead *.scd set filetype=supercollider
	autocmd BufNewFile,BufFilePre,BufRead *.sc set filetype=supercollider
	autocmd FileType supercollider nmap <Leader>s :SCNvimStart<CR>
	autocmd FileType supercollider nmap <Leader>S :SCNvimStop<CR>
augroup END

let g:scnvim_scdoc = 1
let g:scnvim_scdoc_render_prg = '~/.local/bin/pandoc'
let g:scnvim_scdoc_render_args = '% --from html --to plain -o %'
let g:scnvim_postwin_orientation = 'h'
let g:scnvim_postwin_size = 5
autocmd filetype supercollider,scnvim,scdoc,supercollider.help lua require'supercollider-h4x'.setup()

" Moveção de linha
nnoremap <C-J> :m .+1<CR>==
nnoremap <C-K> :m .-2<CR>==
inoremap <C-J> <Esc>:m .+1<CR>==gi
inoremap <C-K> <Esc>:m .-2<CR>==gi
vnoremap <C-J> :m '>+1<CR>gv=gv
vnoremap <C-K> :m '<-2<CR>gv=gv

" Startify
" let g:startify_custom_header = ['asdf?']

" OCaml
let g:opamshare = substitute(system('~/.local/bin/opam var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"

" Chadtree
nnoremap <C-n> <cmd>CHADopen<cr>
let g:chadtree_settings = { "options.polling_rate": 6.0 }

" Buffer utility
nnoremap <C-x><C-d> :bp\|bd #<CR>

" Mkdn
let g:mkdx#settings = { 'highlight': { 'enable': 1 },
			\ 'enter': { 'shift': 1 },
			\ 'links': { 'external': { 'enable': 0 } },
			\ 'toc': { 'text': 'TOC', 'update_on_write': 1 },
			\ 'fold': { 'enable': 1 } }

augroup md_kbs
	function! s:make_note_link(l)
		let line = split(a:l[1], ':')
		let ztk_id = l:line[0]
		let mdlink = "[" . a:l[0] . "](" . ztk_id . ")"
		return mdlink
	endfunction
	autocmd FileType markdown vnoremap <c-l>s :s/\s\{2,}/ /g<cr>:noh<cr>
	autocmd FileType markdown inoremap <expr> <c-l>z fzf#vim#complete({
	\ 'source':  'rg --no-heading --smart-case  .',
	\ 'reducer': function('<sid>make_note_link'),
	\ 'options': '--exact --print-query --multi --reverse --margin 15%,0',
	\ 'up':    15})
	"autocmd FileType markdown setlocal textwidth=0
	autocmd FileType markdown setlocal wrapmargin=0
	autocmd FileType markdown setlocal linebreak
	autocmd FileType markdown setlocal nowrap
	autocmd FileType markdown setlocal wrap
	"autocmd FileType markdown set columns=80
augroup END
lua<<EOF
vim.cmd('autocmd FileType markdown set autowriteall')
require('mkdnflow').setup({
	perspective = {
		priority = 'root',
		fallback = 'current',
		root_tell = 'index.md',
	},
	mappings = {
		MkdnNewListItem = {'i', '<CR>'},
		MkdnTableNewRowBelow = {'n', '<leader>ir'},
		MkdnTableNewRowAbove = {'n', '<leader>iR'},
		MkdnTableNewColAfter = {'n', '<leader>ic'},
		MkdnTableNewColBefore = {'n', '<leader>iC'},
	},
	to_do = {
		symbols = {' ', '-', 'x'},
		not_started = ' ',
		in_progress = '-',
		complete = 'x',
	},
})
EOF

autocmd BufNewFile,BufRead ~/waste/sync/k/n/* setlocal tw=50

let g:vim_markdown_math = 1
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_frontmatter = 1

fun! s:MkdxRemap()
    nmap <buffer><silent> >> <Plug>(mkdx-indent)
    nmap <buffer><silent> << <Plug>(mkdx-unindent)
    vmap <buffer><silent> >> <Plug>(mkdx-indent)
    vmap <buffer><silent> << <Plug>(mkdx-unindent)
endfun
augroup Mkdx
    au!
    au FileType markdown,mkdx call s:MkdxRemap()
augroup END

let g:mkdx#settings = {
\ 'tab': {
\    'enable': 0
\ }
\ }

fun! s:MkdxGoToHeader(header)
    " given a line: '  84: # Header'
    " this will match the number 84 and move the cursor to the start of that line
    call cursor(str2nr(get(matchlist(a:header, ' *\([0-9]\+\)'), 1, '')), 1)
endfun

fun! s:MkdxFormatHeader(key, val)
    let text = get(a:val, 'text', '')
    let lnum = get(a:val, 'lnum', '')

    " if the text is empty or no lnum is present, return the empty string
    if (empty(text) || empty(lnum)) | return text | endif

    " We can't jump to it if we dont know the line number so that must be present in the outpt line.
    " We also add extra padding up to 4 digits, so I hope your markdown files don't grow beyond 99.9k lines ;)
    return repeat(' ', 4 - strlen(lnum)) . lnum . ': ' . text
endfun

fun! s:MkdxFzfQuickfixHeaders()
    " passing 0 to mkdx#QuickfixHeaders causes it to return the list instead of opening the quickfix list
    " this allows you to create a 'source' for fzf.
    " first we map each item (formatted for quickfix use) using the function MkdxFormatHeader()
    " then, we strip out any remaining empty headers.
    let headers = filter(map(mkdx#QuickfixHeaders(0), function('<SID>MkdxFormatHeader')), 'v:val != ""')

    " run the fzf function with the formatted data and as a 'sink' (action to execute on selected entry)
    " supply the MkdxGoToHeader() function which will parse the line, extract the line number and move the cursor to it.
    call fzf#run(fzf#wrap(
            \ {'source': headers, 'sink': function('<SID>MkdxGoToHeader') }
          \ ))
endfun

" finally, map it -- in this case, I mapped it to overwrite the default action for toggling quickfix (<PREFIX>I)
nnoremap <silent> <Leader>I :call <SID>MkdxFzfQuickfixHeaders()<Cr>

" Markdown footnotes
"" Taken from vim-pandoc/vim-markdownfootnotes.
if !exists('g:vimfootnotenumber')
	let g:vimfootnotenumber = 0
	let g:vimmkdnreferencenumber = 0
endif

if !exists('g:vimfootnotelinebreak')
	let g:vimfootnotelinebreak = 0
endif

fun! s:AddMkdnFootnotes(appendcmd) abort
    " save current position
    let s:cur_pos =  getpos('.')
    " Define search pattern for footnote definitions
    let l:pattern = '\v^\[\^(.+)\]:'
    let l:flags = 'eW'
    call cursor(1,1)
    " get first match
    let g:vimfootnotenumber = search(l:pattern, l:flags)
    if (g:vimfootnotenumber != 0)
        let l:temp = 1
        " count subsequent matches
        while search(l:pattern, l:flags) != 0
            let l:temp += 1
        endwhile
        let g:vimfootnotenumber = l:temp + 1
        " Return to position
        call setpos('.', s:cur_pos)
        let g:vimfootnotemark = g:vimfootnotenumber
    else
        let g:vimfootnotenumber = 1
        " Return to position
        call setpos('.', s:cur_pos)
        let g:vimfootnotemark = g:vimfootnotenumber
    endif
    let cr = g:vimfootnotelinebreak ? "\<cr>" : ''

    exe 'normal! '.a:appendcmd.'[^'.g:vimfootnotemark."]\<esc>"
    :below 4split
    normal! G
    exe "normal! o\<cr>[^".g:vimfootnotemark.']: '
    startinsert!
endfunction

fun! s:AddMkdnReference(appendcmd) abort
    " save current position
    let s:cur_pos =  getpos('.')
    " Define search pattern for footnote definitions
    let l:pattern = '\v^\[(.+)\]:'
    let l:flags = 'eW'
    call cursor(1,1)
    " get first match
    let g:vimmkdnreferencenumber = search(l:pattern, l:flags)
    if (g:vimmkdnreferencenumber != 0)
        let l:temp = 1
        " count subsequent matches
        while search(l:pattern, l:flags) != 0
            let l:temp += 1
        endwhile
        let g:vimmkdnreferencenumber = l:temp + 1
        " Return to position
        call setpos('.', s:cur_pos)
        let g:vimfootnotemark = g:vimmkdnreferencenumber
    else
        let g:vimmkdnreferencenumber = 1
        " Return to position
        call setpos('.', s:cur_pos)
        let g:vimfootnotemark = g:vimmkdnreferencenumber
    endif
    let cr = g:vimfootnotelinebreak ? "\<cr>" : ''

    exe 'normal! '.a:appendcmd.'['.g:vimfootnotemark."]\<esc>"
    :below 4split
    normal! G
    exe "normal! o\<cr>[".g:vimfootnotemark.']: '
    startinsert!
endfunction

inoremap <silent> ^^ <C-o>:<c-u>call <SID>AddMkdnFootnotes('a')<CR>
inoremap <silent> ^r <C-o>:<c-u>call <SID>AddMkdnReference('a')<CR>
nnoremap <silent> <Leader>fn :<c-u>call <SID>AddMkdnFootnotes('a')<CR>

" fzf-bibtex
let $FZF_BIBTEX_CACHEDIR = $HOME.'/.cache/fzf-bibtex/'
let $FZF_BIBTEX_SOURCES = $HOME.'/waste/bib/.cit/'

function! s:bibtex_cite_sink(lines)
    let r=system($HOME."/go/bin/bibtex-cite ", a:lines)
    execute ':normal! a' . r
endfunction

function! s:bibtex_markdown_sink(lines)
    let r=system($HOME."/go/bin/bibtex-markdown ", a:lines)
    execute ':normal! a' . r
endfunction

nnoremap <silent> <leader>c :call fzf#run({
                        \ 'source': $HOME.'/go/bin/bibtex-ls',
                        \ 'sink*': function('<sid>bibtex_cite_sink'),
                        \ 'up': '40%',
                        \ 'options': '--ansi --layout=reverse-list --multi --prompt "Cite> "'})<CR>

nnoremap <silent> <leader>m :call fzf#run({
                        \ 'source': $HOME.'/go/bin/bibtex-ls',
                        \ 'sink*': function('<sid>bibtex_markdown_sink'),
                        \ 'up': '40%',
                        \ 'options': '--ansi --layout=reverse-list --multi --prompt "Markdown> "'})<CR>


function! Bibtex_ls()
  let bibfiles = (
      \ globpath('.', '*.bib', v:true, v:true)
      \ )
  let bibfiles = join(bibfiles, ' ')
  let source_cmd = $HOME.'/go/bin/bibtex-ls '.bibfiles
  return source_cmd
endfunction

function! s:bibtex_cite_sink_insert(lines)
    let r=system($HOME."/go/bin/bibtex-cite ", a:lines)
    execute ':normal! a' . r
    call feedkeys('a', 'n')
endfunction

inoremap <silent> @@ <c-g>u<c-o>:call fzf#run({
                        \ 'source': Bibtex_ls(),
                        \ 'sink*': function('<sid>bibtex_cite_sink_insert'),
                        \ 'up': '40%',
                        \ 'options': '--ansi --layout=reverse-list --multi --prompt "Cite> "'})<CR>

" Auto-session
lua<<EOF
require('auto-session').setup({
	auto_save_enabled=false,
	log_level='error',
	auto_session_use_git_branch=true,
})
EOF

" Toggle term
lua<<EOF
require("toggleterm").setup{
	open_mapping = [[<c-\>]],
	terminal_mappings = false,
}
EOF
