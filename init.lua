require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'tpope/vim-fugitive'
    -- need a Clojure plugin fireplace,iced,conjure
    -- might need typescript plugins? also daerean has a load of plugins to look at
    -- TODO actually use the bindings for sexp.. does it have slurp/barf?
    -- use {'guns/vim-sexp', ft = {'clojure'}}
    -- use {'liquidz/vim-iced', ft = {'clojure'}}
    use 'neovim/nvim-lspconfig'
    use {'tpope/vim-fireplace', ft = {'clojure'}}
    use {'mikepjb/vim-fold', ft = {'markdown'}}
    -- use 'norcalli/nvim-colorizer.lua'
    use 'leafgarland/typescript-vim'
    use 'maxmellon/vim-jsx-pretty'
    use 'folke/tokyonight.nvim'
    use 'mikepjb/tailstone.nvim'
    use { 'nvim-treesitter/nvim-treesitter',
        run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
    }
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { {'nvim-lua/plenary.nvim'} }
    }
end)

-- vim.g.colors_name = "tailstone"
-- vim.g.tokyonight_style = "storm"
-- vim.cmd("colorscheme tokyonight")
vim.cmd("colorscheme tailstone")


require('nvim-treesitter.configs').setup({
    ensure_installed = {
        "clojure", "typescript", "c", "html", "css", "go", "html",
        "javascript", "json", "lua", "make", "markdown", "sql", "tsx"
    }
})


-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  -- TODO This gets overwritten by windmove-esque bindings below
  -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  -- vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
-- TODO lsp next/previous?
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}
require('lspconfig')['clojure_lsp'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
}

require('lspconfig')['tsserver'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
}

-- TODO
-- primeagen uses netrw all the time

vim.opt.termguicolors = true
vim.opt.guicursor = ""
vim.opt.mouse = "a"

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.autowrite = true
vim.opt.hidden = true
vim.opt.gdefault = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.errorbells = false
vim.opt.textwidth = 119
vim.opt.scrolloff = 3
vim.opt.errorbells = false
vim.opt.foldenable = false
vim.opt.autoread = false
vim.opt.signcolumn = "number"
vim.opt.fillchars = { stl = "-", stlnc = "-" }
vim.opt.statusline = "-- %1*%F%m%r%h%w%* %= %y [%l,%c] [%L,%p%%]"
vim.opt.clipboard = "unnamed,unnamedplus"
-- hi WinSeparator guibg=None
local undopath = "/tmp/.vim-undo-dir"
if vim.fn.isdirectory(undopath) == 0 then
  vim.fn.mkdir(undopath)
end
vim.opt.undodir = undodir
vim.opt.undofile = true

vim.wo.colorcolumn = "120"
vim.g.mapleader = " "
vim.opt.iskeyword = vim.opt.iskeyword + "-"
vim.g.sh_noisk = 1 -- stop vim messing with iskeyword when opening a shell file
vim.g.ftplugin_sql_omni_key = "<Nop>" -- stop sql filetype stealing <C-c>

vim.keymap.set('n', '<C-q>', ':q<CR>')
vim.keymap.set('n', '<Leader>i', ':e ~/.config/nvim/init.lua<CR>')
vim.keymap.set('n', '<Leader>n', ':e ~/.notes.md<CR>')
vim.keymap.set('n', '<Leader>f', ':Telescope find_files<CR>')
vim.keymap.set('n', '<Leader>b', ':Telescope buffers<CR>')
vim.keymap.set('n', '<Leader>g', ':Telescope grep_string<CR>')
vim.keymap.set('n', '<Leader>c', ':copen<CR>') -- current list
vim.keymap.set('n', '<Leader>e', ':Explore<CR>')
vim.keymap.set('n', '<C-h>', '<C-w><C-h>')
vim.keymap.set('n', '<C-j>', '<C-w><C-j>')
vim.keymap.set('n', '<C-k>', '<C-w><C-k>')
vim.keymap.set('n', '<C-l>', '<C-w><C-l>')
vim.keymap.set('i', '<C-c>', '<esc>')
vim.keymap.set('n', 'Q', '@q')
vim.keymap.set('n', 'gb', ':Git blame<CR>')
vim.keymap.set('c', '<C-b>', '<Left>')
vim.keymap.set('c', '<C-f>', '<Right>')
vim.keymap.set('c', '<C-a>', '<Home>')
vim.keymap.set('c', '<C-e>', '<End>')
vim.keymap.set('c', '<C-d>', '<Delete>')
vim.keymap.set('i', '<C-d>', '<Delete>')
vim.keymap.set('i', '<C-b>', '<Left>')
vim.keymap.set('i', '<C-f>', '<Right>')
vim.keymap.set('i', '<C-a>', '<Home>')
vim.keymap.set('i', '<C-e>', '<End>')
vim.keymap.set('n', '<C-g>', ':noh<CR><C-g>')
vim.keymap.set('i', '<C-c>', '<esc>')
vim.keymap.set('i', '<C-l>', ' => ')

vim.cmd([[command! TrimWhitespace :%s/\s\+$//e]])

function tab()
  local col = vim.fn.col('.') - 1
  if col == 0 then
    return "<Tab>"
  end

  local char = vim.fn.getline('.')[col - 1]
  if char ~= '\\k' then
    return "<C-p>"
  else
    return "<Tab>"
  end
end

vim.keymap.set('i', '<Tab>', tab, { expr = true })
vim.keymap.set('i', '<S-Tab>', '<C-n>')

function runFile()
  local filetype = vim.bo.filetype
  local filename = vim.fn.expand('%:t')
  if filetype == 'clojure' then
    print('clojure time!')
  elseif filename == "init.lua" then
    -- vim.fn.source(vim.fn.expand('%'))
    vim.cmd("so %")
    print('reloading init.lua')
  else
    print('what filetype is this?')
  end
end
function mapRunFile()
  vim.keymap.set('n', '<CR>', ':lua runFile()<CR>')
end
mapRunFile()


local languageGroup = vim.api.nvim_create_augroup("language", { clear = true })
vim.api.nvim_create_autocmd("CmdwinEnter", { command = ":unmap <CR>", group = languageGroup })
vim.api.nvim_create_autocmd("CmdwinLeave", { command = ":lua mapRunFile<CR>", group = languageGroup })
vim.api.nvim_create_autocmd("BufReadPost", {
  command = "nnoremap <buffer> <CR> <CR>",
  pattern = "quickfix",
  group = languageGroup
})


-- needs to use clojure-lsp/clj-kondo

-- https://www.reddit.com/r/neovim/comments/wvv9zm/neovim_rice/
-- Book:
-- aim for 14kb compressed data for the whole website, or at least to render something useful
-- https://endtimes.dev/why-your-website-should-be-under-14kb-in-size/
