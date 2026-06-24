-- folding
vim.opt.foldmethod = "marker"
-- start with all folds open (folds still usable via za/zc etc.)
vim.opt.foldlevelstart = 99

-- Netrw
vim.g.netrw_keepdir = 0
vim.g.netrw_winsize = 30
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_list_hide = [=[\([^/]\|^\.\.\?$\|\.\S\+\/\]]=]

-- cmd line height
vim.opt.cmdheight = 2

-- line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 2
vim.opt.signcolumn = "yes"

-- highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})

-- sync clipboard between OS and NeoVim
vim.opt.clipboard = "unnamedplus"

-- tabs to spaces
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")

-- indentation
vim.opt.autoindent = true

-- split windows
vim.opt.splitbelow = true
vim.opt.splitright = true

-- scroll margins
vim.opt.scrolloff = 5

-- pop up menu (such as completion) height in lines
vim.opt.pumheight = 10

-- highlight on search
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- mouse mode
vim.opt.mouse = "a"

-- width
vim.opt.colorcolumn = "80"

-- pop up menu (such as completion) height in lines
vim.opt.pumheight = 10

-- undo history
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("config") .. "/undo"

-- completions
vim.opt.completeopt = "menu,menuone,noselect,noinsert"

-- case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- no wrap
vim.o.wrap = false

vim.opt.termguicolors = true

-- set normal highlight group background to none
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none', ctermbg = 'none' })

-- set nonText highlight group background to none
vim.api.nvim_set_hl(0, 'NonText', { bg = 'none', ctermbg = 'none' })

