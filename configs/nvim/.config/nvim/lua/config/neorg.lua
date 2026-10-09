local neorg = require("neorg")
if not neorg then return end

neorg.setup {
    -- Tell Neorg what modules to load
    load = {
        ["core.defaults"] = {}, -- Load all the default modules
        ["core.export"] = {},
        ["core.keybinds"] = {
            config = {
                default_keybinds = true,
                neorg_leader = '<Leader>o'
            }
        },
        ["core.concealer"] = {}, -- Allows for use of icons
        ["core.dirman"] = { -- Manage your directories with Neorg
            config = {
                workspaces = {
                    my_workspace = "~/neorg",
                    gtd = "~/gtd",
                }
            }
        },
        ["core.integrations.telescope"] = {}, -- Enable the telescope module
        ["core.completion"] = {
            config = {
                engine = "nvim-cmp" -- we current support nvim-compe and nvim-cmp only
            }
        },
        -- ["core.gtd.base"] = {
        --     config = {
        --         workspace = "gtd",
        --     }
        -- },
    },
}
