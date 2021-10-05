require("toggleterm").setup{
  -- size can be a number or function which is passed the current terminal
  open_mapping = '<Leader>tt',
  insert_mappings = false,
  start_in_insert = false,
  direction = 'horizontal'
}

local Terminal  = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({
    cmd = "lazygit",
    hidden = true,
    direction = 'float'
})

function _lazygit_toggle()
  lazygit:toggle()
end

