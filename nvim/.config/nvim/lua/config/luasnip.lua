local ls = require('luasnip')
local types = require('luasnip.util.types')
local events = require('luasnip.util.events')

local fmt = require('luasnip.extras.fmt').fmt
local rep = require('luasnip.extras').rep
local snippet_from_nodes = ls.sn
local vscode_loader = require("luasnip.loaders.from_vscode")

local s = ls.s
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local l = require('luasnip.extras').lambda

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

-- -- Custom snippets
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
vscode_loader.load({paths = snippet_dir .. 'vscode-angular-snippets'})
