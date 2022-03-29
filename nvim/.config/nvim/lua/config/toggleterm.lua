local toggleterm = require("toggleterm")
if not toggleterm then return end

toggleterm.setup{
  -- size can be a number or function which is passed the current terminal
  open_mapping = '<Leader>tt',
  insert_mappings = false,
  start_in_insert = false,
  direction = 'horizontal'
}

local Terminal  = require('toggleterm.terminal').Terminal
if not Terminal then return end

local lazygit = Terminal:new({
    cmd = "lazygit",
    hidden = true,
    direction = 'float'
})

function _lazygit_toggle()
  lazygit:toggle()
end

