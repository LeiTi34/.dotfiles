local tc = require('todo-comments')
if not tc then return end

tc.setup({
    search = {
        command = "rg",
        args = {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--glob=!node_modules",
        },
        pattern = [[\b(KEYWORDS):]],
    },
})
