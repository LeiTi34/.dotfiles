
return {
    name = "start http-server on dist/web/public",
    builder = function ()
        return {
            cmd = { "http-server" },
            args = { "--port=3001", "--proxy=http://localhost:3000", "-c-1", "dist/web/public" }
        }
    end,
    condition = {
        filetype = { "typescript", "typescriptreact", "javascript", "html", "css", "scss" },
    }
}
