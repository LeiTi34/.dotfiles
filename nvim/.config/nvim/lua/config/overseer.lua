require('overseer').setup({
    strategy = 'terminal',
    auto_detect_success_color = true,
    dap = true,
    templates = {
        "builtin",
        -- "npm_start",
        "http_server",
        "latexmk_build",
        "latexmk_develop",
    },
    actions = {
    --     ["Toggleterm"] = {
    --         desc = "Runs a task in Toggleterm",
    --         run = function(task)
    --             local toggleterm  = require('toggleterm').Terminal
    --             -- local Terminal  = require('toggleterm.terminal').Terminal
    --
    --             -- local term = Terminal:new({
    --             --     cmd = task.cmd + ' ' + task.args
    --             -- })
    --             --
    --             -- term.
    --             --
    --
    --             toggleterm.exec('ls', 1 , 12)
    --
    --
    --         end,
    --     },
    },
    task_list = {
        -- bindings = {
        --     ['t'] = 'CMD>OverseerQuickAction Toggleterm',
        -- },
    },
})

