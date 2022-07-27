call plug#begin('~/.local/share/nvim/site/plugged')
Plug 'SirVer/ultisnips'

Plug 'pificaria/preto'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'skywind3000/asyncrun.vim'
Plug 'junegunn/limelight.vim', { 'on':  'Limelight' }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-refactor'

Plug 'lervag/vimtex'
Plug 'preservim/vim-markdown'
Plug 'jakewvincent/mkdnflow.nvim'
Plug 'SidOfc/mkdx'
Plug 'jbyuki/venn.nvim'
Plug 'ellisonleao/glow.nvim'

Plug 'neovim/nvim-lspconfig'
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
Plug 'nvim-telescope/telescope-bibtex.nvim'
call plug#end()

" Tree-sitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
	ensure_installed = {
		'c', 'cpp', 'go', 'html', 'javascript', 'python', 'rust', 'typescript', 'tsx', 'markdown'
	},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = true,
	},
	indent = {
		enable = true,
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

" Define how many spaces tab will use, and the maximum line width
set shiftwidth=4
set softtabstop=4
set tabstop=4
set tw=50
set nowrap
set formatoptions-=t
set autoindent
set nolist
set listchars=tab:>-
" set textwidth=0
" set wrapmargin=0
" set wrap
set linebreak 

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

" Expand %% to pwd 
cabbr %% <C-R>=expand('%:p:h')<CR>

" Don't know what this is
let g:is_posix = 1

" Enable colors and set theme
set t_Co=256
colorscheme preto

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

" Remember cursor position
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

" Chadtree
nnoremap <C-n> <cmd>CHADopen<cr>
let g:chadtree_settings = { "options.polling_rate": 6.0 }

" Coq
" let g:coq_settings = { 'auto_start': 'shut-up' } 
lua << EOF
require("coq_3p") {
  { src = "nvimlua", short_name = "nLUA" },
}
EOF

" Time insertion
nnoremap <leader>d "=strftime("%Y/%m/%d")<CR>P
nnoremap <leader>t "=strftime("%T")<CR>P
nnoremap <leader>dt "=strftime("%Y/%m/%d %T")<CR>P
nnoremap <leader>hj "=strftime("[%d](%Y-%m-%d.md)")<CR>P

" LSP
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
EOF

" Telescope
lua << EOF
require"telescope".load_extension("bibtex")
EOF
nnoremap <leader>bib <cmd>Telescope bibtex<cr>

" Venn
lua<<EOF
-- venn.nvim: enable or disable keymappings
function _G.Toggle_venn()
    local venn_enabled = vim.inspect(vim.b.venn_enabled)
    if venn_enabled == "nil" then
        vim.b.venn_enabled = true
        vim.cmd[[setlocal ve=all]]
        -- draw a line on HJKL keystokes
        vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", {noremap = true})
        -- draw a box by pressing "f" with visual selection
        vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", {noremap = true})
    else
        vim.cmd[[setlocal ve=]]
        vim.cmd[[mapclear <buffer>]]
        vim.b.venn_enabled = nil
    end
end
-- toggle keymappings for venn using <leader>v
vim.api.nvim_set_keymap('n', '<leader>v', ":lua Toggle_venn()<CR>", { noremap = true})
EOF

" Glow
lua<<EOF
require('glow').setup({
  style = "dark",
  width = 120,
})
vim.api.nvim_set_keymap("n", "<C-w>z", "<C-w>|<C-w>_", { noremap = true, silent = true})
EOF

" Mkdn
let g:mkdx#settings     = { 'highlight': { 'enable': 1 },
                        \ 'enter': { 'shift': 1 },
                        \ 'links': { 'external': { 'enable': 0 } },
                        \ 'toc': { 'text': 'TOC', 'update_on_write': 1 },
                        \ 'fold': { 'enable': 1 } }

" Markdown
augroup md_kbs
	function! s:make_note_link(l)
		let line = split(a:l[1], ':')
		let ztk_id = l:line[0]
		let mdlink = "[" . a:l[0] . "](" . ztk_id . ")"
		return mdlink
	endfunction
	autocmd FileType markdown nnoremap <leader>d "=strftime("%Y/%m/%d")<CR>P
	autocmd FileType markdown nnoremap <leader>t "=strftime("%T")<CR>P
	autocmd FileType markdown nnoremap <leader>dt "=strftime("%Y/%m/%d %T")<CR>P
	autocmd FileType markdown nnoremap <leader>hj "=strftime("[%d](%Y-%m-%d.md)")<CR>P
	autocmd FileType markdown inoremap <expr> <c-l>z fzf#vim#complete({
	\ 'source':  'rg --no-heading --smart-case  .',
	\ 'reducer': function('<sid>make_note_link'),
	\ 'options': '--exact --print-query --multi --reverse --margin 15%,0',
	\ 'up':    15})
	"autocmd FileType markdown setlocal textwidth=0
	autocmd FileType markdown setlocal wrapmargin=0
	autocmd FileType markdown setlocal linebreak
	autocmd FileType markdown setlocal nowrap
	" autocmd FileType markdown set wrap
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
		MkdnNewListItem = {'i', '<CR>'}
	}
})
EOF

let g:vim_markdown_math = 1
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_frontmatter = 1

" Moveção de linha
nnoremap <C-J> :m .+1<CR>==
nnoremap <C-K> :m .-2<CR>==
inoremap <C-J> <Esc>:m .+1<CR>==gi
inoremap <C-K> <Esc>:m .-2<CR>==gi
vnoremap <C-J> :m '>+1<CR>gv=gv
vnoremap <C-K> :m '<-2<CR>gv=gv

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

" UltiSnips
let g:UltiSnipsExpandTrigger = '<c-z>'
let g:UltiSnipsJumpForwardTrigger = '<c-z>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
let g:UltiSnipsSnippetDirectories=[$HOME.'/.config/nvim/UltiSnips', 'scnvim-data']
