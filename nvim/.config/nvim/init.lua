local ok, impatient = pcall(require, 'impatient')
if ok then
  impatient.enable_profile()
else
  vim.notify(impatient)
end


require('plugins') -- plugins
require('options') -- options
require('keybinds') -- keybinds
