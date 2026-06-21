-- leader
vim.g.maplocalleader = " "
vim.g.mapleader = " "

local keymapOptions = { noremap = true, silent = true }

-- Ctrl-s to save
vim.keymap.set("n", "<C-s>", ":w<CR>", keymapOptions)

-- Format the document with native linter
vim.keymap.set("n", "<leader>=", "gg=G``", keymapOptions)

-- Format the document with Prettier
vim.keymap.set("n", "<Leader>p", ":PrettierAsync<CR>", keymapOptions)

-- Ctrl-q to quit
vim.keymap.set("n", "<C-q>", ":q<CR>", keymapOptions)

-- neo-tree
vim.keymap.set("n", "<Leader>ee", ":Neotree toggle<CR>", keymapOptions)

-- buffers
vim.keymap.set("n", "<leader>bb", ":Telescope buffers<CR>", keymapOptions)
vim.keymap.set("n", "<leader>bn", ":bn<CR>", keymapOptions)
vim.keymap.set("n", "<leader>bp", ":bp<CR>", keymapOptions)
vim.keymap.set("n", "<leader>bd", ":bd<CR>", keymapOptions)

-- tabs
vim.keymap.set("n", "<leader>tN", ":tabnew<CR>", keymapOptions)
vim.keymap.set("n", "<leader>tn", ":tabnext<CR>", keymapOptions)
vim.keymap.set("n", "<leader>tp", ":tabprevious<CR>", keymapOptions)
vim.keymap.set("n", "<leader>td", ":tabclose<CR>", keymapOptions)

-- split window
vim.keymap.set("n", "<leader>ws", ":split<CR>", keymapOptions)
vim.keymap.set("n", "<leader>wv", ":vsplit<CR>", keymapOptions)

-- split window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", keymapOptions)
vim.keymap.set("n", "<C-j>", "<C-w>j", keymapOptions)
vim.keymap.set("n", "<C-k>", "<C-w>k", keymapOptions)
vim.keymap.set("n", "<C-l>", "<C-w>l", keymapOptions)

--move highlighted text
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- cursor stays in place when joining lines
vim.keymap.set("n", "J", "mzJ`z")

-- cursor stays in place while searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<C-d>", "<C-d>zz", keymapOptions)
vim.keymap.set("n", "<C-u>", "<C-u>zz", keymapOptions)
vim.keymap.set("n", "G", "Gzz", keymapOptions)

-- remove highlights after search
vim.keymap.set("n", "<leader>nh", ":noh<CR>", keymapOptions)

-- fold / unfold wit <Tab>
vim.keymap.set("n", "<Tab>", "zo", keymapOptions)
vim.keymap.set("n", "<S-Tab>", "zc", keymapOptions)

-- telescope keymaps
vim.keymap.set("n", "<leader>ff", ":lua require('telescope.builtin').find_files()<CR>", keymapOptions)
vim.keymap.set("n", "<leader>lg", ":lua require('telescope.builtin').live_grep()<CR>", keymapOptions)

-- lsp keymaps
vim.keymap.set("n", "K", ":lua vim.lsp.buf.hover()<CR>", keymapOptions)
vim.keymap.set("n", "M", ":lua vim.lsp.buf.definition()<CR>", keymapOptions)
vim.keymap.set("n", "L", ":lua vim.lsp.buf.code_action()<CR>", keymapOptions)

-- diagnostics
vim.keymap.set("n", "<leader>dd", ":Telescope diagnostics bufnr=0<CR>", keymapOptions)
vim.keymap.set("n", "<leader>dad", ":Telescope diagnostics<CR>", keymapOptions)
vim.keymap.set("n", "<leader>do", ":lua vim.diagnostic.open_float()<CR>", keymapOptions)
vim.keymap.set("n", "<leader>d]", ":lua vim.diagnostic.goto_next()<CR>", keymapOptions)
vim.keymap.set("n", "<leader>d[", ":lua vim.diagnostic.goto_prev()<CR>", keymapOptions)

-- jump forward in history
vim.keymap.set("n", "<C-i>", "<C-I>", keymapOptions)

-- remove highlights
vim.keymap.set("n", "<leader>/", ":noh<CR>", keymapOptions)
