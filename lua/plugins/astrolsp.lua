---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    features = {
      codelens = true, -- enable/disable codelens refresh on start
      inlay_hints = false, -- enable/disable inlay hints on start
      semantic_tokens = true, -- enable/disable semantic token highlighting
    },
    formatting = {
      format_on_save = {
        enabled = true, -- enable or disable format on save globally
        allow_filetypes = {},
        ignore_filetypes = {},
      },
      disabled = {},

      filter = function(client)
        if vim.bo.filetype == "python" then return client.name == "ruff" end
        return true
      end,
      timeout_ms = 1000, -- default format timeout
    },
    -- enable servers that you already have installed without mason
    servers = {},

    config = {
      clangd = {
        root_dir = function(bufnr, on_dir)
          local ws = "/home/song/Projects/ros2/humble_ws"
          local filename = vim.api.nvim_buf_get_name(bufnr)

          -- ROS2 Humble 工作区使用固定根目录
          if filename:sub(1, #ws + 1) == ws .. "/" then
            on_dir(ws)
            return
          end

          -- 其他 C/C++ 项目使用常规根目录
          local root = vim.fs.root(bufnr, {
            "compile_commands.json",
            "compile_flags.txt",
            ".clangd",
            ".git",
          })

          on_dir(root or vim.fs.dirname(filename))
        end,

        cmd = function(dispatchers, config)
          local ws = "/home/song/Projects/ros2/humble_ws"
          local is_ros2 = config.root_dir == ws

          local cmd

          if is_ros2 then
            cmd = { "/home/song/.local/bin/ros2-humble-clangd" }
          else
            cmd = {
              "clangd",
              "--background-index",
              "--clang-tidy",
              "--completion-style=detailed",
            }
          end

          return vim.lsp.rpc.start(cmd, dispatchers)
        end,

        capabilities = {
          offsetEncoding = { "utf-16" },
        },
      },

      basedpyright = {
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "basic",
              diagnosticMode = "openFilesOnly",
              autoImportCompletions = true,
            },
          },
        },
      },
    },

    handlers = {
      pyright = false,
      pyrefly = false,
      ty = false,
    },
    -- Configure buffer local auto commands to add when attaching a language server
    autocmds = {
      -- first key is the `augroup` to add the auto commands to (:h augroup)
      lsp_codelens_refresh = {
        cond = "textDocument/codeLens",
        {
          event = { "InsertLeave", "BufEnter" },
          desc = "Refresh codelens (buffer)",
          callback = function(args)
            if require("astrolsp").config.features.codelens then vim.lsp.codelens.refresh { bufnr = args.buf } end
          end,
        },
      },
    },
    -- mappings to be set up on attaching of a language server
    mappings = {
      n = {
        gD = {
          function() vim.lsp.buf.declaration() end,
          desc = "Declaration of current symbol",
          cond = "textDocument/declaration",
        },
        ["<Leader>uY"] = {
          function() require("astrolsp.toggles").buffer_semantic_tokens() end,
          desc = "Toggle LSP semantic highlight (buffer)",
          cond = function(client)
            return client:supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens ~= nil
          end,
        },
      },
    },
    on_attach = function() end,
    -- 占位，启用时用下面的写法
    -- on_attach = function(_client, _bufnr)
    -- this would disable semanticTokensProvider for all clients
    -- client.server_capabilities.semanticTokensProvider = nil
    -- end,
  },
}
