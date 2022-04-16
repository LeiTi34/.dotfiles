-- Setup nvim-cmp.
local cmp = require('cmp')
if not cmp then return end

local lspkind = require('lspkind')
if not lspkind then return end

local luasnip = require('luasnip')
if not luasnip then return end

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            --vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = "neorg"},
        { name = 'luasnip' }, -- For luasnip users.
        -- { name = 'emmet_ls' },
        -- { name = 'vsnip' }, -- For vsnip users.
        { name = "path"},
        { name = "calc"},
        { name = 'cmp_tabnine', keyword_length = 5 },
        -- { name = "spell"},
        -- { name = 'buffer', keyword_length = 5 },
        -- { name = 'ultisnips' }, -- For ultisnips users.
        -- { name = 'snippy' }, -- For snippy users.
    }),
    formatting = {
        format = lspkind.cmp_format({
            with_text = true, -- do not show text alongside icons
            menu = {
                nvim_lsp = '[LSP]',
                vsnip = '[VSnip]',
                luasnip = '[LSnip]',
                path = '[Path]',
                calc = '[Calc]',
                cmp_tabnine = '[TabNine]',
            },
        })
    },

    experimental = {
    -- I like the new menu better! Nice work hrsh7th
        native_menu = false,

        -- Let's play with this for a day or two
        ghost_text = false,
    },
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

-- TabNine
local tabnine = require('cmp_tabnine.config')
if  tabnine then
    tabnine:setup({
        max_lines = 1000,
        max_num_results = 20,
        sort = true,
        run_on_every_keystroke = true
    })
end


-- Setup lspconfig.
--local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
--
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
-- require('lspconfig')['tsserver'].setup {
--     capabilities = capabilities
-- }
