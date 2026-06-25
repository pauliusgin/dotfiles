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
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        main = "nvim-treesitter",
        event = { "BufReadPost", "BufNewFile" },
        init = function()
            local highlight = function(bufnr, lang)
                -------------------[ treesitter highlights ]-------------------------------
                if not vim.treesitter.language.add(lang) then
                    return vim.notify(
                        string.format("Treesitter cannot load parser for language: %s", lang),
                        vim.log.levels.INFO,
                        { title = "Treesitter" }
                    )
                end
                vim.treesitter.start(bufnr)
            end

            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    local ft = vim.bo.filetype
                    local bt = vim.bo.buftype
                    local buf = args.buf

                    if bt ~= "" then
                        return
                    end -- don't run further.

                    local ok, treesitter = pcall(require, "nvim-treesitter")
                    if not ok then
                        return
                    end

                    --------------------[ treesitter folds ]-------------------------------

                    if ft == "javascriptreact" or ft == "typescriptreact" then
                        vim.opt_local.foldmethod = "indent"
                    else
                        vim.opt_local.foldmethod = "expr"
                        vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                    end

                    vim.schedule(function()
                        -- Only run normal if we're not in terminal mode
                        if vim.fn.mode() ~= "t" then
                            vim.cmd "silent! normal! zx"
                        end
                    end)

                    ---------------------[ treesitter indent ]-------------------------------

                    if not vim.tbl_contains({ "python", "html", "yaml", "markdown" }, ft) then
                        vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
                    end

                    --------------------[ treesitter parsers ]-------------------------------
                    if vim.fn.executable "tree-sitter" ~= 1 then
                        vim.api.nvim_echo({
                            {
                                "tree-sitter CLI not found. Parsers cannot be installed.",
                                "ErrorMsg",
                            },
                        }, true, {})
                        return false
                    end

                    if not vim.treesitter.language.get_lang(ft) then
                        return
                    end

                    if vim.list_contains(treesitter.get_installed(), ft) then
                        highlight(buf, ft)
                    elseif vim.list_contains(treesitter.get_available(), ft) then
                        treesitter.install(ft):await(function()
                            highlight(buf, ft)
                        end)
                    end
                end,
            })
        end,
        opts = {
            install = {
                "lua",
                "css",
                "scss",
                "html",
                "javascript",
                "typescript",
                "tsx",
                "json",
                "go",
            },
        },
        config = function(_, opts)
            local treesitter = require "nvim-treesitter"
            treesitter.setup(opts)
            if vim.fn.executable "tree-sitter" ~= 1 then
                vim.api.nvim_echo({
                    {
                        "tree-sitter CLI not found. Parsers cannot be installed.",
                        "ErrorMsg",
                    },
                }, true, {})
                return false
            end
            treesitter.install(opts.install)
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
        tag = "0.1.8",
        -- or                              , branch = '0.1.x',
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        config = function()
            local actions = require("telescope.actions")

            -- nvim-treesitter `main` branch dropped the legacy API that
            -- telescope 0.1.8 previewers depend on (parsers.ft_to_lang and the
            -- whole nvim-treesitter.configs module: is_enabled/get_module).
            -- 1) Shim ft_to_lang (still used by telescope.builtin.__files).
            local parsersOk, parsers = pcall(require, "nvim-treesitter.parsers")
            if parsersOk and type(parsers.ft_to_lang) ~= "function" then
                parsers.ft_to_lang = function(ft)
                    return vim.treesitter.language.get_lang(ft) or ft
                end
            end
            -- 2) Replace the preview TS highlighter with the native API, which
            -- avoids nvim-treesitter.configs entirely.
            local previewerUtils = require("telescope.previewers.utils")
            previewerUtils.ts_highlighter = function(bufnr, ft)
                local lang = vim.treesitter.language.get_lang(ft) or ft
                return pcall(vim.treesitter.start, bufnr, lang)
            end

            require("telescope").setup{
                defaults = {
                    search_dirs = {},
                    file_ignore_patterns = {
                        "Library",
                        "node_modules"
                    },
                    mappings = {
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                        },
                        n = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                        },
                    },
                },
                pickers = {
                    find_files = {
                        -- 50% of telescope's default height (0.9)
                        layout_config = {
                            height = 0.45,
                        },
                    },
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                },
            }

            require("telescope").load_extension("fzf")
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
                        ["l"] = function(state)
                            local node = state.tree:get_node()
                            -- filesystem source's open wraps the toggle_directory loader (same as <CR>)
                            local commands = require("neo-tree.sources.filesystem.commands")
                            if node.type == "directory" then
                                -- loads + expands if closed, collapses if open
                                commands.open(state)
                                return
                            end
                            -- open file but keep focus on the neo-tree window
                            local neotree_win = vim.api.nvim_get_current_win()
                            commands.open(state)
                            vim.api.nvim_set_current_win(neotree_win)
                        end,
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
                    follow_current_file = {
                        enabled = true,
                        leave_dirs_open = false
                    },
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
            local function supermaven_status()
                local ok, listener = pcall(require, "supermaven-nvim.completion_preview")
                if not ok then
                    return ""
                end
                local api_ok, api = pcall(require, "supermaven-nvim.api")
                if api_ok and not api.is_running() then
                    return "supermaven  off"
                end
                return "supermaven  on"
            end

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
                    globalstatus = true,
                    refresh = {
                        statusline = 1000,
                        tabline = 1000,
                        winbar = 1000,
                    }
                },
                sections = {
                    lualine_a = {'mode'},
                    lualine_b = {'branch'},
                    lualine_c = {},
                    lualine_x = {'location'},
                    lualine_y = {
                        { 'filetype', icons_enabled = false },
                    },
                    lualine_z = {supermaven_status}
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
                    delay = 0,
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

    -- {{{ codediff.nvim
    -- Fast, VSCode-like diff viewer for git changes, history, and merges
    -- https://github.com/esmuellert/codediff.nvim

    {
        "esmuellert/codediff.nvim",
        cmd = "CodeDiff",
        config = function()
            require("codediff").setup({
                diff = {
                    layout = "side-by-side",
                },
                explorer = {
                    position = "right",
                    width = 40,
                    height = 100
                },
                history = {
                    position = "right",
                    width = 40,
                    height = 100
                },
                keymaps = {
                    view = {
                        quit = "q",                    -- Close diff tab
                        toggle_explorer = "<leader>ge",  -- Toggle explorer visibility (explorer mode only)
                        focus_explorer = false,   -- Focus explorer panel (explorer mode only)
                        next_hunk = "]c",   -- Jump to next change
                        prev_hunk = "[c",   -- Jump to previous change
                        next_file = "]f",   -- Next file in explorer/history mode
                        prev_file = "[f",   -- Previous file in explorer/history mode
                        diff_get = false,    -- Get change from other buffer (like vimdiff)
                        diff_put = false,    -- Put change to other buffer (like vimdiff)
                        open_in_prev_tab = false, -- Open current buffer in previous tab (or create one before)
                        close_on_open_in_prev_tab = false, -- Close codediff tab after gf opens file in previous tab
                        toggle_stage = "-", -- Stage/unstage current file (works in explorer and diff buffers)
                        stage_hunk = "<leader>ga",   -- Stage hunk under cursor to git index
                        unstage_hunk = "<leader>gr", -- Unstage hunk under cursor from git index
                        discard_hunk = "<leader>hr", -- Discard hunk under cursor (working tree only)
                        hunk_textobject = "ih",      -- Textobject for hunk (vih to select, yih to yank, etc.)
                        show_help = "g?",   -- Show floating window with available keymaps
                        align_move = "gm", -- Temporarily align moved code blocks across panes
                        toggle_layout = "t", -- Toggle between side-by-side and inline layout
                        toggle_compact = "gc", -- Toggle compact mode (fold unchanged regions)
                    },
                    explorer = {
                        select = "<CR>",    -- Open diff for selected file
                        hover = "K",        -- Show file diff preview
                        refresh = "R",      -- Refresh git status
                        toggle_view_mode = "i",  -- Toggle between 'list' and 'tree' views
                        stage_all = "S",    -- Stage all files
                        unstage_all = "U",  -- Unstage all files
                        restore = "X",      -- Discard changes (restore file)
                        toggle_changes = "gu",  -- Toggle Changes (unstaged) group visibility
                        toggle_staged = "gs",   -- Toggle Staged Changes group visibility
                        -- Fold keymaps (Vim-style)
                        fold_open = "zo",           -- Open fold (expand current node)
                        fold_open_recursive = "zO", -- Open fold recursively (expand all descendants)
                        fold_close = "zc",          -- Close fold (collapse current node)
                        fold_close_recursive = "zC", -- Close fold recursively (collapse all descendants)
                        fold_toggle = "za",         -- Toggle fold (expand/collapse current node)
                        fold_toggle_recursive = "zA", -- Toggle fold recursively
                        fold_open_all = "zR",       -- Open all folds in tree
                        fold_close_all = "zM",      -- Close all folds in tree
                    },
                    history = {
                        select = "<CR>",    -- Select commit/file or toggle expand
                        toggle_view_mode = "i",  -- Toggle between 'list' and 'tree' views
                        refresh = "R",      -- Refresh history (re-fetch commits)
                        -- Fold keymaps (Vim-style, apply to directory nodes only)
                        fold_open = "zo",           -- Open fold (expand current node)
                        fold_open_recursive = "zO", -- Open fold recursively (expand all descendants)
                        fold_close = "zc",          -- Close fold (collapse current node)
                        fold_close_recursive = "zC", -- Close fold recursively (collapse all descendants)
                        fold_toggle = "za",         -- Toggle fold (expand/collapse current node)
                        fold_toggle_recursive = "zA", -- Toggle fold recursively
                        fold_open_all = "zR",       -- Open all folds in tree
                        fold_close_all = "zM",      -- Close all folds in tree
                    },
                    conflict = {
                        accept_incoming = "<leader>ct",  -- Accept incoming (theirs/left) change
                        accept_current = "<leader>co",   -- Accept current (ours/right) change
                        accept_both = "<leader>cb",      -- Accept both changes (incoming first)
                        discard = "<leader>cx",          -- Discard both, keep base
                        -- Accept all (whole file) - uppercase versions
                        accept_all_incoming = "<leader>cT",  -- Accept ALL incoming changes
                        accept_all_current = "<leader>cO",   -- Accept ALL current changes
                        accept_all_both = "<leader>cB",      -- Accept ALL both changes
                        discard_all = "<leader>cX",          -- Discard ALL, reset to base
                        next_conflict = "]x",            -- Jump to next conflict
                        prev_conflict = "[x",            -- Jump to previous conflict
                        diffget_incoming = "2do",        -- Get hunk from incoming (left/theirs) buffer
                        diffget_current = "3do",         -- Get hunk from current (right/ours) buffer
                    },
                }
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
            vim.cmd("colorscheme minimal-fedu")
        end,
    }
    -- }}}

}, opts)

-- vim: foldmethod=marker:foldlevel=0
