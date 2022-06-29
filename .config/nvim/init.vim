" Plugins
call plug#begin(stdpath('data') . '/plugged')
Plug 'SirVer/ultisnips'
Plug 'andymass/vim-matchup'
Plug 'nvim-lua/plenary.nvim'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'


" Plug 'nvim-telescope/telescope.nvim'
" Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

Plug 'fhill2/telescope-ultisnips.nvim'
Plug 'skywind3000/asyncrun.vim'
" Plug '/home/nil/waste/forks/vim-pandoc-markdown-preview'
Plug 'vim-pandoc/vim-pandoc-syntax', { 'branch': 'minimized' }
Plug 'pangloss/vim-javascript'
" Plug 'maxmellon/vim-jsx-pretty'
Plug 'leafgarland/typescript-vim'
" Plug 'peitalin/vim-jsx-typescript'
" Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'junegunn/limelight.vim', { 'on':  'Limelight' }
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
" Plug 'gilgigilgil/anderson.vim'
" Plug 'romainl/Apprentice'
" Plug 'lurst/austere.vim'
" Plug 'davidosomething/vim-colors-meh'
" Plug 'fxn/vim-monochrome'
Plug 'pificaria/preto'
" Plug 'pgdouyon/vim-yin-yang'
" Plug 'danishprakash/vim-yami'
" Plug 'Lokaltog/vim-monotone'
" Plug 'andreypopp/vim-colors-plain'
" Plug 'owickstrom/vim-colors-paramount'
" Plug 'aditya-azad/candle-grey'
" Plug 'xdefrag/vim-beelzebub'
" Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'lervag/vimtex'
" Plug 'rhysd/vim-clang-format'
" Plug 'ycm-core/YouCompleteMe'
" Plug 'davidgranstrom/scnvim', { 'do': { -> scnvim#install() }, 'on': 'SCNvimStart' }

