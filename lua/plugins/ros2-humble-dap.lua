return {
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require "dap"

      local host_ws = "/home/song/Projects/ros2/humble_ws"
      local container_ws = "/workspace/humble_ws"

      local adapter = vim.fn.expand "~/.local/share/nvim/mason/bin/OpenDebugAD7"

      if vim.fn.executable(adapter) ~= 1 then
        vim.notify("ROS2 GDB: OpenDebugAD7 not installed", vim.log.levels.WARN)
        return
      end

      -- 独立注册，不覆盖 codelldb
      dap.adapters.ros2_humble_gdb = {
        type = "executable",
        command = adapter,
        id = "cppdbg",

        options = {
          detached = false,
          initialize_timeout_sec = 15,
        },
      }

      local config = {
        name = "ROS2 Humble Docker: GDB Launch",
        type = "ros2_humble_gdb",
        request = "launch",

        program = container_ws .. "/install/humble_cpp_demo/lib/humble_cpp_demo/cpp_talker",

        cwd = container_ws,

        logging = {
          engineLogging = true,
          trace = true,
          traceResponse = true,
          moduleLoad = false,
        },

        args = {},

        stopAtEntry = true,

        MIMode = "gdb",

        miDebuggerPath = "/workspace/humble_ws/.debug/gdb-ros2.sh",

        pipeTransport = {
          pipeCwd = host_ws,
          pipeProgram = "/usr/bin/docker",

          pipeArgs = {
            "exec",
            "-i",
            "ros2-humble-dev",
          },

          debuggerPath = "/workspace/humble_ws/.debug/gdb-ros2.sh",
          quoteArgs = false,
        },

        sourceFileMap = {
          [container_ws] = host_ws,
          ["/opt/ros/humble/include"] = vim.fn.expand "~/.local/share/ros2-humble/include",
        },

        setupCommands = {
          {
            text = "-enable-pretty-printing",
            description = "Enable GDB pretty printing",
            ignoreFailures = true,
          },
        },
      }

      -- 只追加一个专用配置，保留原有 LLDB 配置
      dap.configurations.cpp = dap.configurations.cpp or {}

      local exists = false
      for _, item in ipairs(dap.configurations.cpp) do
        if item.name == config.name then
          exists = true
          break
        end
      end

      if not exists then table.insert(dap.configurations.cpp, config) end
    end,
  },
}
