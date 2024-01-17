require('mason-lspconfig').setup({
    ensure_installed = {
        'angularls',
        'cssls',
        -- 'cssmodules_ls',
        -- 'dockerls',
        -- -- 'docker_compose_language_service',
        -- 'emmet_ls',
        -- 'gopls',
        -- 'html',
        -- 'jsonls',
        -- 'ltex',
        -- 'pyright',
        -- 'rust_analyzer',
        -- 'sqlls',
        -- 'lua_ls',
        -- 'texlab',
        -- 'tsserver',
        -- 'lemminx',
        'yamlls',
    },
    automatic_installation = true,
})

local nvim_lsp = require('lspconfig')
if not nvim_lsp then return end

local util = require ("lspconfig.util")
local navic = require("nvim-navic")
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.g.navic_silence = true

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
    end
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local bufopts = { noremap=true, silent=true, buffer=bufnr }

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-s>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, bufopts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<leader>rr', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<leader>fc', function() vim.lsp.buf.format({async = true}) end, bufopts)
end

local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

require("mason-lspconfig").setup_handlers {
    -- This is a default handler that will be called for each installed server (also for new servers that are installed during a session)
    function (server_name)
        nvim_lsp[server_name].setup {

            on_attach = on_attach,
            capabilities = capabilities,
            flags = {
                debounce_text_changes = 150,
            }
        }
    end,
}

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
-- local servers = {
--     'ccls',
--     'cssls',
--     'cssmodules_ls',
--     'dockerls',
--     'docker_compose_language_service',
--     'gopls',
--     'html',
--     'jsonls',
--     'pyright',
--     'rust_analyzer',
--     'sqlls',
--     'tsserver',
--     'texlab',
--     'yamlls',
-- }
--
-- for _, lsp in ipairs(servers) do
--     nvim_lsp[lsp].setup {
--         on_attach = on_attach,
--         capabilities = capabilities,
--         flags = {
--             debounce_text_changes = 150,
--         }
--     }
-- end

-- Sumneko Lua
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")


nvim_lsp.lua_ls.setup {
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = runtime_path,
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'},
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}

nvim_lsp.texlab.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        texlab = {
            auxDirectory = ".",
            bibtexFormatter = "texlab",
            build = {
                args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
                executable = "latexmk",
                forwardSearchAfter = false,
                onSave = false
            },
            chktex = {
                onEdit = false,
                onOpenAndSave = false
            },
            diagnosticsDelay = 300,
            formatterLineLength = 80,
            forwardSearch = {
                args = {}
            },
            latexFormatter = "latexindent",
            latexindent = {
                modifyLineBreaks = false
            }
        }
    }
})

-- setup LSP config
nvim_lsp.ltex.setup({
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        require("ltex_extra").setup {
            load_langs = { "de-AT", "en-US" }, -- table <string> : languages for witch dictionaries will be loaded
            init_check = true, -- boolean : whether to load dictionaries on startup
            path = ".ltex", -- string : path to store dictionaries. Relative path uses current working directory
            log_level = "none", -- string : "none", "trace", "debug", "info", "warn", "error", "fatal"
        }
    end,
    capabilities = capabilities,
    filetypes = { "bib", "markdown", "org", "plaintex", "rst", "rnoweb", "tex", "ltex", "texlab", "gitcommit" },
    settings = {
        ltex = {
            enabled = { "bib", "markdown", "org", "plaintex", "rst", "rnoweb", "tex", "ltex", "texlab", "gitcommit" },
            -- enabled = true,
            language = "de-AT",
            additionalRules = {
                enablePickyRules = true,
                motherTongue = "de-AT",
            },
        },
    },
})


local snippet_servers = {'emmet_ls', 'cssls' --[[, 'angularls']] }

-- Setup with snippet support
capabilities.textDocument.completion.completionItem.snippetSupport = true

for _, lsp in ipairs(snippet_servers) do
    nvim_lsp[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {
            debounce_text_changes = 150,
        }
    }
end

-- Angularls
-- local project_library_path = vim.fn.stdpath("config").."/lsp"
-- local cmd = {
--     "ngserver",
--     "--stdio",
--     "--tsProbeLocations", project_library_path,
--     "--ngProbeLocations", project_library_path,
--     "--includeCompletionsWithSnippetText",
--     "--includeAutomaticOptionalChainCompletions",
-- }

nvim_lsp.angularls.setup {
    -- cmd = cmd,
    root_dir = util.root_pattern('angular.json'),
    -- on_new_config = function(new_config)
    --     new_config.cmd = cmd
    -- end,
}

