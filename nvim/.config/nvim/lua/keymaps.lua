local map = vim.api.nvim_set_keymap

local options = { noremap = true, silent = true }

-- Set up <Space> to be the global leader
map('n', '<Space>', '<NOP>', options)
vim.g.mapleader = ' '

local nest = require('nest')
if not nest then return end

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
            { 'f', '<Cmd>lua require("telescope.builtin").find_files()<CR>' },
            { 'g', '<Cmd>lua require("telescope.builtin").live_grep()<CR>' },
            { 'b', '<Cmd>lua require("telescope.builtin").buffers()<CR>' },
            { 'k', '<Cmd>lua require("telescope.builtin").keymaps()<CR>' },
            { 'h', '<Cmd>lua require("telescope.builtin").help_tags()<CR>' },
        }},

        -- Tree
        { 'n', {
            { 'n', '<Cmd>Neotree reveal toggle source=filesystem<CR>' },
            { 'b', '<Cmd>Neotree reveal toggle source=buffers<CR>' },
            { 'g', '<Cmd>Neotree reveal toggle source=git_status<CR>' },
        }},

        -- LSP
        { 'oi', '<Cmd>TSLspOrganize<CR>' },
        { 'rf', '<Cmd>TSLspRenameFile<CR>' },
        { 'ia', '<Cmd>TSLspImportAll<CR>' },
        -- Code Action Menu
        { 'ca', '<cmd>CodeActionMenu<CR>' },

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

    -- Visual remaps FIXME
    { mode = 'v', {
        { 'J', '<Cmd>m \'>+1<CR>gv=gv' },
        { 'K', '<Cmd>m \'<-2<CR>gv=gv' },
    }},

    -- Terminal Remaps
    { mode = 't', {
        { '<esc>', '<C-\\><C-n>' },
        { '<C-v><esc>', '<esc>' },
    }}
}
