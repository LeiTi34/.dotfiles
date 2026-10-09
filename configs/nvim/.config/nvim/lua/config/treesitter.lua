local tsparsers = require('nvim-treesitter.parsers')
if not tsparsers then return end

-- local parser_configs = tsparsers.get_parser_configs()

-- parser_configs.norg = {
--     install_info = {
--         url = "https://github.com/nvim-neorg/tree-sitter-norg",
--         files = { "src/parser.c", "src/scanner.cc" },
--         branch = "main"
--     },
-- }
--
-- parser_configs.norg_meta = {
--     install_info = {
--         url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
--         files = { "src/parser.c" },
--         branch = "main"
--     },
-- }
--
-- parser_configs.norg_table = {
--     install_info = {
--         url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
--         files = { "src/parser.c" },
--         branch = "main"
--     },
-- }

local ts = require('nvim-treesitter')
if not ts then return end

ts.setup()
vim.api.nvim_create_autocmd('FileType', {
    callback = function()
        -- Enable treesitter highlighting and disable regex syntax
        pcall(vim.treesitter.start)
        -- Enable treesitter-based indentation
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})

local ok, treesitter = pcall(require, "nvim-treesitter")
if not ok then return end

local ensureInstalled = {
  "c", "lua", "rust", "c", "cpp", "python", "java", "javascript", "typescript", "latex", "make", "nix",
  "php", "query", "r", "scss", "yaml", "json", "html", "css",
  "toml", "vue", "svelte", "ql", "bibtex", "bash", "cmake", "vim", "verilog", "comment",
  "markdown", "markdown_inline"
}

local alreadyInstalled = treesitter.get_installed()
local parsersToInstall = vim.iter(ensureInstalled)
    :filter(function(parser)
      return not vim.tbl_contains(alreadyInstalled, parser)
    end)
    :totable()

ts.install(parsersToInstall)

