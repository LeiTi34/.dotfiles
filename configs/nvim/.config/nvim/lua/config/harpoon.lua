local harpoon = require("harpoon")
if not harpoon then return end

harpoon.setup({
    save_on_toggle = false,
    global_settings = {
        save_on_change = true,
        enter_on_sendcmd = false,
        excluded_filetypes = { "harpoon" }
    },
})
