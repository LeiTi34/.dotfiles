-- local env = vim.fn.expand('$HOME') .. '/.config/nvim/env.lua'
local env = vim.fn['stdpath']('config')..'/lua/env.lua'
dofile(env)

if vim.env.OPENAI_API_KEY == nil then
  print('Please set the OPENAI_API_KEY environment variable')
  return
end

local status_neural, neural = pcall(require, 'neural')
if not status_neural then
  return
end

neural.setup({
  open_ai = {
    api_key = vim.env.OPENAI_API_KEY,
  },
})
