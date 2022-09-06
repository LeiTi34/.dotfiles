local yabs = require('yabs')
if not yabs then return end

local conditions = require('yabs.conditions')
if not conditions then return end

yabs:setup({
    languages = { -- List of languages in vim's `filetype` format
        typescript = {
            default_task = 'start',
            tasks = {
                start = {
                    command = 'TermExec cmd="npm start"',
                    type = 'vim',
                    condition = conditions.file_exists('package.json')
                },
                build = {
                    command = 'TermExec cmd="npm build"',
                    type = 'vim',
                    condition = conditions.file_exists('package.json')
                },
                install = {
                    command = 'npm install',
                    type = 'shell',
                    output = 'echo',
                    condition = conditions.file_exists('package.json')
                },
                install_server = {
                    command = 'cd src/server && npm install',
                    type = 'shell',
                    output = 'echo',
                    condition = conditions.file_exists('src/server/package.json')
                },
            },
        },
        tex = {
            default_task = 'develop',
            tasks = {
                develop = {
                    command = [[TermExec cmd='latexmk -shell-escape -pdf -pvc']],
                    type = 'vim',
                    output = 'none',
                },
                build = {
                    command = 'latexmk -shell-escape -pdf',
                    type = 'shell',
                    output = 'echo',
                },
            }
        },
    },
})


local telescope = require('telescope')
if not telescope then return end

telescope.load_extension('yabs')
