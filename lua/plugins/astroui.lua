---@type LazySpec
return {
  "AstroNvim/astroui",
  ---@type AstroUIOpts
  opts = {
    colorscheme = "nord",
    -- AstroUI allows you to easily modify highlight groups easily for any and all colorschemes
    highlights = {
      init = {
        Normal = { bg = "NONE", ctermbg = "NONE" },
        NormalNC = { bg = "NONE", ctermbg = "NONE" },
        NormalFloat = { bg = "NONE", ctermbg = "NONE" },
        SignColumn = { bg = "NONE" },
        FoldColumn = { bg = "NONE" },
        LineNr = { bg = "NONE" },
        FloatBorder = { bg = "NONE" },
        CursorLine = { bg = "NONE", ctermbg = "NONE" },
        CursorColumn = { bg = "NONE", ctermbg = "NONE" },
        WinBar = { bg = "NONE", ctermbg = "NONE" },
        WinBarNC = { bg = "NONE", ctermbg = "NONE" },
        -- Neo-tree 顶部标签栏透明
        NeoTreeTabActive = { bg = "NONE", bold = true },

        NeoTreeTabInactive = { fg = "#777777", bg = "NONE" },

        NeoTreeTabSeparatorActive = { bg = "NONE" },

        NeoTreeTabSeparatorInactive = { bg = "NONE" },
      },
    },
    -- Icons can be configured throughout the interface
    icons = {
      -- configure the loading of the lsp in the status line
      LSPLoading1 = "⠋",
      LSPLoading2 = "⠙",
      LSPLoading3 = "⠹",
      LSPLoading4 = "⠸",
      LSPLoading5 = "⠼",
      LSPLoading6 = "⠴",
      LSPLoading7 = "⠦",
      LSPLoading8 = "⠧",
      LSPLoading9 = "⠇",
      LSPLoading10 = "⠏",
    },
  },
}
