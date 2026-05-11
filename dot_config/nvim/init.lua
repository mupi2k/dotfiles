-- Bootstrap Lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins
require("lazy").setup({
  { "vim-airline/vim-airline", dependencies = { "vim-airline/vim-airline-themes" } },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' }
},
  { "neovim/nvim-lspconfig" },
--  { "github/copilot"},
  { "hrsh7th/nvim-cmp", dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-path" } },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "arcticicestudio/nord-vim", name = "nord", priority = 1000, config = function()
      vim.cmd("colorscheme nord")
    vim.opt.background = "dark"  -- Ensure dark variant
    -- Override background to true black and brighten accents
    vim.api.nvim_set_hl(0, "Normal", { bg = "#000000", fg = "#D8DEE9" })  -- True black, bright text
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "#1A252F" })  -- Subtle line highlight
    vim.api.nvim_set_hl(0, "Visual", { bg = "#5E81AC" })  -- Brighter selection
    vim.api.nvim_set_hl(0, "StatusLine", { bg = "#000000", fg = "#8FBCBB" })  -- Match airline
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#000000", fg = "#4C566A" })  -- Inactive statusline
    vim.api.nvim_set_hl(0, "LineNr", { fg = "#81A1C1", bg = "#000000" })
  end },
  {
    "zbirenbaum/copilot-cmp",
    event = "InsertEnter",
    config = function () require("copilot_cmp").setup() end,
    dependencies = {
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      config = function()
        require("copilot").setup({
        suggestion = { enabled = true },
        panel = { enabled = false },
      })
      end,
    },
  },
  {
    "kylechui/nvim-surround",
    version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
    })
    end
  },
--  { "williamboman/mason.nvim", config = true },
--  { "williamboman/mason-lspconfig.nvim", config = function()
--    require("mason-lspconfig").setup({ ensure_installed = { "yamlls", "pyright", "ts_ls" } })
--    end },
})


-- General settings
vim.opt.termguicolors = true          -- Enable true colors
vim.opt.expandtab = true              -- Convert tabs to spaces (line 17)
vim.opt.tabstop = 4                   -- Tab width is 4 spaces (line 19)
vim.opt.shiftwidth = 2                -- Indent level for Python/JS (line 21)
vim.opt.hlsearch = true               -- Highlight search matches (line 22)
vim.opt.laststatus = 2                -- Always show statusline (line 23, 'ls=2')
vim.opt.number = true                 -- Show line numbers (line 26)
vim.cmd("filetype plugin indent on")  -- Enable filetype, plugins, indent (line 27)
vim.opt.background = dark
vim.g.airline_powerline_fonts = 1
vim.g.airline_extensions_tabline_enabled = 1

-- Custom highlights (ported from vimrc)
vim.api.nvim_set_hl(0, "Pmenu", { ctermfg = 188, ctermbg = 31, fg = "#E4E4E4", bg = "#0087AF"})
vim.api.nvim_set_hl(0, "PmenuSel", { ctermfg = 59, ctermbg = 188, fg = "#585858", bg = "#E4E4E4"})
vim.api.nvim_set_hl(0, "SpellCap", { ctermfg = 196, ctermbg = 188, fg = "#E4E4E4", bg = "#E4E4E4"})
vim.g.airline_theme='cool'
vim.g.airline_override_colors = 1
vim.g.airline_left_sep = ''
vim.g.airline_left_alt_sep = ''
vim.g.airline_right_sep = ''
vim.g.airline_right_alt_sep = ''
vim.g.airline_symbols.branch = ''
vim.g.airline_symbols.readonly = ''
vim.g.airline_symbols.linenr = ''

local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()  -- Bridge LSP to nvim-cmp

-- YAML
vim.lsp.config("yamlls", {
  cmd = { "yaml-language-server", "--stdio" },
  capabilities = capabilities,
  filetypes = { "yaml", "yml" },
  settings = {
    yaml = {
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
      },
    },
  },
})
vim.lsp.enable("yamlls")

-- Python
vim.lsp.config("pyright", {
  cmd = { "pyright-langserver", "--stdio" },
  capabilities = capabilities,
  filetypes = { "python" },
})
vim.lsp.enable("pyright")

-- TypeScript (ts_ls)
vim.lsp.config("ts_ls", {
  cmd = { "typescript-language-server", "--stdio" },
  capabilities = capabilities,
  filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
  root_dir = vim.fs.dirname(vim.fs.find({ "package.json", "tsconfig.json" }, { upward = true })[1]),
})
vim.lsp.enable("ts_ls")

-- vim.api.nvim_create_autocmd("LspAttach", {
--   callback = function(args)
--     local buf = args.buf
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     if client then
--       print(client.name .. " attached to buffer " .. buf)  -- Your debug (e.g., "ts_ls attached")
--      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buf, desc = "Go to definition" })
--      vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = buf, desc = "Hover" })
--      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = buf, desc = "Code actions" })
--    end
--  end,
--})

-- Ensure attachment for specific filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript", "javascript", "typescriptreact", "javascriptreact", "yaml", "yml", "python" },
  callback = function()
    local ft = vim.bo.filetype
    if ft:match("typescript") or ft:match("javascript") then
      vim.lsp.enable("ts_ls", { bufnr = 0 })
    elseif ft:match("yaml") then
      vim.lsp.enable("yamlls", { bufnr = 0 })
    elseif ft == "python" then
      vim.lsp.enable("pyright", { bufnr = 0 })
    end
  end,
})

local cmp = require("cmp")
cmp.setup({
  sources = {
    { name = "copilot" },
    { name = "nvim_lsp" },  -- LSP completions (now enabled via capabilities)
    { name = "path" },      -- Filesystem paths
  },
  mapping = {
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  },
  window = {
    completion = cmp.config.window.bordered({ border = "single" }),  -- Minimal menu
  },
})

-- Treesitter for syntax highlighting
require("nvim-treesitter.configs").setup {
  ensure_installed = { "yaml", "python", "typescript", "javascript", "lua" },
  highlight = { enable = true },
  auto_install = true,  -- Automatically install parsers if missing
  indent = { enable = true },
}

-- Diagnostics (buffer-based, no popups)
vim.diagnostic.config { virtual_text = true, float = true }
vim.keymap.set("n", "<leader>e", vim.diagnostic.setloclist, { desc = "Show errors" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
-- Temporarily import vim settings
-- vim.cmd("source ~/.config/nvim/init.vim.test")

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
-- Ensure airline overrides base colorscheme
vim.cmd [[
  autocmd ColorScheme * call airline#load_theme()
  let g:airline#extensions#tabline#enabled = 1 " Enable tabline if used
]]
