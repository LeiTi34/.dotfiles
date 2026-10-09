local telescope = require('telescope')
if not telescope then return end

telescope.load_extension('git_worktree')
