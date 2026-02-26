require('neo-tree').setup({
    sources = {
        "filesystem",
        "buffers",
        "git_status",
        "diagnostics",
    },
    nesting_rules = {},
    filesystem = {
        filtered_items = {
            visible = true, -- when true, they will just be displayed differently than normal items
            hide_dotfiles = false,
            hide_gitignored = true,
            hide_by_name = {
                ".DS_Store",
                "thumbs.db"
                --"node_modules"
            },
            never_show = { -- remains hidden even if visible is toggled to true
            --".DS_Store",
            --"thumbs.db"
           },
        },
    }
})
