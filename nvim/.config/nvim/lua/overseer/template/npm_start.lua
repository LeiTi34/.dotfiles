
return {
    name = "npm start",
    builder = function ()
        return {
            cmd = { "npm" },
            args = { "start" }
        }
    end,
    condition = {
        filetype = { "typescript", "typescriptreact", "javascript", "html", "css", "scss", "json" },
    }
}
