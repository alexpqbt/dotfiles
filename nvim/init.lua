-- plugins
vim.pack.add{
 	{ src = 'https://github.com/neovim/nvim-lspconfig' },
 	{ src = 'https://github.com/mason-org/mason.nvim' },
   	{ src = 'https://github.com/stevearc/oil.nvim' },
	{ src = 'https://github.com/vague-theme/vague.nvim' },
 	{ src = 'https://github.com/nvim-mini/mini.align' },
}


require("mason").setup({
	ui = {
		border = 'solid',
	}
})

require("oil").setup({
	default_file_explorer = true,
})

require("mini.align").setup()

-- init
vim.opt.shiftwidth    = 4
vim.opt.tabstop       = 4
vim.opt.softtabstop   = 4
vim.opt.expandtab     = false
vim.opt.autoindent    = true
vim.opt.smartindent   = true

vim.opt.hidden        = true
vim.opt.title         = true

vim.opt.rnu           = true

vim.opt.incsearch     = true
vim.opt.hlsearch      = false

vim.opt.ignorecase    = true

vim.opt.clipboard     = "unnamedplus"

vim.opt.signcolumn    = "yes"

vim.opt.wrap          = true
vim.opt.linebreak     = true
vim.opt.breakindent   = true

vim.opt.cursorline    = true
vim.opt.scrolloff     = 10
vim.opt.sidescrolloff = 8

vim.opt.termguicolors = true

vim.opt.showmatch     = true
vim.opt.matchtime     = 2


vim.opt.iskeyword:remove("_")


-- netrw
vim.g.netrw_banner    = 0
vim.g.netrw_liststyle = 0

-- color
vim.cmd.colorscheme('vague')

require('vague').setup({
	transparent = true,
})

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })


-- keymap
vim.g.mapleader      = ' '
vim.g.maplocalleader = ' '

vim.keymap.set('n', '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', '-', '<Cmd>Oil<CR>', { silent = true })
vim.keymap.set('n', '<Leader>e', '<Cmd>split | Oil<CR>', { silent = true })
vim.keymap.set('n', '<Leader>q', ':q<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>w', ':w<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>r', ':!', { noremap = true, silent = true })

vim.keymap.set('x', '<Leader>p', '"_dP')

vim.keymap.set({ 'n', 'v' }, '<Leader>d', '"_d')

vim.keymap.set('n', '<Leader>bn', ':bnext<CR>')
vim.keymap.set('n', '<Leader>bp', ':bprevious<CR>')

vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

vim.keymap.set('n', '<A-j>', ':m .+1<CR>==')
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==')
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv")

vim.keymap.set('n', 'J', 'mzJ`z')

vim.keymap.set('n', '<F5>', ':make run<CR>:copen 10<CR>', { noremap = true, silent = true })

vim.keymap.set('t', '<Leader><Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })

vim.keymap.set("i", "<c-space>", function() vim.lsp.completion.get() end)
vim.opt.completeopt = { "menu", "menuone", "noselect", "popup" }


-- commands
vim.api.nvim_create_user_command('CloseHiddenBuffers', function()
  local visible_buffers = {}
  -- Get all buffers currently visible in all windows
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    visible_buffers[vim.api.nvim_win_get_buf(win)] = true
  end

  local deleted_count = 0
  -- Iterate through all loaded buffers
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and not visible_buffers[buf] then
      -- Use pcall to ignore buffers that fail to delete (like unsaved changes)
      local success = pcall(vim.cmd, 'bd ' .. buf)
      if success then
        deleted_count = deleted_count + 1
      end
    end
  end
  print("Deleted " .. deleted_count .. " hidden buffers.")
end, {})


vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})


-- lsp
vim.lsp.enable("emmylua_ls")

local clangd_opts = {
	capabillities = {
		offsetEncoding = { "utf-8", "utf-16" },
		textDocument = {
		  completion = {
			editsNearCursor = true
		  }
		}
	}
}
if not vim.lsp.is_enabled('clangd') then
	vim.lsp.enable("clangd", clangd_opts)
end

