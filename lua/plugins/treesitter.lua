---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    treesitter = {
      enable = true,
      highlight = true,
      indent = true,
      auto_install = true,
      ensure_installed = {
        -- Neovim
        "lua",
        "vim",
        "vimdoc",
        "query",

        -- Python / ROS2
        "python",

        -- C / C++
        "c",
        "cpp",
        "cmake",

        -- shell
        "bash",

        -- Markdown
        "markdown",
        "markdown_inline",

        -- Configuration
        "json",
        "yaml",
        "toml",
      },
    },
  },
}
