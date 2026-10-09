require('mason').setup()

require('config.mason.lspconfig')
-- require('config.mason.dap')
require("conform").setup({
  formatters_by_ft = {
    javascript = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    html = { "prettierd", "prettier", stop_after_first = true },
    css = { "prettierd", "prettier", stop_after_first = true },
    scss = { "prettierd", "prettier", stop_after_first = true },
    json = { "prettierd", "prettier", stop_after_first = true },
    yaml = { "prettierd", "prettier", stop_after_first = true },
    markdown = { "prettierd", "prettier", stop_after_first = true },
  },
  formatters = {
      prettierd = {
          cwd = require("conform.util").root_file({ ".editorconfig", "package.json" }),
          -- When cwd is not found, don't run the formatter (default false)
          require_cwd = true,
      },
      prettier = {
          cwd = require("conform.util").root_file({ ".editorconfig", "package.json" }),
          -- When cwd is not found, don't run the formatter (default false)
          require_cwd = true,
      }
  },
  default_format_opts = {
    lsp_format = "fallback",
  },
})

