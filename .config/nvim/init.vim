" Plugins
call plug#begin(stdpath('data') . '/plugged')
Plug 'andymass/vim-matchup'
Plug 'nvim-lua/plenary.nvim'
Plug 'L3MON4D3/LuaSnip'

Plug 'pificaria/preto'
Plug 'pificaria/vim-sunbather'

Plug 'rmagatti/auto-session'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'vijaymarupudi/nvim-fzf'

Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope-bibtex.nvim'
Plug 'chentoast/marks.nvim'

Plug 'skywind3000/asyncrun.vim'
Plug 'lervag/vimtex'

" Plug 'preservim/vim-markdown'
Plug 'ixru/nvim-markdown'
Plug 'jakewvincent/mkdnflow.nvim'
Plug 'SidOfc/mkdx'
Plug 'Pocco81/true-zen.nvim'
Plug 'kana/vim-textobj-user'
Plug 'preservim/vim-textobj-quote'
Plug 'preservim/vim-textobj-sentence'
Plug 'frabjous/knap'

Plug 'ggandor/leap.nvim'
Plug 'kevinhwang91/nvim-hlslens'
Plug 'kevinhwang91/nvim-bqf'

Plug 'davidgranstrom/scnvim'
Plug 'madskjeldgaard/supercollider-h4x-nvim'
Plug 'madskjeldgaard/fzf-sc'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'nvim-treesitter/playground'

Plug 'rcarriga/nvim-notify'
Plug 'MunifTanjim/nui.nvim'
Plug 'stevearc/dressing.nvim'
Plug 'nvim-neo-tree/neo-tree.nvim', {'tag': 'v2.x'}

" Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
Plug 'neovim/nvim-lspconfig'
Plug 'folke/trouble.nvim'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'quangnguyen30192/cmp-nvim-tags'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'f3fora/cmp-spell'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'kdheepak/cmp-latex-symbols'
Plug 'hrsh7th/nvim-cmp'

Plug 'akinsho/toggleterm.nvim', {'tag' : 'v2.*'}
call plug#end()

" Cmp
set completeopt=menu,menuone,noselect
lua <<EOF

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
-- Setup nvim-cmp.
local cmp = require'cmp'
local luasnip = require'luasnip'

cmp.setup({
	snippet = {
		expand = function(args)
		require('luasnip').lsp_expand(args.body) 
		end,
	},  
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		["<Tab>"] = cmp.mapping(function(fallback)
		  if cmp.visible() then
			cmp.select_next_item()
		  elseif luasnip.expand_or_jumpable() then
			luasnip.expand_or_jump()
		  elseif has_words_before() then
			cmp.complete()
		  else
			fallback()
		  end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
		  if cmp.visible() then
			cmp.select_prev_item()
		  elseif luasnip.jumpable(-1) then
			luasnip.jump(-1)
		  else
			fallback()
		  end
		end, { "i", "s" }),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'tags' },
		{ name = 'luasnip' }, 
		{ name = 'latex_symbols' },
	})
})

  cmp.setup.filetype('gitcommit', {
	  sources = cmp.config.sources({
		  { name = 'cmp_git' }, 
	  })
  })

  cmp.setup.filetype('sh', {
	  sources = cmp.config.sources({
		{ name = 'path' },
	  })
  })
  
  cmp.setup.filetype('markdown', {
	  sources = cmp.config.sources({
		{ name = 'luasnip' }, 
		{ name = 'latex_symbols' },
		{ name = 'tags' },
	  })
  })

  cmp.setup.cmdline('/', {
	  mapping = cmp.mapping.preset.cmdline(),
	  sources = {
		  { name = 'buffer' }
	  }
  })

  cmp.setup.cmdline(':', {
	  mapping = cmp.mapping.preset.cmdline(),
	  sources = cmp.config.sources({
		  { name = 'path' }
	  }, {
		  { name = 'cmdline' }
	  })
	})
EOF

