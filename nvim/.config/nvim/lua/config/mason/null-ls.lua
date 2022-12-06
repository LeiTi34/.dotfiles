require('mason-null-ls').setup({
    ensure_installed = {
        'hadolint',
        'gitlint',
        'eslint_d',
        'prettierd',
    },
    automatic_installation = true,
    automatic_setup = true, -- Recommended, but optional
})

require("null-ls").setup({
    sources = {
        -- Anything not supported by mason.
    }
})

require('mason-null-ls').setup_handlers() -- If `automatic_setup` is true.
