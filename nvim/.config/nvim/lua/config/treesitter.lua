local tsparsers = require('nvim-treesitter.parsers')
if not tsparsers then return end

local parser_configs = tsparsers.get_parser_configs()

parser_configs.norg = {
    install_info = {
        url = "https://github.com/nvim-neorg/tree-sitter-norg",
        files = { "src/parser.c", "src/scanner.cc" },
        branch = "main"
    },
}

parser_configs.norg_meta = {
    install_info = {
        url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
        files = { "src/parser.c" },
        branch = "main"
    },
}

parser_configs.norg_table = {
    install_info = {
        url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
        files = { "src/parser.c" },
        branch = "main"
    },
}

local tsconfig = require('nvim-treesitter.configs')
if not tsconfig then return end

tsconfig.setup {
  ensure_installed = {
      "c", "lua", "rust", "c", "cpp", "python", "java", "javascript", "typescript", "latex", "make", "nix",
      "php", "query", "norg", "norg_meta", "norg_table", "r", "scss", "yaml", "json", "html", "css",
      "toml", "vue", "svelte", "ql", "bibtex", "bash", "cmake", "vim", "verilog", "comment",
  }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  -- ignore_install = { "javascript" }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    -- disable = { "c", "rust" },  -- list of language that will be disabled
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
