require('mason').setup()

require('mason-lspconfig').setup({
    ensure_installed = {
        'angularls',
        'cssls',
        'cssmodules_ls',
        'dockerls',
        'emmet_ls',
        'gopls',
        'html',
        'jsonls',
        'ltex',
        'pyright',
        'rust_analyzer',
        'sqlls',
        'sumneko_lua',
        'texlab',
        'tsserver',
        'lemminx',
        'yamlls',
    },
    automatic_installation = true,
})

require('mason-nvim-dap').setup({
    ensure_installed = {
        'chrome',
        'firefox',
        'node2',
    },
    automatic_installation = true,
    automatic_setup = true,
})

require('mason-nvim-dap').setup_handlers()
