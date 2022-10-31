local ls = require('luasnip')

local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local fmt = require("luasnip.extras.fmt").fmt
local extras = require("luasnip.extras")
local m = extras.m
local l = extras.l
local rep = extras.rep
local postfix = require("luasnip.extras.postfix").postfix
local vscode_loader = require("luasnip.loaders.from_vscode")

local snippet_dir = vim.fn['stdpath']('config')..'/snippets/'

-- Set config
ls.config.set_config({
    history = true,
    updateevents = "TextChanged,TextChangedI",
})
-- keymaps
vim.keymap.set({'i', 's'}, '<C-k>', function()
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
    end
end, { silent = true })

vim.keymap.set({'i', 's'}, '<C-j>', function()
    if ls.jumpable(-1) then
        ls.jump(-1)
    end
end, { silent = true })

vim.keymap.set('i', '<C-l>', function()
    if ls.choice_active() then
        ls.change_choice(1)
    end
end, { silent = true })


vim.keymap.set('n', '<Leader><Leader>s', '<Cmd>source ~/.config/nvim/lua/config/luasnip.lua<CR>')

-- Functions
local date = function() return {os.date('%Y-%m-%d')} end

-- Custom snippets
ls.add_snippets(nil, {
    markdown = {
        s({
            trig = 'meta',
            namr = 'Metadata',
            dscr = 'Yaml medadata for markdown'
        },
        {
            t({'---',
            'title: '}), i(1, 'title'), t({'',
            'author: '}), i(2, 'Alex Leidwein'), t({'',
            'date: '}), i(3, extras.partial(os.date, '%Y-%m-%d')), t({'',
            'fontfamily: '}), i(4, 'helvet'), t({'',
            'header-includes:',
            '  - \\renewcommand{\\familydefault}{\\sfdefault}',
            'pagestyle: empty',
            'papersize: a4',
            'geometry: margin='}), i(5, '3cm'), t({'',
            'output: pdf_document',
            '---',
            ''}), i(0)
        }),
    }
})
-- ls.add_snippets('all', {
--     s('test',t 'test successful'),
-- })
--
-- ls.add_snippets('lua', {
--     ls.parser.parse_snippet("lf", "loacl$11 = function($2)\n    $0\nend"),
--     s("req", fmt("local {} = require('{}')", { i(1), rep(1)})),
-- })

-- Load predefined snippets

vscode_loader.load()
vscode_loader.lazy_load({paths = snippet_dir .. 'vscode-angular-snippets'})
