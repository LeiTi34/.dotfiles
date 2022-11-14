
return {
    name = "latexmk build",
    builder = function ()
        return {
            cmd = { "latexmk" },
            args = { "-shell-escape", "-pdf" }
        }
    end,
    condition = {
        filetype = { "tex", "bib" },
    }
}
