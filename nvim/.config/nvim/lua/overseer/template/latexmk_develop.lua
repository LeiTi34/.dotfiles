return {
    name = "latexmk develop",
    builder = function ()
        return {
            cmd = { "latexmk" },
            args = { "-shell-escape", "-pdf", "-pvc" }
        }
    end,
    condition = {
        filetype = { "tex", "bib" },
    }
}
