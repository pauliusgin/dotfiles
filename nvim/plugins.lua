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
                    "go",
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
            vim.lsp.config("ts_ls", {
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
            })
            vim.lsp.enable("ts_ls")

            vim.lsp.enable("gopls")
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
                    "gopls",
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
                    position = "right",
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
                },
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
                    component_separators = { left = '', right = ''},
                    section_separators = { left = '', right = ''},
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
                    lualine_b = {'branch'},
                    lualine_c = {'filename'},
                    lualine_x = {'fileformat'},
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

    -- {{{ supermaven-nvim
    -- AI code completion with inline suggestions (free tier)
    -- https://github.com/supermaven-inc/supermaven-nvim

    {
        "supermaven-inc/supermaven-nvim",
        config = function()
            require("supermaven-nvim").setup({
                keymaps = {
                    accept_suggestion = "<Tab>",
                    clear_suggestion = "<C-h>",
                    accept_word = "<C-l>",
                },
                ignore_filetypes = {},
                color = {
                    suggestion_color = "#808080",
                    cterm = 244,
                },
                log_level = "info",
                disable_inline_completion = false,
                disable_keymaps = false,
            })
        end,
    },
    -- }}}

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
