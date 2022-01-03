call plug#begin()

Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/vim-vsnip'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'rust-lang/rust.vim'
Plug 'shaunsingh/nord.nvim'
Plug 'tpope/vim-sensible'

call plug#end()

set encoding=utf-8
set tabstop=4
set shiftwidth=4
set autoindent

set number
set scrolloff=3
set sidescroll=3

set ruler
set cc=80
set nowrap

set mouse=a

set noswapfile
set hidden

set nofoldenable
set lazyredraw

set clipboard+=unnamedplus

syntax enable
filetype plugin indent on
colorscheme nord

nnoremap <silent> <C-p> :GFiles<CR>
nnoremap <silent> <C-f> :Lines<CR>

lua<<EOF
require'nvim-treesitter.configs'.setup {
	ensure_installed = "all",
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
}

local on_attach = function(client, bufnr)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    -- Mappings
    local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local nvim_lsp = require('lspconfig')
local servers = { 
	'cssls', 
	'html', 
	'jsonls',
	'tsserver',
}

for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup {
		on_attach = on_attach,
		capabilities = capabilities,
	}
end

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
    	end,
	},
	mapping = {
		['<C-p>'] = cmp.mapping.select_prev_item(),
		['<C-n>'] = cmp.mapping.select_next_item(),
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
    	['<C-f>'] = cmp.mapping.scroll_docs(4),
    	['<C-Space>'] = cmp.mapping.complete(),
   	 	['<C-e>'] = cmp.mapping.close(),
    	['<CR>'] = cmp.mapping.confirm {
     		behavior = cmp.ConfirmBehavior.Replace,
      		select = true,
    	},
    	['<Tab>'] = function(fallback)
    		if cmp.visible() then
        		cmp.select_next_item()
      		else
        		fallback()
      		end
    	end,
    	['<S-Tab>'] = function(fallback)
      		if cmp.visible() then
        		cmp.select_prev_item()
      		else
        		fallback()
      		end
    	end,
  	},
  	sources = {
    	{ name = 'nvim_lsp' },
		{ name = 'vsnip' },
  	},
}

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
EOF
