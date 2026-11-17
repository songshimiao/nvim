-- ROS 2 Humble Workspace Management
local M = {}

local workspace = vim.fn.expand "~/Projects/ros2/humble_ws"

local container = "ros2-humble-dev"

local shell = vim.fn.expand "~/.local/bin/ros2-humble-shell"

local function workspace_exists()
  return vim.fn.isdirectory(workspace) == 1 and vim.fn.filereadable(workspace .. "/.ros2-workspace") == 1
end

function M.open_workspace()
  if not workspace_exists() then
    vim.notify("ROS 2 workspace or marker not found", vim.log.levels.ERROR)
    return
  end

  vim.cmd("cd " .. vim.fn.fnameescape(workspace))

  vim.notify("ROS 2 Workspace: " .. workspace, vim.log.levels.INFO)
end

function M.open_terminal()
  if not workspace_exists() then
    vim.notify("ROS 2 workspace not found", vim.log.levels.ERROR)
    return
  end

  if vim.fn.executable(shell) ~= 1 then
    vim.notify("ROS 2 shell script not executable", vim.log.levels.ERROR)
    return
  end

  -- Open a terminal split.
  vim.cmd "botright 12new"

  -- Neovim 0.11+ terminal API.
  local job_id = vim.fn.jobstart({ shell }, {
    term = true,

    on_exit = function(_, code)
      if code ~= 0 then vim.schedule(function() vim.notify("ROS 2 shell exited: " .. code, vim.log.levels.WARN) end) end
    end,
  })

  if job_id <= 0 then
    vim.notify("Failed to start ROS 2 terminal", vim.log.levels.ERROR)
    return
  end
  vim.cmd "startinsert"
end

function M.info()
  local message = {
    "ROS 2 Humble Workspace",
    "-------------------------------",
    "Host workspace: " .. workspace,
    "Container: " .. container,
    "Container workspace: /workspace/humble_ws",
    "Current directory: " .. vim.fn.getcwd(),
    "Workspace marker: " .. tostring(workspace_exists()),
    "Shell executable: " .. tostring(vim.fn.executable(shell) == 1),
  }

  vim.notify(table.concat(message, "\n"), vim.log.levels.INFO, { title = "ROS 2 Workspace" })
end

return M
