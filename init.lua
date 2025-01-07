-- {{{ KEYBINDS

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
vim.keymap.set("n", "<C-e>", ":Neotree toggle<CR>", keymapOptions)

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

-- }}}

-- {{{ SETTINGS 

-- folding
vim.opt.foldmethod = "marker"

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


-- }}}

-- {{{ PLUGINS

-- {{{ Lazy.nvim
-- A modern plugin manager for Neovim
-- https://github.com/folke/lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- }}}

    -- {{{ nvim-treesitter 
    -- Treesitter configurations and abstraction layer for Neovim
    -- https://github.com/nvim-treesitter/nvim-treesitter

    {
        "nvim-treesitter/nvim-treesitter", build = ":TSUpdate",
        config = function()
            require'nvim-treesitter.configs'.setup {
                ensure_installed = { 
                    "lua", 
                    "css", 
                    "scss",
                    "html",
                    "javascript",
                    "typescript",
                    "json",
                },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            }
        end,
    },
    -- }}}

    -- {{{ Autoclose.nvim
    -- A minimalist Neovim plugin that auto pairs & closes brackets
    -- https://github.com/m4xshen/autoclose.nvim

    {
        "m4xshen/autoclose.nvim",
        config = function()
            require("autoclose").setup()
        end,
    },
    -- }}}

    -- {{{ nvim-surround
    -- Surround selections, stylishly
    -- https://github.com/kylechui/nvim-surround

    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})
        end,

        -- The three "core" operations can be done with the keymaps:

        -- add: ys{motion}{char}
        -- delete: ds{char} 
        -- change: cs{target}{replacement}

        -- For the following examples, * will denote the cursor position:

        --           Old text                    Command         New text
        -- --------------------------------------------------------------------------------
        --     surr*ound_words             ysiw)           (surround_words)
        --     *make strings               ys$"            "make strings"
        --     [delete ar*ound me!]        ds]             delete around me!
        --     remove <b>HTML t*ags</b>    dst             remove HTML tags
        --     'change quot*es'            cs'"            "change quotes"
        --     <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
        --     delete(functi*on calls)     dsf             function calls
    },
    -- }}}

    -- {{{ Mason.nvim
    -- Install and manage LSP servers, DAP servers, linters, and formatters
    -- https://github.com/williamboman/mason.nvim

    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    }, 
    -- }}}

    -- {{{ nvim-lspconfig
    -- A collection of LSP configs
    -- https://github.com/neovim/nvim-lspconfig

    {
        "neovim/nvim-lspconfig",
        config = function()
            require'lspconfig'.ts_ls.setup{
                init_options = {
                    hostInfo = "neovim"
                },
                filetypes = {
                    "javascript",
                    "javascriptreact",
                    "javascript.jsx",
                    "typescript",
                    "typescriptreact",
                    "typescript.tsx"
                },
            }
        end
    },
    -- }}}

    -- {{{ mason-lspconfig.nvim
    -- Bridges mason.nvim with the lspconfig plugin
    -- https://github.com/williamboman/mason-lspconfig.nvim

    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "ts_ls",
                    "html",
                    "cssls",
                },
                automatic_installation = true,
                handlers = nil,
            })
        end,
    },
    -- }}}

    -- {{{ telescope.nvim 
    -- A highly extendable fuzzy finder over lists
    -- https://github.com/nvim-telescope/telescope.nvim

    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        -- or                              , branch = '0.1.x',
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup{
                defaults = {
                    search_dirs = {},
                    file_ignore_patterns = {
                        "Library",
                        "node_modules"
                    },
                }
            }
        end,
    },
    -- }}}

    -- {{{ vim-prettier
    -- A vim plugin wrapper for Prettier
    -- https://github.com/prettier/vim-prettier

    {
        "prettier/vim-prettier",
        config = function()
            vim.g["prettier#config#config_precedence"] = "prefer-file"

            vim.g["prettier#config#arrow_parens"] = "always"
            vim.g["prettier#config#bracket_spacing"] = "false"
            vim.g["prettier#config#bracket_same_line"] = "true"
            vim.g["prettier#config#end_of_line"] = "lf"
            vim.g["prettier#config#html_whitespace_sensitivity"] = "css"
            vim.g["prettier#config#jsx_bracket_same_line"] = "true"
            vim.g["prettier#config#jsx_single_quote"] = "false"
            vim.g["prettier#config#print_width"] = "80"
            vim.g["prettier#config#prose_wrap"] = "preserve"
            vim.g["prettier#config#semi"] = "true"
            vim.g["prettier#config#single_attribute_per_line"] = "false"
            vim.g["prettier#config#single_quote"] = "false"
            vim.g["prettier#config#tab_width"] = "4"
            vim.g["prettier#config#trailing_comma"] = "es5"
            vim.g["prettier#config#use_tabs"] = "false"
        end 
    },
    -- }}}

    -- {{{ cspell.nvim
    -- Support for cspell diagnostics and code actions.
    -- https://github.com/davidmh/cspell.nvim

    {
        "davidmh/cspell.nvim",
        dependencies = {
            "nvimtools/none-ls.nvim",
            "nvim-lua/plenary.nvim"
        },
        config = function()
            local cspell = require('cspell')

            require("null-ls").setup {
                sources = {
                    cspell.diagnostics.with({
                        diagnostics_postprocess = function(diagnostic)
                            diagnostic.severity = vim.diagnostic.severity.INFO
                        end
                    }),
                    cspell.code_actions,
                }
            }

            vim.diagnostic.config({
                virtual_text = false,
                underline = {
                    severity = {
                        min = vim.diagnostic.severity.INFO
                    },
                }
            })
        end
    },
    -- }}}

    -- {{{ neo-tree.nvim
    -- Plugin to browse the file system and other tree like structures
    -- https://github.com/nvim-neo-tree/neo-tree.nvim

    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("neo-tree").setup({
                window = {
                    width = 40,
                    mappings = {
                        ["z"] = "close_all_nodes",
                        ["Z"] = "expand_all_nodes",
                        ["s"] = "open_vsplit",
                        ["S"] = "open_split",
                        ["."] = "set_root",
                        ["H"] = "toggle_hidden",
                    },
                },
                filesystem = {
                    filtered_items = {
                        visible = false,
                        hide_dotfiles = true,
                        hide_gitignored = false,
                        hide_hidden = true,
                        hide_by_name = {
                            "undo",
                        },
                        always_show = {
                            ".gitignore",
                            ".env",
                            "node_modules"
                        },
                        always_show_by_pattern = {
                            ".env*"
                        }
                    },
                },
                follow_current_file = {
                    enabled = true,
                    leave_dirs_open = false
                }
            })
        end
    },
    -- }}}

    -- {{{ lualine.nvim
    -- A blazing fast and easy to configure Neovim statusline written in Lua
    -- https://github.com/nvim-lualine/lualine.nvim

    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup {
                options = {
                    icons_enabled = true,
                    theme = 'auto',
                    component_separators = { left = '', right = ''},
                    section_separators = { left = '', right = ''},
                    disabled_filetypes = {
                        statusline = {},
                        winbar = {},
                    },
                    ignore_focus = {},
                    always_divide_middle = true,
                    globalstatus = false,
                    refresh = {
                        statusline = 1000,
                        tabline = 1000,
                        winbar = 1000,
                    }
                },
                sections = {
                    lualine_a = {'mode'},
                    lualine_b = {'branch', 'diff', 'diagnostics'},
                    lualine_c = {'filename'},
                    lualine_x = {'encoding', 'fileformat', 'filetype'},
                    lualine_y = {'progress'},
                    lualine_z = {'location'}
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {'filename'},
                    lualine_x = {'location'},
                    lualine_y = {},
                    lualine_z = {}
                },
                tabline = {},
                winbar = {},
                inactive_winbar = {},
                extensions = {}
            }
        end
    },
    -- }}}

    -- {{{ gitsigns.nvim 
    -- Super fast git decorations implemented purely in Lua.
    -- https://github.com/lewis6991/gitsigns.nvim

    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require('gitsigns').setup {
                signs = {
                    add          = { text = '┃' },
                    change       = { text = '┃' },
                    delete       = { text = '_' },
                    topdelete    = { text = '‾' },
                    changedelete = { text = '~' },
                    untracked    = { text = '┆' },
                },
                signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
                numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
                linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
                word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
                watch_gitdir = {
                    follow_files = true
                },
                auto_attach = true,
                attach_to_untracked = false,
                current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                    delay = 1000,
                    ignore_whitespace = false,
                    virt_text_priority = 100,
                },
                current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
                current_line_blame_formatter_opts = {
                    relative_time = false,
                },
                sign_priority = 6,
                update_debounce = 100,
                status_formatter = nil, -- Use default
                max_file_length = 40000, -- Disable if file is longer than this (in lines)
                preview_config = {
                    -- Options passed to nvim_open_win
                    border = 'single',
                    style = 'minimal',
                    relative = 'cursor',
                    row = 0,
                    col = 1
                },
                on_attach = function(bufnr)
                    local gitsigns = require('gitsigns')

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    -- Navigation
                    map('n', ']c', function()
                        if vim.wo.diff then
                            vim.cmd.normal({']c', bang = true})
                        else
                            gitsigns.nav_hunk('next')
                        end
                    end)

                    map('n', '[c', function()
                        if vim.wo.diff then
                            vim.cmd.normal({'[c', bang = true})
                        else
                            gitsigns.nav_hunk('prev')
                        end
                    end)

                    -- Actions
                    map('n', '<leader>hs', gitsigns.stage_hunk)
                    map('n', '<leader>hr', gitsigns.reset_hunk)
                    map('v', '<leader>hs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
                    map('v', '<leader>hr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
                    map('n', '<leader>hS', gitsigns.stage_buffer)
                    map('n', '<leader>hu', gitsigns.undo_stage_hunk)
                    map('n', '<leader>hR', gitsigns.reset_buffer)
                    map('n', '<leader>hp', gitsigns.preview_hunk)
                    map('n', '<leader>hb', function() gitsigns.blame_line{full=true} end)
                    map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
                    map('n', '<leader>hd', gitsigns.diffthis)
                    map('n', '<leader>hD', function() gitsigns.diffthis('~') end)
                    map('n', '<leader>td', gitsigns.toggle_deleted)

                    -- Text object
                    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
                end
            }
        end
    },
    -- }}}

    -- {{{ Harpoon
    -- Getting you where you want with the fewest keystrokes
    -- https://github.com/ThePrimeagen/harpoon/tree/harpoon2

    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")

            harpoon:setup()

            vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)
            vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

            vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
            vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
            vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
            vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)

            -- Toggle previous & next buffers stored within Harpoon list
            -- vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
            -- vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
        end
    },
    --}}}

    -- {{{ Kanagawa.nvim | colorscheme
    -- NeoVim dark colorscheme inspired by the colors of the famous painting by Katsushika Hokusai.
    -- https://github.com/rebelot/kanagawa.nvim

    {
        "rebelot/kanagawa.nvim",
        config = function()
            require("kanagawa").setup({
                transparent = true,
                terminalColors = true,
                colors = {
                    theme = {
                        all = {
                            ui = {
                                bg_gutter = "none",
                            },
                        },
                    },
                },
            })
            vim.cmd("colorscheme kanagawa-dragon")
        end,
    }
    -- }}}

}, opts)

-- }}}