Plug 'davidgranstrom/scnvim', { 'do': { -> scnvim#install() } }
Plug 'madskjeldgaard/supercollider-h4x-nvim'

" Plug 'ervandew/supertab'
" Plug 'vim-syntastic/syntastic'
Plug 'mhinz/vim-startify'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-refactor'
" Plug 'yamatsum/nvim-nonicons'
" Plug 'kyazdani42/nvim-web-devicons' " for file icons
" Plug 'kyazdani42/nvim-tree.lua'
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}

Plug 'neovim/nvim-lspconfig'

" Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
" Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
" Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}

Plug 'quangnguyen30192/cmp-nvim-tags'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
" Plug 'ray-x/cmp-treesitter'
Plug 'hrsh7th/nvim-cmp'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'
call plug#end()

" Cmp
set completeopt=menu,menuone,noselect

lua <<EOF
-- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  mapping = {
	['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
	['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
	['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
	['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
  },
  sources = cmp.config.sources({
      { name = 'nvim_lsp' },
	  { name = 'tags' },
      { name = 'ultisnips' }, 
    }, {
      { name = 'buffer' },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Setup lspconfig.
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
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

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
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

" LSP Config
" lua <<EOF
" require'lspconfig'.gopls.setup{}
" require'lspconfig'.tsserver.setup{}
" require'lspconfig'.clangd.setup{}
" require'lspconfig'.rust_analyzer.setup{
"   cmd = { "~/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/bin/rust-analyzer" },
"   settings = {
" 	  ["rust-analyzer"] = {
" 		  ["checkOnSave"] = {
" 			  ["allTargets"] = "false"
" 		  }
" 	  }
"   }
" }
" EOF

" Telescope config
" lua <<EOF
" -- You dont need to set any of these options. These are the default ones. Only
" -- the loading is important
" require('telescope').setup {
"   defaults = {
"     preview = false,
" 	color_devicons = true,
"   },
"   extensions = {
"     fzf = {
"       fuzzy = true,                    -- false will only do exact matching
"       override_generic_sorter = true,  -- override the generic sorter
"       override_file_sorter = true,     -- override the file sorter
"       case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
"                                        -- the default case_mode is "smart_case"
"     }
"   }
" }
" -- To get fzf loaded and working with telescope, you need to call
" -- load_extension, somewhere after setup function:
" require('telescope').load_extension('fzf')
" require('telescope').load_extension('ultisnips')
" EOF

" Tree-sitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
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

" Define how much spaces tab will use, and the maximum line width
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
" let g:fzf_layout = {'down': '40%'}
" Disable statusline when in popup mode.
" if has('nvim') && !exists('g:fzf_layout')
"   autocmd! FileType fzf
"   autocmd  FileType fzf set laststatus=0 noshowmode noruler
"     \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
" endif
nnoremap <leader>ff :Files<Cr>
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
" command! -bang -nargs=* LinesWithPreview
"     \ call fzf#vim#grep(
"     \   'rg -H --column --line-number --no-heading --colors "match:none" --color=always --smart-case . '.fnameescape(expand('%')), 1,
"     \   fzf#vim#with_preview(), <bang>0)
" 
" imap <c-x><c-k> <plug>(fzf-complete-word)
" imap <c-x><c-f> <plug>(fzf-complete-path)
" imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)
" nmap <c-x><c-l> :LinesWithPreview<CR>
nmap <C-b> :Buffers<CR>
" inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})

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
set t_Co=256
colorscheme preto

" Haskell
let g:haskell_indent_if=4
let g:haskell_indent_case=4

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

" YCM
let g:ycm_global_ycm_extra_conf = '~/.config/nvim/global_extra_conf.py'
inoremap <expr> <up> pumvisible() ? '<c-e><up>' : '<up>'
inoremap <expr> <down> pumvisible() ? '<c-e><down>' : '<down>'
let g:ycm_rust_toolchain_root = $HOME.'/.rustup/toolchains/stable-x86_64-unknown-linux-gnu'
let g:ycm_key_list_select_completion = ['<C-n>']
let g:ycm_key_list_previous_completion = ['<C-p>']
let g:ycm_filetype_blacklist = {
      \ 'tagbar': 1,
      \ 'notes': 1,
      \ 'markdown': 1,
      \ 'netrw': 1,
      \ 'unite': 1,
      \ 'text': 1,
      \ 'vimwiki': 1,
      \ 'pandoc': 1,
      \ 'infolog': 1,
      \ 'leaderf': 1,
      \ 'mail': 1
      \}

" Snips
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
" let :g:UltiSnipsSnippetDirectories=['UltiSnips', 'scnvim-data', '~/.vim/UltiSnips']
let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/UltiSnips', 'scnvim-data']

" plasticboy/markdown
" let g:vim_markdown_math=1
" let g:vim_markdown_folding_disabled = 1
" let g:vim_markdown_frontmatter = 1

" Rust
" YCM KEYBINDINGS
function! YcmStuff() 
    nnoremap si :YcmCompleter GoToDefinition<cr>
    nnoremap sk :YcmRestartServer<cr>
    nnoremap <F1> :YcmCompleter FixIt<cr>
    nnoremap K :YcmCompleter GetDoc<cr>
    nnoremap ; :YcmCompleter GetType<cr>
endfunction

function! Rusty()
    nnoremap <C-e> :terminal cargo run<cr>
    inoremap <C-e> <esc>:terminal cargo run<cr>
endfunction 

augroup rust
    autocmd!
  "  autocmd FileType rust call Rusty()
	autocmd FileType rust call YcmStuff()
augroup end

" Typescript
augroup typescript
    autocmd!
	autocmd FileType rust call YcmStuff()
augroup end
autocmd FileType typescript set shiftwidth=2 | set softtabstop=2 | set tabstop=2 | setlocal indentkeys+=0
autocmd FileType javascript set shiftwidth=2 | set softtabstop=2 | set tabstop=2 | setlocal indentkeys+=0
let g:typescript_opfirst='\%([<>=,?^%|*/&]\|\([-:+]\)\1\@!\|!=\|in\%(stanceof\)\=\>\)'
let g:typescript_indent_disable = 1
let g:rustfmt_command = "cargo fmt -- "

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
" au FileType tex,markdown setlocal conceallevel=2

" Mouse
set mouse=a

" Shaders
autocmd BufRead,BufNewFile *.vert set filetype=cpp
autocmd BufRead,BufNewFile *.frag set filetype=cpp

" Julia
autocmd BufRead,BufNewFile *.ij set filetype=julia

" Markdown-pandoc-preview
let g:md_pdf_viewer="zathura"
let g:md_args = "-N --filter ~/.local/bin/pandoc-citeproc --filter ~/waste/repos/01mf02/pandocfilters/defenv.py -H ~/waste/eta/.pandoc/header.tex -f markdown-smart"
let g:asyncrun_open=1

" vim-pandoc/syntax
augroup pandoc_syntax
    au! BufNewFile,BufFilePre,BufRead *.md set filetype=pandoc | set wrap
augroup END
let g:pandoc#modules#disabled = ["folding"]
au Filetype pandoc set expandtab
let g:pandoc#syntax#flavor#minimized = 1
let g:pandoc#spell#enabled = 0

" markdown-preview.nvim
" let g:mkdp_auto_start = 0
" let g:mkdp_browser = 'surf'
" let g:mkdp_refresh_slow = 1

" PHP
autocmd BufRead,BufNewFile *.php filetype plugin indent off
command! PhpFmt :1,$!phpcbf --standard=PEAR - 

" Modeline
set modeline

" C++
" au FileType cpp setlocal cino=:0l1g0t0
let g:clang_format#auto_formatexpr = 1
let g:clang_format#code_style = "google"
" let g:syntastic_cpp_checkers = ['cpplint']
" let g:syntastic_c_checkers = ['cpplint']
" let g:syntastic_cpp_cpplint_exec = '~/.local/bin/cpplint'
" The following two lines are optional. Configure it to your liking!
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0

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

" NerdTree
" nmap <C-n> :NERDTreeToggle %<CR>

" Terminal mode
nmap <Leader>tv :vsplit term://bash<CR>
nmap <Leader>ts :split term://bash<CR>
" tnoremap <Esc> <C-\><C-n>

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
let g:startify_custom_header = ['asdf?']

" OCaml
let g:opamshare = substitute(system('~/.local/bin/opam var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"

" Telescope keymaps
" nnoremap <leader>ff <cmd>Telescope find_files<cr>
" nnoremap <leader>fg <cmd>Telescope live_grep<cr>
" nnoremap <C-b> <cmd>Telescope buffers theme=cursor sort_lastused=true<cr>
" nnoremap <leader>fn <cmd>Telescope file_browser<cr>

" NvimTree
" nnoremap <C-n> :NvimTreeToggle<CR>
" nnoremap <leader>r :NvimTreeRefresh<CR>
" nnoremap <leader>n :NvimTreeFindFile<CR>
" let g:nvim_tree_show_icons = {
"     \ 'git': 0,
"     \ 'folders': 0,
"     \ 'files': 1,
"     \ 'folder_arrows': 1,
"     \ }
" lua <<EOF
" -- following options are the default
" -- each of these are documented in `:help nvim-tree.OPTION_NAME`
" require'nvim-tree'.setup {
"   disable_netrw       = true,
"   hijack_netrw        = true,
"   open_on_setup       = false,
"   ignore_ft_on_setup  = {},
"   auto_close          = false,
"   open_on_tab         = false,
"   hijack_cursor       = false,
"   update_cwd          = false,
"   update_to_buf_dir   = {
"     enable = true,
"     auto_open = true,
"   },
"   diagnostics = {
"     enable = false,
"     icons = {
"       hint = "",
"       info = "",
"       warning = "",
"       error = "",
"     }
"   },
"   update_focused_file = {
"     enable      = false,
"     update_cwd  = false,
"     ignore_list = {}
"   },
"   system_open = {
"     cmd  = nil,
"     args = {}
"   },
"   filters = {
"     dotfiles = false,
"     custom = {}
"   },
"   view = {
"     width = 30,
"     height = 30,
"     hide_root_folder = false,
"     side = 'left',
"     auto_resize = false,
"     mappings = {
"       custom_only = false,
"       list = {}
"     }
"   }
" }
" EOF

" Coq
" nnoremap <leader>c :COQnow -s<CR>
" let g:coq_settings = { 'display.icons.mode': 'none', 'display.preview.border': 'shadow' }
" lua <<EOF
" require("coq_3p") {
"   { src = "nvimlua", short_name = "nLUA" },
"   { src = "vimtex", short_name = "vTEX" },
"   { src = "ultisnips", short_name = "US" },
" }
" EOF

" Chadtree
nnoremap <C-n> <cmd>CHADopen<cr>
let g:chadtree_settings = { "options.polling_rate": 6.0 }

" Buffer utility
nnoremap <C-x><C-d> :bp\|bd #<CR>
