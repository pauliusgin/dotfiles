-- minimal-fedu — custom colorscheme
-- Ported from the personal VSCode theme: cool blues + amber/gold accents
-- on a near-black background. Mapped legacy syntax + Treesitter (@*) +
-- LSP semantic tokens + diagnostics + common plugin groups.
-- Load with :colorscheme minimal-fedu

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
end

vim.o.background = "dark"
vim.g.colors_name = "minimal-fedu"

-- Set to true to let the terminal background show through (transparent bg).
local transparent = true

local palette = {
    bg = "#1f1f1f",
    bg_float = "#1a1a1a",
    bg_high = "#293134", -- cursorline / line highlight
    bg_sel = "#3e5469", -- visual selection
    bg_menu = "#2d3337",

    fg = "#fafafa",
    fg_dim = "#bdbdc5",
    fg_mut = "#9da9b1",
    gray = "#5d6971", -- legacy comments / muted ui
    gray_punct = "#616161", -- faint punctuation/brackets
    linenr = "#6e6e6e",
    linenr_active = "#f0f0f0",

    blue = "#678cb1", -- storage, delimiters, constants
    lblue = "#97ccf1", -- keywords, tags, operators(logical)
    cyan = "#87bcd1", -- constant.language
    amber = "#fcb650", -- numbers
    gold = "#e7a74d", -- functions / types (ts), accent
    orange = "#ff8f2e", -- import / namespace / new
    salmon = "#ce9178", -- strings (ts)
    green = "#6a9955", -- comments (ts/js)
    property = "#bbbbbb", -- property access
    e0 = "#e0e2e4", -- params / generic identifiers
    steel = "#9daab2", -- object refs (Foo in Foo.bar)

    error = "#e15a60",
    warn = "#cca700",
    info = "#59a4f9",
    hint = "#6796e6",

    git_add = "#a7da1e",
    git_change = "#f7b83d",
    git_delete = "#e15a60",
    git_add_bg = "#487e02",
    git_change_bg = "#1b81a8",
}

local p = palette
local bg = transparent and "NONE" or p.bg
local bg_float = transparent and "NONE" or p.bg_float

