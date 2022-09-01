local map = vim.api.nvim_set_keymap

local options = { noremap = true, silent = true }

-- Set up <Space> to be the global leader
map('n', '<Space>', '<NOP>', options)
vim.g.mapleader = ' '

local nest = require('nest')
if not nest then return end

-- LUA bindings
-- local nvim_docker = require('nvim-docker')

-- Keymap
nest.applyKeymaps {
    -- Leader commands
    { '<leader>', {
        -- Window navigation
        { 'h', '<Cmd>wincmd h<CR>' },
        { 'j', '<Cmd>wincmd j<CR>' },
        { 'k', '<Cmd>wincmd k<CR>' },
        { 'l', '<Cmd>wincmd l<CR>' },

        -- Telescope
        { 'f', {
            { 'b', '<Cmd>lua require("telescope.builtin").buffers()<CR>' },
            { 'f', '<Cmd>lua require("telescope.builtin").find_files()<CR>' },
            { 'g', '<Cmd>lua require("telescope.builtin").live_grep()<CR>' },
            { 'h', '<Cmd>lua require("telescope.builtin").help_tags()<CR>' },
            { 'k', '<Cmd>lua require("telescope.builtin").keymaps()<CR>' },
            { 's', '<Cmd>SessionManager load_session<CR>' },
            { 't', '<Cmd>Telescope yabs tasks<CR>' },
            -- -- Nvim Docker
            -- { 'd', nvim_docker.containers.list_containers }
        }},

        -- Tree
        { 'n', {
            { 'n', '<Cmd>Neotree reveal toggle source=filesystem<CR>' },
            { 'b', '<Cmd>Neotree reveal toggle source=buffers<CR>' },
            { 'g', '<Cmd>Neotree reveal toggle source=git_status<CR>' },
            { 'd', '<Cmd>Neotree reveal bottom toggle source=diagnostics<CR>' },
        }},

        -- LSP
        { 'oi', '<Cmd>TSLspOrganize<CR>' },
        { 'rf', '<Cmd>TSLspRenameFile<CR>' },
        { 'ia', '<Cmd>TSLspImportAll<CR>' },
        -- Code Action Menu
        { 'cA', '<cmd>CodeActionMenu<CR>' },

        -- Neogit
        { 'gs', '<Cmd>lua require("neogit").open()<CR>' },

        -- Cokeline
        { 'b', {
            { 'b', '<Plug>(cokeline-pick-focus)' },
            { 'c', '<Plug>(cokeline-pick-close)' },
            { 'n', '<Plug>(cokeline-focus-next)' },
            { 'p', '<Plug>(cokeline-focus-prev)' },
        }},

        -- Dadbod UI
        { 'd', {
            { 'u', '<Cmd>DBUIToggle<CR>' },
            { 'f', '<Cmd>DBUIFindBuffer<CR>' },
            { 'r', '<Cmd>DBUIRenameBuffer<CR>' },
            { 'l', '<Cmd>DBUILastQueryInfo<CR>' },
        }},

        -- Harpoon
        { 'h', {
            { 'a', '<Cmd>lua require("harpoon.mark").add_file()<CR>' },
            { 'm', '<Cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>' },
        }},
        { 't', {
            { 'm', '<Cmd>lua require("harpoon.cmd-ui").toggle_quick_menu()<CR>' },
            { 'h', '<Cmd>lua require("harpoon.term").gotoTerminal(1)<CR>' },
            { 'j', '<Cmd>lua require("harpoon.term").gotoTerminal(2)<CR>' },
            { 'k', '<Cmd>lua require("harpoon.term").gotoTerminal(3)<CR>' },
            { 'l', '<Cmd>lua require("harpoon.term").gotoTerminal(4)<CR>' },

            -- yabs
            { 'r', '<Cmd>lua require("yabs"):run_default_task()<CR>' },

            -- todo-comments
            { 'c', '<Cmd>TodoQuickFix<CR>' },
            { 'C', '<Cmd>TodoTelescope<CR>' },

            --troubles
            { 'd', '<Cmd>TroubleToggle<CR>' },
        }},
        { 'c', {
            { 'h', '<Cmd>lua require("harpoon.term").sendCommand(2, 1)<CR>' },
            { 'j', '<Cmd>lua require("harpoon.term").sendCommand(1, 2)<CR>' },
            { 'k', '<Cmd>lua require("harpoon.term").sendCommand(1, 3)<CR>' },
            { 'l', '<Cmd>lua require("harpoon.term").sendCommand(1, 4)<CR>' },
        }},

        -- Git Worktree
        { 'w', {
            { 'w', '<Cmd>lua require("telescope").extensions.git_worktree.git_worktrees()<CR>' },
            { 'c', '<Cmd>lua require("telescope").extensions.git_worktree.create_git_worktree()<CR>' },
        }},

        -- Session
        { 's', {
            {'f', '<Cmd>SessionManager load_session<CR>' },
            {'l', '<Cmd>SessionManager load_last_session<CR>' },
            {'s', '<Cmd>SessionManager save_current_session<CR>' },
        }},
    }},

    -- v commands
    { 'v', {
        -- Syntax tree surfer
        { 'd', '<Cmd>lua require("syntax-tree-surfer").move("n", false)<CR>'}, -- TODO Check if binding is good/needed
        { 'u', '<Cmd>lua require("syntax-tree-surfer").move("n", true)<CR>'},
        { 'x', '<Cmd>lua require("syntax-tree-surfer").select()<CR>'},
        { 'n', '<Cmd>lua require("syntax-tree-surfer").select_current_node()<CR>'},
    }},

    -- Ctrl commands
    { '<C-', {
        -- Harpoon navigation
        { 'h>', '<Cmd>lua require("harpoon.ui").nav_file(1)<CR>' },
        { 'j>', '<Cmd>lua require("harpoon.ui").nav_file(2)<CR>' },
        { 'k>', '<Cmd>lua require("harpoon.ui").nav_file(3)<CR>' },
        { 'l>', '<Cmd>lua require("harpoon.ui").nav_file(4)<CR>' },
    }},

    -- Navigate Quick fix list
    { '[q', '<Cmd>cprev<CR>' },
    { ']q', '<Cmd>cnext<CR>' },

    -- x mode
    { mode = 'x', {
        -- Syntax tree surfer
        { 'J', '<Cmd>lua require("syntax-tree-surfer").surf("next", "visual")<CR>' },
        { 'K', '<Cmd>lua require("syntax-tree-surfer").surf("prev", "visual")<CR>' },
        { 'H', '<Cmd>lua require("syntax-tree-surfer").surf("parent", "visual")<CR>' },
        { 'L', '<Cmd>lua require("syntax-tree-surfer").surf("child", "visual")<CR>' },

        { '<A-', {
            { 'j>', '<Cmd>lua require("syntax-tree-surfer").surf("next", "visual", true)<CR>' },
            { 'k>', '<Cmd>lua require("syntax-tree-surfer").surf("prev", "visual", true)<CR>' },
        }},
    }},

    -- -- Visual remaps
    -- { mode = 'v', {
    --     { 'J', '<Cmd>m \'>+1<CR>gv=gv' },
    --     { 'K', '<Cmd>m \'<-2<CR>gv=gv' },
    -- }},

    -- Terminal Remaps
    { mode = 't', {
        { '<esc>', '<C-\\><C-n>' },
        { '<C-v><esc>', '<esc>' },
    }}
}
