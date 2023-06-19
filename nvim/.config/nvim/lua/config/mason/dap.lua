require('mason-nvim-dap').setup({
    ensure_installed = {
        'chrome',
        'firefox',
        'node2',
    },
    automatic_installation = true,
    automatic_setup = true,
})

-- require('mason-nvim-dap').setup_handlers()

require('dapui').setup()