local function hi(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

local groups = {
    -- ── Editor UI ─────────────────────────────────────────────
    Normal = { fg = p.fg, bg = bg },
    NormalNC = { fg = p.fg, bg = bg },
    NormalFloat = { fg = p.fg_mut, bg = bg_float },
    FloatBorder = { fg = p.gray, bg = bg_float },
    FloatTitle = { fg = p.gold, bg = bg_float, bold = true },
    ColorColumn = { bg = p.bg_high },
    Cursor = { fg = p.bg, bg = p.fg },
    CursorLine = { bg = p.bg_high },
    CursorColumn = { bg = p.bg_high },
    CursorLineNr = { fg = p.linenr_active, bold = true },
    LineNr = { fg = p.linenr },
    SignColumn = { bg = bg },
    Folded = { fg = p.fg_mut, bg = p.bg_high },
    FoldColumn = { fg = p.gray, bg = bg },
    VertSplit = { fg = "#292929" },
    WinSeparator = { fg = "#292929" },
    Visual = { bg = p.bg_sel },
    VisualNOS = { bg = p.bg_sel },
    Search = { fg = p.bg, bg = p.amber },
    IncSearch = { fg = p.bg, bg = p.gold },
    CurSearch = { fg = p.bg, bg = p.gold },
    MatchParen = { fg = p.gold, bold = true, underline = true },
    NonText = { fg = "#3a3a3a" },
    Whitespace = { fg = "#3a3a3a" },
    SpecialKey = { fg = "#3a3a3a" },
    EndOfBuffer = { fg = bg == "NONE" and p.bg or bg },
    Directory = { fg = p.blue },
    Title = { fg = p.gold, bold = true },
    ErrorMsg = { fg = p.error },
    WarningMsg = { fg = p.warn },
    ModeMsg = { fg = p.fg_mut },
    MoreMsg = { fg = p.blue },
    Question = { fg = p.blue },
    Conceal = { fg = p.gray },

    -- ── Statusline / tabs ─────────────────────────────────────
    StatusLine = { fg = p.fg_mut, bg = p.bg_float },
    StatusLineNC = { fg = p.gray, bg = p.bg_float },
    TabLine = { fg = "#909099", bg = p.bg_float },
    TabLineSel = { fg = p.fg, bg = bg },
    TabLineFill = { bg = p.bg_float },
    WinBar = { fg = p.fg_mut, bg = bg },
    WinBarNC = { fg = p.gray, bg = bg },

    -- ── Popup menu ────────────────────────────────────────────
    Pmenu = { fg = p.fg_mut, bg = p.bg_float },
    PmenuSel = { fg = p.gold, bg = "#3a3a3a" },
    PmenuSbar = { bg = p.bg_float },
    PmenuThumb = { bg = "#3a3a3a" },
    WildMenu = { fg = p.gold, bg = "#3a3a3a" },

    -- ── Diff ──────────────────────────────────────────────────
    DiffAdd = { bg = "#1e3a1e" },
    DiffChange = { bg = "#1e2a3a" },
    DiffDelete = { fg = p.git_delete, bg = "#3a1e1e" },
    DiffText = { bg = "#2e4a6a" },

    -- ── Legacy syntax ─────────────────────────────────────────
    Comment = { fg = p.green, italic = true },
    Constant = { fg = p.blue },
    String = { fg = p.salmon },
    Character = { fg = p.salmon },
    Number = { fg = p.amber },
    Boolean = { fg = p.cyan },
    Float = { fg = p.amber },
    Identifier = { fg = p.fg },
    Function = { fg = p.gold },
    Statement = { fg = p.lblue },
    Conditional = { fg = p.fg }, -- ts control flow = white
    Repeat = { fg = p.fg },
    Label = { fg = p.lblue },
    Operator = { fg = p.fg },
    Keyword = { fg = p.lblue },
    Exception = { fg = p.fg },
    PreProc = { fg = p.orange },
    Include = { fg = p.orange },
    Define = { fg = p.orange },
    Macro = { fg = p.orange },
    PreCondit = { fg = p.orange },
    Type = { fg = p.fg },
    StorageClass = { fg = p.blue },
    Structure = { fg = p.blue },
    Typedef = { fg = p.fg },
    Special = { fg = p.blue },
    SpecialChar = { fg = p.blue },
    Tag = { fg = p.lblue },
    Delimiter = { fg = p.fg },
    SpecialComment = { fg = p.gray },
    Debug = { fg = p.orange },
    Underlined = { fg = p.info, underline = true },
    Error = { fg = p.error },
    Todo = { fg = p.bg, bg = p.gold, bold = true },

    -- ── Treesitter ────────────────────────────────────────────
    ["@comment"] = { link = "Comment" },
    ["@comment.error"] = { fg = p.error },
    ["@comment.warning"] = { fg = p.warn },
    ["@comment.todo"] = { link = "Todo" },
    ["@comment.note"] = { fg = p.info },

    ["@string"] = { fg = p.salmon },
    ["@string.documentation"] = { fg = p.green },
    ["@string.regexp"] = { fg = p.amber },
    ["@string.escape"] = { fg = p.blue },
    ["@string.special"] = { fg = p.blue },
    ["@character"] = { fg = p.salmon },
    ["@number"] = { fg = p.amber },
    ["@number.float"] = { fg = p.amber },
    ["@boolean"] = { fg = p.cyan },

    ["@constant"] = { fg = p.e0 },
    ["@constant.builtin"] = { fg = p.cyan },
    ["@constant.macro"] = { fg = p.orange },

    ["@variable"] = { fg = p.fg },
    ["@variable.object"] = { fg = p.steel }, -- `Foo` in `Foo.bar` (TextMate variable.other.object)
    ["@variable.builtin"] = { fg = "#dddddd", bold = true }, -- this/self
    ["@variable.parameter"] = { fg = p.fg },
    ["@variable.member"] = { fg = p.fg }, -- obj.property

    ["@property"] = { fg = p.fg },
    ["@field"] = { fg = p.fg },

    ["@function"] = { fg = p.gold },
    ["@function.builtin"] = { fg = p.gold },
    ["@function.call"] = { fg = p.gold },
    ["@function.method"] = { fg = p.gold },
    ["@function.method.call"] = { fg = p.gold },
    ["@constructor"] = { fg = p.gold },

    ["@keyword"] = { fg = p.lblue },
    ["@keyword.function"] = { fg = p.blue },
    ["@keyword.operator"] = { fg = p.lblue },
    ["@keyword.return"] = { fg = p.fg }, -- ts return = white
    ["@keyword.conditional"] = { fg = p.fg }, -- if/else = white
    ["@keyword.repeat"] = { fg = p.fg },
    ["@keyword.exception"] = { fg = p.fg },
    ["@keyword.coroutine"] = { fg = p.fg }, -- async/await = white
    ["@keyword.import"] = { fg = p.cyan }, -- import/export/from
    ["@keyword.storage"] = { fg = p.blue }, -- const/let/var
    ["@keyword.modifier"] = { fg = p.blue }, -- private/readonly/public (storage.modifier)

    ["@type"] = { fg = p.fg },
    ["@type.builtin"] = { fg = p.fg_mut },
    ["@type.definition"] = { fg = p.fg },
    ["@attribute"] = { fg = p.e0 },

    ["@operator"] = { fg = p.fg },
    ["@punctuation.delimiter"] = { fg = p.fg },
    ["@punctuation.bracket"] = { fg = p.fg },
    ["@punctuation.special"] = { fg = p.lblue },

    ["@tag"] = { fg = p.lblue },
    ["@tag.builtin"] = { fg = p.lblue },
    ["@tag.attribute"] = { fg = p.e0 },
    ["@tag.delimiter"] = { fg = p.gray_punct },

    ["@module"] = { fg = p.fg_mut },
    ["@namespace"] = { fg = p.orange },
    ["@label"] = { fg = p.lblue },

    -- Markdown
    ["@markup.heading"] = { fg = p.info, bold = true },
    ["@markup.raw"] = { fg = "#00a8c6" },
    ["@markup.link"] = { fg = p.orange, italic = true },
    ["@markup.link.url"] = { fg = "#b8a07d" },
    ["@markup.list"] = { fg = p.info },
    ["@markup.strong"] = { fg = p.fg, bold = true },
    ["@markup.italic"] = { fg = p.fg, italic = true },

    -- ── LSP semantic tokens ───────────────────────────────────
    ["@lsp.type.class"] = { fg = p.fg },
    ["@lsp.type.interface"] = { fg = p.fg },
    ["@lsp.type.enum"] = { fg = p.fg },
    ["@lsp.type.type"] = { fg = p.fg },
    ["@lsp.type.namespace"] = { fg = p.fg_mut },
    ["@lsp.type.parameter"] = { fg = p.fg },
    ["@lsp.type.property"] = { fg = p.fg },
    ["@lsp.type.variable"] = { fg = p.fg },
    ["@lsp.type.function"] = { fg = p.gold },
    ["@lsp.type.method"] = { fg = p.gold },
    ["@lsp.type.keyword"] = { fg = p.lblue },
    ["@lsp.type.string"] = { fg = p.salmon },
    ["@lsp.type.number"] = { fg = p.amber },
    ["@lsp.type.enumMember"] = { fg = p.cyan },

    -- ── Diagnostics ───────────────────────────────────────────
    DiagnosticError = { fg = p.error },
    DiagnosticWarn = { fg = p.warn },
    DiagnosticInfo = { fg = p.info },
    DiagnosticHint = { fg = p.hint },
    DiagnosticUnderlineError = { undercurl = true, sp = p.error },
    DiagnosticUnderlineWarn = { undercurl = true, sp = p.warn },
    DiagnosticUnderlineInfo = { undercurl = true, sp = p.info },
    DiagnosticUnderlineHint = { undercurl = true, sp = p.hint },
    DiagnosticVirtualTextError = { fg = p.error, bg = "NONE" },
    DiagnosticVirtualTextWarn = { fg = p.warn, bg = "NONE" },
    DiagnosticVirtualTextInfo = { fg = p.info, bg = "NONE" },
    DiagnosticVirtualTextHint = { fg = p.hint, bg = "NONE" },

    -- ── Git / Gitsigns ────────────────────────────────────────
    GitSignsAdd = { fg = p.git_add_bg },
    GitSignsChange = { fg = p.git_change_bg },
    GitSignsDelete = { fg = p.git_delete },
    diffAdded = { fg = p.git_add },
    diffRemoved = { fg = p.git_delete },
    diffChanged = { fg = p.git_change },

    -- ── Neo-tree ──────────────────────────────────────────────
    NeoTreeNormal = { fg = p.fg_dim, bg = bg_float },
    NeoTreeNormalNC = { fg = p.fg_dim, bg = bg_float },
    NeoTreeDirectoryName = { fg = p.fg_dim },
    NeoTreeDirectoryIcon = { fg = p.blue },
    NeoTreeRootName = { fg = p.gold, bold = true },
    NeoTreeFileName = { fg = p.fg_dim },
    NeoTreeGitModified = { fg = p.git_change },
    NeoTreeGitAdded = { fg = p.git_add },
    NeoTreeGitDeleted = { fg = p.git_delete },
    NeoTreeIndentMarker = { fg = "#585858" },

    -- ── Telescope ─────────────────────────────────────────────
    TelescopeNormal = { fg = p.fg_mut, bg = bg_float },
    TelescopeBorder = { fg = p.gray, bg = bg_float },
    TelescopeSelection = { fg = p.gold, bg = p.bg_high },
    TelescopeMatching = { fg = p.amber, bold = true },
    TelescopePromptPrefix = { fg = p.gold },

    -- ── Misc plugins ──────────────────────────────────────────
    WhichKey = { fg = p.gold },
    WhichKeyGroup = { fg = p.blue },
    WhichKeyDesc = { fg = p.fg_mut },
    IndentBlanklineChar = { fg = "#2a2a2a" },
    IblIndent = { fg = "#2a2a2a" },
}

for group, opts in pairs(groups) do
    hi(group, opts)
end

-- ── Terminal ANSI colors (from the VSCode theme) ─────────────
vim.g.terminal_color_0 = "#000000"
vim.g.terminal_color_1 = p.error
vim.g.terminal_color_2 = "#5ae07c"
vim.g.terminal_color_3 = p.amber
vim.g.terminal_color_4 = p.blue
vim.g.terminal_color_5 = "#af67b1"
vim.g.terminal_color_6 = "#67b1b1"
vim.g.terminal_color_7 = "#e5e5e5"
vim.g.terminal_color_8 = "#666666"
vim.g.terminal_color_9 = p.error
vim.g.terminal_color_10 = "#5ae07c"
vim.g.terminal_color_11 = p.amber
vim.g.terminal_color_12 = p.blue
vim.g.terminal_color_13 = "#af67b1"
vim.g.terminal_color_14 = "#67b1b1"
vim.g.terminal_color_15 = "#e5e5e5"
