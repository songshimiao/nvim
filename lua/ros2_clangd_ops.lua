-- ROS 2 Humble clangd Operations

local M = {}

local workspace = vim.fn.expand "~/Projects/ros2/humble_ws"

local compdb = workspace .. "/compile_commands.json"

local function notify(lines, title, level)
  vim.notify(table.concat(lines, "\n"), level or vim.log.levels.INFO, { title = title })
end

local function clangd_clients()
  return vim.lsp.get_clients {
    bufnr = 0,
    name = "clangd",
  }
end

-- 1. Show clangd runtime information.
function M.status()
  local clients = clangd_clients()

  if #clients == 0 then
    vim.notify("No clangd client attached to current buffer", vim.log.levels.WARN)
    return
  end

  local lines = {
    "ROS 2 Humble clangd Status",
    "-------------------------------",
    "Attached clients: " .. #clients,
    "Buffer: " .. vim.api.nvim_buf_get_name(0),
    "Filetype: " .. vim.bo.filetype,
    "Editor cwd: " .. vim.fn.getcwd(),
  }

  for _, client in ipairs(clients) do
    table.insert(lines, "-------------------------------")
    table.insert(lines, "Client: " .. client.name)
    table.insert(lines, "ID: " .. client.id)

    table.insert(lines, "Root: " .. tostring(client.config.root_dir))

    table.insert(lines, "Command: " .. vim.inspect(client.config.cmd))

    table.insert(lines, "Initialized: " .. tostring(client.initialized))
  end

  local counts = {
    errors = 0,
    warnings = 0,
    info = 0,
    hints = 0,
  }

  for _, d in ipairs(vim.diagnostic.get(0)) do
    if d.severity == vim.diagnostic.severity.ERROR then
      counts.errors = counts.errors + 1
    elseif d.severity == vim.diagnostic.severity.WARN then
      counts.warnings = counts.warnings + 1
    elseif d.severity == vim.diagnostic.severity.INFO then
      counts.info = counts.info + 1
    elseif d.severity == vim.diagnostic.severity.HINT then
      counts.hints = counts.hints + 1
    end
  end

  table.insert(lines, "-------------------------------")
  table.insert(lines, "Current buffer diagnostics:")
  table.insert(lines, "Errors: " .. counts.errors)
  table.insert(lines, "Warnings: " .. counts.warnings)
  table.insert(lines, "Info: " .. counts.info)
  table.insert(lines, "Hints: " .. counts.hints)

  notify(lines, "clangd Status")
end

-- 2. Show compilation database information.
function M.compdb_status()
  local stat = vim.uv.fs_stat(compdb)

  if not stat then
    vim.notify("Compilation database not found: " .. compdb, vim.log.levels.ERROR)
    return
  end

  local target = vim.uv.fs_realpath(compdb)

  local lines = {
    "ROS 2 Compilation Database",
    "-------------------------------",
    "Workspace: " .. workspace,
    "Database: " .. compdb,
    "Resolved: " .. tostring(target),
    "Size: " .. stat.size .. " bytes",
    "Modified: " .. os.date("%Y-%m-%d %H:%M:%S", stat.mtime.sec),
  }

  local ok, content = pcall(function() return vim.fn.readfile(compdb) end)

  if ok then
    local decoded_ok, data = pcall(function() return vim.json.decode(table.concat(content, "\n")) end)
    if decoded_ok and vim.islist(data) then
      table.insert(lines, "Entries: " .. #data)
    else
      table.insert(lines, "JSON: invalid or not an array")
    end
  else
    table.insert(lines, "JSON: cannot read")
  end

  notify(lines, "Compilation Database")
end

-- 3. Restart only the existing clangd client.
function M.restart()
  local clients = clangd_clients()

  if #clients ~= 1 then
    vim.notify("Expected one attached clangd client; found " .. #clients, vim.log.levels.WARN)
    return
  end

  if vim.fn.exists ":LspRestart" ~= 2 then
    vim.notify(":LspRestart is unavailable", vim.log.levels.ERROR)
    return
  end

  local current = vim.api.nvim_get_current_buf()

  vim.ui.select({ "Cancel", "Restart clangd" }, {
    prompt = "Restart current clangd client?",
  }, function(choice)
    if choice ~= "Restart clangd" then return end

    if not vim.api.nvim_buf_is_valid(current) then return end

    local active = vim.lsp.get_clients {
      bufnr = current,
      name = "clangd",
    }

    if #active ~= 1 then
      vim.notify("clangd attachment changed; restart cancelled", vim.log.levels.WARN)
      return
    end

    local ok, err = pcall(function() vim.cmd "LspRestart clangd" end)

    if not ok then
      vim.notify("clangd restart failed: " .. tostring(err), vim.log.levels.ERROR)
    else
      vim.notify("clangd restart requested", vim.log.levels.INFO)
    end
  end)
end

return M
