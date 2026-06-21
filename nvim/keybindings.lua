-- leader
vim.g.maplocalleader = " "
vim.g.mapleader = " "

local keymapOptions = { noremap = true, silent = true }

-- Deferred so telescope is required at keypress time (plugins.lua loads after this file).
local function tb(name)
    return function()
        require("telescope.builtin")[name]()
    end
end

--* =========================== [GENERAL] ==================================

-- Ctrl-s to save (no formatting)
vim.keymap.set("n", "<C-s>", ":w<CR>", keymapOptions)

-- Ctrl-f Ctrl-s ("format and save") -> Prettier (or native fallback) then write
local prettierFiletypes = {
    css = true,
    graphql = true,
    handlebars = true,
    html = true,
    javascript = true,
    javascriptreact = true,
    json = true,
    jsonc = true,
    less = true,
    markdown = true,
    scss = true,
    svelte = true,
    typescript = true,
    typescriptreact = true,
    vue = true,
    yaml = true,
}
local function formatBuffer()
    if prettierFiletypes[vim.bo.filetype] then
        vim.cmd("Prettier")
    else
        vim.notify("Prettier: unsupported file, using native linter instead", vim.log.levels.WARN)
        vim.cmd("normal! gg=G``")
    end
    vim.cmd("normal! zz")
end
local function formatAndSave()
    formatBuffer()
    vim.cmd("write")
end
vim.keymap.set("n", "<C-f><C-s>", formatAndSave, keymapOptions)

-- Ctrl-q to quit
vim.keymap.set("n", "<C-q>", ":q<CR>", keymapOptions)

-- Format the document with native linter
vim.keymap.set("n", "<leader>=", "gg=G``", keymapOptions)

-- Format the document with Prettier (native linter fallback on unsupported filetypes)
vim.keymap.set("n", "<leader>fp", formatBuffer, keymapOptions)

--* ========================== [EXPLORER] ==================================

vim.keymap.set("n", "<leader>ee", ":Neotree toggle<CR>", keymapOptions)

--* ========================= [NAVIGATION] =================================

vim.keymap.set("n", "<leader>ff", tb("find_files"), keymapOptions)
vim.keymap.set("n", "<leader>ft", tb("buffers"), keymapOptions)
vim.keymap.set("n", "<leader>fs", tb("lsp_document_symbols"), keymapOptions)
vim.keymap.set("n", "<leader>fS", tb("lsp_dynamic_workspace_symbols"), keymapOptions)

vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, keymapOptions)
vim.keymap.set("n", "<leader>gD", function()
    vim.cmd("vsplit")
    vim.lsp.buf.definition()
end, keymapOptions)
vim.keymap.set("n", "<leader>gt", vim.lsp.buf.type_definition, keymapOptions)
vim.keymap.set("n", "<leader>gr", tb("lsp_references"), keymapOptions)

vim.keymap.set("n", "<C-i>", "<C-I>", keymapOptions)

--* =========================== [EDITOR] ===================================

vim.keymap.set("n", "K", vim.lsp.buf.hover, keymapOptions)
vim.keymap.set("n", "M", vim.lsp.buf.definition, keymapOptions)
vim.keymap.set("n", "L", vim.lsp.buf.code_action, keymapOptions)

vim.keymap.set("n", "<leader>ec", ":bd<CR>", keymapOptions)
vim.keymap.set("n", "<leader>eC", ":%bd<CR>", keymapOptions)
local function toggle_maximize()
    if vim.t.maximized then
        vim.cmd("wincmd =")
        vim.t.maximized = false
    else
        vim.cmd("wincmd _")
        vim.cmd("wincmd |")
        vim.t.maximized = true
    end
end
vim.keymap.set("n", "<leader>em", toggle_maximize, keymapOptions)

vim.keymap.set("n", "<leader>fw", tb("current_buffer_fuzzy_find"), keymapOptions)
vim.keymap.set("n", "<leader>fW", tb("live_grep"), keymapOptions)
vim.keymap.set("n", "<leader>lg", tb("live_grep"), keymapOptions)
vim.keymap.set("n", "<leader>fr", ":%s/", { noremap = true })

-- move highlighted text
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- cursor stays in place when joining lines
vim.keymap.set("n", "J", "mzJ`z")

-- cursor stays centered while searching / scrolling
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<C-d>", "<C-d>zz", keymapOptions)
vim.keymap.set("n", "<C-u>", "<C-u>zz", keymapOptions)
vim.keymap.set("n", "G", "Gzz", keymapOptions)

-- remove highlights after search
vim.keymap.set("n", "<leader>nh", ":noh<CR>", keymapOptions)
vim.keymap.set("n", "<leader>/", ":noh<CR>", keymapOptions)

-- fold / unfold with <Tab>
vim.keymap.set("n", "<Tab>", "zo", keymapOptions)
vim.keymap.set("n", "<S-Tab>", "zc", keymapOptions)

--* ============================ [BUFFERS / TABS] ==========================

-- buffers
vim.keymap.set("n", "<leader>bb", tb("buffers"), keymapOptions)
vim.keymap.set("n", "<leader>bn", ":bn<CR>", keymapOptions)
vim.keymap.set("n", "<leader>bp", ":bp<CR>", keymapOptions)
vim.keymap.set("n", "<leader>bd", ":bd<CR>", keymapOptions)

-- tabs
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", keymapOptions)
vim.keymap.set("n", "<C-]>", ":tabnext<CR>", keymapOptions)
vim.keymap.set("n", "<C-[>", ":tabprevious<CR>", keymapOptions)
vim.keymap.set("n", "<leader>td", ":tabclose<CR>", keymapOptions)

--* =========================== [SPLITS] ===================================

vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", keymapOptions)
vim.keymap.set("n", "<leader>sh", ":split<CR>", keymapOptions)
vim.keymap.set("n", "<leader>sd", ":q<CR>", keymapOptions)

-- split / window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", keymapOptions)
vim.keymap.set("n", "<C-j>", "<C-w>j", keymapOptions)
vim.keymap.set("n", "<C-k>", "<C-w>k", keymapOptions)
vim.keymap.set("n", "<C-l>", "<C-w>l", keymapOptions)

--* ============================ [GIT] =====================================
-- staging / blame / hunks live in plugins.lua via gitsigns (<leader>h*).
vim.keymap.set("n", "<leader>gb", function()
    require("gitsigns").toggle_current_line_blame()
end, keymapOptions)

--* ========================= [DIAGNOSTICS] ================================
vim.keymap.set("n", "<leader>tp", ":Telescope diagnostics<CR>", keymapOptions)

vim.keymap.set("n", "<leader>dd", ":Telescope diagnostics bufnr=0<CR>", keymapOptions)
vim.keymap.set("n", "<leader>dad", ":Telescope diagnostics<CR>", keymapOptions)
vim.keymap.set("n", "<leader>do", vim.diagnostic.open_float, keymapOptions)
vim.keymap.set("n", "<leader>d]", vim.diagnostic.goto_next, keymapOptions)
vim.keymap.set("n", "<leader>d[", vim.diagnostic.goto_prev, keymapOptions)

--* ====================== [DISABLED KEYBINDINGS] =============================
vim.keymap.set("n", "<C-f>", "<Nop>", keymapOptions)
