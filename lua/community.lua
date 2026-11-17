---@type LazySpec
return {
  "AstroNvim/astrocommunity",

  -- colorscheme
  { import = "astrocommunity.colorscheme.nord-nvim" },

  -- Neovim / Lua
  { import = "astrocommunity.pack.lua" },

  -- Python / AI / ROS2
  { import = "astrocommunity.pack.python.base" },
  { import = "astrocommunity.pack.python.basedpyright" },
  { import = "astrocommunity.pack.python.ruff" },

  -- C / C++ / Robotics
  { import = "astrocommunity.pack.cpp" },
  { import = "astrocommunity.pack.cmake" },

  -- Markdown / SilverBullet
  { import = "astrocommunity.pack.markdown" },

  -- Shell
  { import = "astrocommunity.pack.bash" },

  -- Configuration files
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.yaml" },

  -- Docker
  { import = "astrocommunity.pack.docker" },

  { import = "astrocommunity.utility.noice-nvim" },
  { import = "astrocommunity.debugging.nvim-dap-virtual-text" },
}
