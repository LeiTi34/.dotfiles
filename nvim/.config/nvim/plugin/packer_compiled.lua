-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/user/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/user/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/user/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/user/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/user/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["bufferline.nvim"] = {
    config = { "\27LJ\2\nD\0\0\4\0\3\0\0066\0\0\0006\2\1\0'\3\2\0&\2\3\2B\0\2\1K\0\1\0\19bufferline.lua\19pluginSettings\vdofile\0" },
    loaded = true,
    path = "/home/user/.local/share/nvim/site/pack/packer/start/bufferline.nvim"
  },
  chadtree = {
    loaded = true,
    path = "/home/user/.local/share/nvim/site/pack/packer/start/chadtree"
  },
  ["coq.artifacts"] = {
    loaded = true,
    path = "/home/user/.local/share/nvim/site/pack/packer/start/coq.artifacts"
  },
  ["coq.thirdparty"] = {
    loaded = true,
    path = "/home/user/.local/share/nvim/site/pack/packer/start/coq.thirdparty"
  },
  coq_nvim = {
    config = { "\27LJ\2\n=\0\0\4\0\3\0\0066\0\0\0006\2\1\0'\3\2\0&\2\3\2B\0\2\1K\0\1\0\fcoq.lua\19pluginSettings\vdofile\0" },
    loaded = true,
    path = "/home/user/.local/share/nvim/site/pack/packer/start/coq_nvim"
  },
  ["feline.nvim"] = {
    config = { "\27LJ\2\n4\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\vfeline\frequire\0" },
    loaded = true,
    path = "/home/user/.local/share/nvim/site/pack/packer/start/feline.nvim"
  },
  ["focus.nvim"] = {
    config = { "\27LJ\2\np\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\25compatible_filetrees\1\0\1\14treewidth\3\20\1\2\0\0\rCHADTree\nsetup\nfocus\frequire\0" },
    loaded = true,
    path = "/home/user/.local/share/nvim/site/pack/packer/start/focus.nvim"
  },
  ["github-nvim-theme"] = {
    config = { "\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17github-theme\frequire\0" },
    loaded = true,
    path = "/home/user/.local/share/nvim/site/pack/packer/start/github-nvim-theme"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rgitsigns\frequire\0" },
    loaded = true,
    path = "/home/user/.local/share/nvim/site/pack/packer/start/gitsigns.nvim"
  },
  ["null-ls.nvim"] = {
    loaded = true,
    path = "/home/user/.local/share/nvim/site/pack/packer/start/null-ls.nvim"
  },
  ["nvim-code-action-menu"] = {
    commands = { "CodeActionMenu" },
    loaded = false,
    needs_bufread = true,
    path = "/home/user/.local/share/nvim/site/pack/packer/opt/nvim-code-action-menu"
  },
  ["nvim-lsp-ts-utils"] = {
    config = { "\27LJ\2\nC\0\0\4\0\3\0\0066\0\0\0006\2\1\0'\3\2\0&\2\3\2B\0\2\1K\0\1\0\18lspconfig.lua\19pluginSettings\vdofile\0" },
    loaded = true,
    path = "/home/user/.local/share/nvim/site/pack/packer/start/nvim-lsp-ts-utils"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/user/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\nD\0\0\4\0\3\0\0066\0\0\0006\2\1\0'\3\2\0&\2\3\2B\0\2\1K\0\1\0\19treesitter.lua\19pluginSettings\vdofile\0" },
    loaded = true,
    path = "/home/user/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/user/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/user/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/user/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/home/user/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["toggleterm.nvim"] = {
    config = { "\27LJ\2\nD\0\0\4\0\3\0\0066\0\0\0006\2\1\0'\3\2\0&\2\3\2B\0\2\1K\0\1\0\19toggleterm.lua\19pluginSettings\vdofile\0" },
    loaded = true,
    path = "/home/user/.local/share/nvim/site/pack/packer/start/toggleterm.nvim"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/user/.local/share/nvim/site/pack/packer/start/vim-fugitive"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: github-nvim-theme
time([[Config for github-nvim-theme]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17github-theme\frequire\0", "config", "github-nvim-theme")
time([[Config for github-nvim-theme]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\nD\0\0\4\0\3\0\0066\0\0\0006\2\1\0'\3\2\0&\2\3\2B\0\2\1K\0\1\0\19treesitter.lua\19pluginSettings\vdofile\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)
-- Config for: coq_nvim
time([[Config for coq_nvim]], true)
try_loadstring("\27LJ\2\n=\0\0\4\0\3\0\0066\0\0\0006\2\1\0'\3\2\0&\2\3\2B\0\2\1K\0\1\0\fcoq.lua\19pluginSettings\vdofile\0", "config", "coq_nvim")
time([[Config for coq_nvim]], false)
-- Config for: feline.nvim
time([[Config for feline.nvim]], true)
try_loadstring("\27LJ\2\n4\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\vfeline\frequire\0", "config", "feline.nvim")
time([[Config for feline.nvim]], false)
-- Config for: toggleterm.nvim
time([[Config for toggleterm.nvim]], true)
try_loadstring("\27LJ\2\nD\0\0\4\0\3\0\0066\0\0\0006\2\1\0'\3\2\0&\2\3\2B\0\2\1K\0\1\0\19toggleterm.lua\19pluginSettings\vdofile\0", "config", "toggleterm.nvim")
time([[Config for toggleterm.nvim]], false)
-- Config for: nvim-lsp-ts-utils
time([[Config for nvim-lsp-ts-utils]], true)
try_loadstring("\27LJ\2\nC\0\0\4\0\3\0\0066\0\0\0006\2\1\0'\3\2\0&\2\3\2B\0\2\1K\0\1\0\18lspconfig.lua\19pluginSettings\vdofile\0", "config", "nvim-lsp-ts-utils")
time([[Config for nvim-lsp-ts-utils]], false)
-- Config for: focus.nvim
time([[Config for focus.nvim]], true)
try_loadstring("\27LJ\2\np\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\25compatible_filetrees\1\0\1\14treewidth\3\20\1\2\0\0\rCHADTree\nsetup\nfocus\frequire\0", "config", "focus.nvim")
time([[Config for focus.nvim]], false)
-- Config for: bufferline.nvim
time([[Config for bufferline.nvim]], true)
try_loadstring("\27LJ\2\nD\0\0\4\0\3\0\0066\0\0\0006\2\1\0'\3\2\0&\2\3\2B\0\2\1K\0\1\0\19bufferline.lua\19pluginSettings\vdofile\0", "config", "bufferline.nvim")
time([[Config for bufferline.nvim]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file CodeActionMenu lua require("packer.load")({'nvim-code-action-menu'}, { cmd = "CodeActionMenu", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