" Lspconfig.
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
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
require'lspconfig'.gopls.setup {
  on_attach = on_attach,
  capabilities = capabilities
}
require'lspconfig'.tsserver.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = {allow_incremental_sync = true, debounce_text_changes = 500}
}
require'lspconfig'.clangd.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {
	  "clangd",
	  "--background-index",
	  "--suggest-missing-includes",
	  "--clang-tidy",
	  "--completion-style=bundled",
	  "--header-insertion=iwyu"
  },
  flags = {debounce_text_changes = 150},
}
require'lspconfig'.texlab.setup {
  on_attach = on_attach,
  capabilities = capabilities
}
require'lspconfig'.rust_analyzer.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { os.getenv("HOME").."/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/bin/rust-analyzer" },
  settings = {
      ["rust-analyzer"] = {
    	  ["checkOnSave"] = {
    		["allTargets"] = false
  	      }
      }
  },
  flags = {allow_incremental_sync = true, debounce_text_changes = 500},
}
EOF

" Tree-sitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
	ensure_installed = {
		'query',
		'comment', 
		'bibtex', 
		'latex',
		'make',
		'cmake',
		'c', 
		'cpp', 
		'go', 
		'json',
		'css',
		'html', 
		'javascript', 
		'typescript', 
		'tsx', 
		'php',
		'python', 
		'rust',
		'ocaml',
		'ocaml_interface',
		'ocamllex',
		'markdown',
		'markdown_inline',
		'ledger',
		'lua',
		'vim',
		'scheme',
		'supercollider',
		'gitignore',
		'bash',
	},
	highlight = {
		enable = true,
		-- disable = { 'markdown' },
		additional_vim_regex_highlighting = { 'html' },
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
filetype on

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

" Listchars
set list
set listchars=tab:>-

" Folding
set foldmethod=syntax
set foldlevel=99

" FZF 
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
" imap <c-x><c-l> <plug>(fzf-complete-line)
" nmap <C-b> :Buffers<CR>
" nnoremap <leader>ff :Files<Cr>

" Go to paste position
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" Statusline
set laststatus=2
set statusline=\ %n\ %M\ %R\ %<%{mode()}\ %<%f\ %=%{strftime(\"%d.%m\ %H:%M\")}\;\ %c\,\ %l\/%L\ %Y%W\ 

" Pastetoggle key
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
au FileType tex,markdown setlocal conceallevel=0

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

autocmd filetype supercollider,scnvim,scdoc,supercollider.help lua require'supercollider-h4x'.setup()

lua << EOF
local scnvim = require 'scnvim'
local map = scnvim.map
local map_expr = scnvim.map_expr
scnvim.setup {
  keymaps = {
    ['<M-e>'] = map('editor.send_line', {'i', 'n'}),
    ['<C-e>'] = {
      map('editor.send_block', {'i', 'n'}),
      map('editor.send_selection', 'x'),
    },
    ['<CR>'] = map('postwin.toggle'),
    ['<M-CR>'] = map('postwin.toggle', 'i'),
    ['<M-L>'] = map('postwin.clear', {'n', 'i'}),
    ['<C-k>'] = map('signature.show', {'n', 'i'}),
    ['<F12>'] = map('sclang.hard_stop', {'n', 'x', 'i'}),
    ['<leader>st'] = map('sclang.start'),
    ['<leader>sk'] = map('sclang.recompile'),
    ['<F1>'] = map_expr('s.boot'),
    ['<F2>'] = map_expr('s.meter'),
  },
  editor = {
    highlight = {
      color = 'IncSearch',
    },
  },
  postwin = {
    float = {
      enabled = true,
    },
  },
  documentation = {
	  cmd = os.getenv("HOME")..'/.local/bin/pandoc',
	  keymaps = true,
  },
  snippet = {
	engine = {
		name = 'luasnip',
		options = {
			descriptions = true,
		},
	}
  }
}

scnvim.load_extension('fzf-sc')
EOF

" Moveção de linha
nnoremap <C-J> :m .+1<CR>==
nnoremap <C-K> :m .-2<CR>==
inoremap <C-J> <Esc>:m .+1<CR>==gi
inoremap <C-K> <Esc>:m .-2<CR>==gi
vnoremap <C-J> :m '>+1<CR>gv=gv
vnoremap <C-K> :m '<-2<CR>gv=gv

" OCaml
let g:opamshare = substitute(system('~/.local/bin/opam var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"

" Chadtree
" nnoremap <C-n> <cmd>CHADopen<cr>
" let g:chadtree_settings = { "options.polling_rate": 6.0 }

" Neo-tree
nnoremap <C-n> <cmd>Neotree source=filesystem reveal=true toggle=true position=float<CR>

" Notify
lua<<EOF
require'notify'.setup {
	background_colour = "#000000"
}
vim.notify = require("notify")
EOF

" Dressing
lua<<EOF
require('dressing').setup({
  input = {
    winhighlight = "NormalFloat:Normal",
  }
})
EOF

" Buffer utility
nnoremap <C-x><C-d> :bp\|bd #<CR>

" Markdown
let g:vim_markdown_no_default_key_mappings = 1
let g:vim_markdown_frontmatter = 1
let g:mkdx#settings = { 'highlight': { 'enable': 1 },
			\ 'enter': { 'shift': 1 },
			\ 'tab': { 'enable': 0 },
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
"	autocmd FileType markdown inoremap <expr> <c-l>z fzf#vim#complete({
"	\ 'source':  'rg --no-heading --smart-case  .',
"	\ 'reducer': function('<sid>make_note_link'),
"	\ 'options': '--ansi --exact --print-query --multi --reverse --margin 15%,0 --prompt "Link> "',
"	\ 'up':      '20%' })
	autocmd FileType markdown setlocal textwidth=0
	autocmd FileType markdown setlocal wrapmargin=0
	autocmd FileType markdown setlocal linebreak
	autocmd FileType markdown setlocal nowrap
	autocmd FileType markdown setlocal wrap
	autocmd FileType markdown setlocal nonumber
	" autocmd FileType markdown inoremap <c-c>c <Esc>vip<CR>:s/­ //eg<CR>vip<CR>:s/\s\{2,}/ /eg<CR>
	autocmd FileType markdown inoremap <c-l>s <cmd>s/\(\(\s\)\s\{1,}\\|­ \)/\2/ge<CR><cmd>noh<cr>
	autocmd FileType markdown vnoremap <c-l>s <c-u>:s/\(\(\s\)\s\{1,}\\|­ \)/\2/eg<CR><cmd>:noh<CR>
	autocmd FileType markdown setlocal spelllang=pt_br,en_us,de_de,fr
	autocmd FileType markdown setlocal spellcapcheck=
	autocmd FileType markdown nnoremap <F1> :setlocal spell!<cr>
	autocmd FileType markdown inoremap <F1> <c-o>:setlocal spell!<cr>
	autocmd FileType markdown nnoremap <BS> :e#<CR>
	nnoremap gI :silent ! qiv <cfile><CR>
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
		MkdnNextLink = false,
        MkdnPrevLink = false,
		MkdnTableNextCell = false,
		MkdnTablePrevCell = false,
		MkdnGoBack = false,
		MkdnGoForward = false,
		MkdnEnter = false,
		MkdnFollowLink = {'n', '<CR>'},
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
\ },
\ 'gf_on_steroids': 0
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

" Virtual line remappings
inoremap <down> <c-\><c-o>gj
inoremap <up> <c-\><c-o>gk
nnoremap <down> gj
nnoremap <up> gk
vnoremap <down> gj
vnoremap <up> gk

" True zen
lua<<EOF
require'true-zen'.setup {
	modes = {
		ataraxis = {
			minimum_writing_area = { width = 80, height = 0.9 },
		},
	},
}
EOF
nmap <Leader>g :TZAtaraxis<CR>

" Marks
lua<<EOF
require'marks'.setup {
  -- whether to map keybinds or not. default true
  default_mappings = true,
  -- which builtin marks to show. default {}
  builtin_marks = { ".", "<", ">", "^" },
  -- whether movements cycle back to the beginning/end of buffer. default true
  cyclic = true,
  -- whether the shada file is updated after modifying uppercase marks. default false
  force_write_shada = false,
  -- how often (in ms) to redraw signs/recompute mark positions. 
  -- higher values will have better performance but may cause visual lag, 
  -- while lower values may cause performance penalties. default 150.
  refresh_interval = 250,
  -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
  -- marks, and bookmarks.
  -- can be either a table with all/none of the keys, or a single number, in which case
  -- the priority applies to all marks.
  -- default 10.
  sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
  -- disables mark tracking for specific filetypes. default {}
  excluded_filetypes = {},
  -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
  -- sign/virttext. Bookmarks can be used to group together positions and quickly move
  -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
  -- default virt_text is "".
  bookmark_0 = {
    sign = "⚑",
    virt_text = "hello world",
    -- explicitly prompt for a virtual line annotation when setting a bookmark from this group.
    -- defaults to false.
    annotate = false,
  },
  mappings = {}
}
EOF

" textobj
augroup textobj_sentence
  autocmd!
  autocmd FileType markdown call textobj#sentence#init()
  autocmd FileType textile call textobj#sentence#init()
augroup END

augroup textobj_quote
  autocmd!
  autocmd FileType markdown call textobj#quote#init()
  autocmd FileType textile call textobj#quote#init()
  autocmd FileType text call textobj#quote#init({'educate': 0})
  map <silent> <leader>qc <Plug>ReplaceWithCurly
  map <silent> <leader>qs <Plug>ReplaceWithStraight
augroup END

" hlslens
lua<<EOF
local kopts = {noremap = true, silent = true}

vim.api.nvim_set_keymap('n', 'n',
    [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
    kopts)
vim.api.nvim_set_keymap('n', 'N',
    [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
    kopts)
vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

vim.api.nvim_set_keymap('n', '<Leader>l', ':noh<CR>', kopts)local kopts = {noremap = true, silent = true}

vim.api.nvim_set_keymap('n', 'n',
    [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
    kopts)
vim.api.nvim_set_keymap('n', 'N',
    [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
    kopts)
vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

vim.api.nvim_set_keymap('n', '<Leader>l', ':noh<CR>', kopts)
EOF

" Trouble
lua << EOF
require'trouble'.setup {
	icons = false
}
vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>Trouble<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xl", "<cmd>Trouble loclist<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xq", "<cmd>Trouble quickfix<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "gR", "<cmd>Trouble lsp_references<cr>",
  {silent = true, noremap = true}
)
EOF

" bqf
lua<<EOF
require'bqf'.setup {
	auto_enable = true,
	auto_resize_height = true,
}
EOF

" Leap
lua<<EOF
require('leap').set_default_keymaps()
EOF

" LuaSnip
lua<<EOF
require'luasnip'.setup {
	snip_env = {
		s = require("luasnip.nodes.snippet").S,
		sn = require("luasnip.nodes.snippet").SN,
		t = require("luasnip.nodes.textNode").T,
		f = require("luasnip.nodes.functionNode").F,
		i = require("luasnip.nodes.insertNode").I,
		c = require("luasnip.nodes.choiceNode").C,
		d = require("luasnip.nodes.dynamicNode").D,
		r = require("luasnip.nodes.restoreNode").R,
		l = require("luasnip.extras").lambda,
		rep = require("luasnip.extras").rep,
		p = require("luasnip.extras").partial,
		m = require("luasnip.extras").match,
		n = require("luasnip.extras").nonempty,
		dl = require("luasnip.extras").dynamic_lambda,
		fmt = require("luasnip.extras.fmt").fmt,
		fmta = require("luasnip.extras.fmt").fmta,
		conds = require("luasnip.extras.expand_conditions"),
		types = require("luasnip.util.types"),
		events = require("luasnip.util.events"),
		parse = require("luasnip.util.parser").parse_snippet,
		ai = require("luasnip.nodes.absolute_indexer"),
	},
}
require'luasnip'.filetype_extend('markdown', { 'tex' })
require("luasnip.loaders.from_lua").load {
	paths = './snippets/',
}
require("luasnip").add_snippets("supercollider", require("scnvim/utils").get_snippets())
EOF

imap <silent><expr> <C-z> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
inoremap <silent> <C-x> <cmd>lua require'luasnip'.jump(-1)<Cr>
snoremap <silent> <C-z> <cmd>lua require('luasnip').jump(1)<Cr>
snoremap <silent> <C-x> <cmd>lua require('luasnip').jump(-1)<Cr>
imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
command! LuaSnipEdit :lua require("luasnip.loaders").edit_snippet_files()

" Toggle line numbers
nnoremap <leader>nu :set nu!<CR>

" Telescope
lua<<EOF
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local copy_to_clipboard = function(prompt_bufnr)
	local entry = action_state.get_selected_entry()
	actions.close(prompt_bufnr)
	local filename, row, col

	if entry.path or entry.filename then
		filename = entry.filename or entry.path

		-- TODO: Check for off-by-one
		row = entry.row or entry.lnum
		col = vim.F.if_nil(entry.col, 1)
	elseif not entry.bufnr then
		-- TODO: Might want to remove this and force people
		-- to put stuff into `filename`
		local value = entry.value
		if not value then
			vim.notify("actions.set.edit", {
				msg = "Could not do anything with blank line...",
				level = "WARN",
			})
			return
		end
		if type(value) == "table" then
			value = entry.display
		end

		local sections = vim.split(value, ":")

		filename = sections[1]
		row = tonumber(sections[2])
		col = tonumber(sections[3])
	end

	vim.fn.setreg(vim.v.register, filename)
	vim.notify("Path copied to clipboard!")
end

require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ["<C-h>"] = "which_key",
      }
    }
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  },
  pickers = {
	  buffers = {
		  sort_lastused = true,
		  ignore_current_buffer = true,
		  sort_mru = true,
	  },
	  live_grep = {
		  mappings = {
			  i = {
				  ["<C-y>"] = copy_to_clipboard,
			  },
		  }
	  },
  find_files = {
	  mappings = {
		  n = {
			  ["cd"] = function(prompt_bufnr)
			  local selection = require("telescope.actions.state").get_selected_entry()
			  local dir = vim.fn.fnamemodify(selection.path, ":p:h")
			  require("telescope.actions").close(prompt_bufnr)
			  -- Depending on what you want put `cd`, `lcd`, `tcd`
			  vim.cmd(string.format("silent lcd %s", dir))
			  end
		  },
		  i = {
			  ["<C-y>"] = copy_to_clipboard,
			  },
		  },
	  },
  },
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')
require('telescope').load_extension('bibtex')
EOF

nnoremap <leader>ff <cmd>Telescope find_files<cr>
inoremap <C-f>f <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <C-b> <cmd>Telescope buffers theme=ivy<cr>
inoremap <C-b> <cmd>Telescope buffers theme=ivy<cr>
nnoremap <leader>fm <cmd>Telescope marks<cr>
nnoremap z= <cmd>Telescope spell_suggest theme=ivy<cr>
nnoremap <leader>fh <cmd>Telescope highlights<cr>
nnoremap <leader>fd <cmd>Telescope lsp_document_symbols<cr>
inoremap <C-f>d <cmd>Telescope lsp_document_symbols<cr>
nnoremap <leader>fw <cmd>Telescope lsp_workspace_symbols<cr>
nnoremap <leader>ft <cmd>Telescope treesitter theme=ivy<cr>
inoremap <C-f>t <cmd>Telescope treesitter theme=ivy<cr>
nnoremap <leader>fT <cmd>Telescope tags theme=ivy<cr>
nnoremap <leader>fG <cmd>Telescope current_buffer_fuzzy_find<cr>
inoremap <C-f>G <cmd>Telescope current_buffer_fuzzy_find<cr>
autocmd FileType markdown inoremap @@ <cmd>Telescope bibtex theme=ivy<cr>
autocmd FileType tex inoremap @@ <cmd>Telescope bibtex theme=ivy<cr>

" Knap
lua<<EOF
-- set shorter name for keymap function
local kmap = vim.keymap.set

-- F5 processes the document once, and refreshes the view
kmap('i','<F5>', function() require("knap").process_once() end)
kmap('v','<F5>', function() require("knap").process_once() end)
kmap('n','<F5>', function() require("knap").process_once() end)

-- F6 closes the viewer application, and allows settings to be reset
kmap('i','<F6>', function() require("knap").close_viewer() end)
kmap('v','<F6>', function() require("knap").close_viewer() end)
kmap('n','<F6>', function() require("knap").close_viewer() end)

-- F7 toggles the auto-processing on and off
kmap('i','<F7>', function() require("knap").toggle_autopreviewing() end)
kmap('v','<F7>', function() require("knap").toggle_autopreviewing() end)
kmap('n','<F7>', function() require("knap").toggle_autopreviewing() end)

-- F8 invokes a SyncTeX forward search, or similar, where appropriate
kmap('i','<F8>', function() require("knap").forward_jump() end)
kmap('v','<F8>', function() require("knap").forward_jump() end)
kmap('n','<F8>', function() require("knap").forward_jump() end)

local gknapsettings = {
    texoutputext = "pdf",
    textopdf = "pdflatex -synctex=1 -halt-on-error -interaction=batchmode %docroot%",
	textopdfviewerlaunch = os.getenv("HOME").."/bin/sioyek --inverse-search 'nvim --headless -es --cmd \"lua require('\"'\"'knaphelper'\"'\"').relayjump('\"'\"'%servername%'\"'\"','\"'\"'%1'\"'\"',%2,%3)\"' --reuse-instance %outputfile%",
	textopdfforwardjump = os.getenv("HOME").."/bin/sioyek --inverse-search 'nvim --headless -es --cmd \"lua require('\"'\"'knaphelper'\"'\"').relayjump('\"'\"'%servername%'\"'\"','\"'\"'%1'\"'\"',%2,%3)\"' --reuse-instance --forward-search-file %srcfile% --forward-search-line %line% %outputfile%",
    textopdfviewerrefresh = "none",
	mdoutputext = "pdf",
	mdtohtml = os.getenv("HOME").."/.local/bin/pandoc --mathjax --css "..os.getenv("HOME").."/waste/eta/.pandoc/style.css --standalone %docroot% -f markdown-smart -N --filter "..os.getenv("HOME").."/.local/bin/pandoc-citeproc --filter "..os.getenv("HOME").."/waste/repos/01mf02/pandocfilters/defenv.py --csl "..os.getenv("HOME").."/waste/eta/.pandoc/math.csl --bibliography "..os.getenv("HOME").."/waste/sync/k/n/db.bib -o %outputfile%",
	mdtohtmlviewerlaunch = "surf %outputfile%",
	mdtohtmlviewerrefresh = "kill -HUP %pid%",
	mdtopdf = os.getenv("HOME").."/.local/bin/pandoc %docroot% --pdf-engine=xelatex -H "..os.getenv("HOME").."/waste/eta/.pandoc/header.tex -f markdown-smart -N --filter "..os.getenv("HOME").."/.local/bin/pandoc-citeproc --filter "..os.getenv("HOME").."/waste/repos/01mf02/pandocfilters/defenv.py --csl "..os.getenv("HOME").."/waste/eta/.pandoc/math.csl --bibliography "..os.getenv("HOME").."/waste/sync/k/n/db.bib -o %outputfile%",
	mdtopdfviewerlaunch = os.getenv("HOME").."/bin/sioyek %outputfile%",
	mdtopdfviewerrefresh = "none",
}
vim.g.knap_settings = gknapsettings
EOF

" Show highlights under cursor
function! Syn()
  for id in synstack(line("."), col("."))
    echo synIDattr(id, "name")
  endfor
endfunction
command! -nargs=0 Syn call Syn()
