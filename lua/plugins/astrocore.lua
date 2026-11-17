local notes_session = {
  cwd = nil,
  file = nil,
}

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- passed to `vim.filetype.add`
    filetypes = {
      -- see `:h vim.filetype.add` for usage
      extension = {
        foo = "fooscript",
      },
      filename = {
        [".foorc"] = "fooscript",
      },
      pattern = {
        [".*/etc/foo/.*"] = "fooscript",
      },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- Open the SilverBullet note space that using AstroNvim to edit markdown notes.
        ["<Leader>on"] = {
          function()
            local path = "/tank/notes/silverbullet/spaces/notes"

            if not notes_session.cwd then
              notes_session.cwd = vim.fn.getcwd()
              notes_session.file = vim.api.nvim_buf_get_name(0)
            end
            vim.cmd.cd(vim.fn.fnameescape(path))
            vim.cmd.edit(vim.fn.fnameescape(path .. "/index.md"))
          end,
          desc = "Open SilverBullet Notes",
        },

        ["<Leader>ob"] = {
          function()
            if not notes_session.cwd then
              vim.notify("没有保存的工作目录", vim.log.levels.WARN)
              return
            end

            local old_cwd = notes_session.cwd
            local old_file = notes_session.file

            ---@diagnostic disable-next-line: param-type-mismatch
            vim.cmd.cd(vim.fn.fnameescape(old_cwd))

            if old_file and old_file ~= "" and vim.fn.filereadable(old_file) == 1 then
              vim.cmd.edit(vim.fn.fnameescape(old_file))
            end

            notes_session.cwd = nil
            notes_session.file = nil

            vim.notify("已返回：" .. old_cwd, vim.log.levels.INFO)
          end,
          desc = "Back to Previous Workspace",
        },
      },
    },
  },
}
