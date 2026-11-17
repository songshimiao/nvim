-- AstroNvim ROS 2 Humble Commands & Mappings

return {
  "AstroNvim/astrocore",

  opts = {
    commands = {
      RosWorkspace = {
        function() require("ros2_workspace").open_workspace() end,
        desc = "Open ROS 2 Humble workspace",
      },

      RosTerminal = {
        function() require("ros2_workspace").open_terminal() end,
        desc = "Open ROS 2 Humble container terminal",
      },

      RosInfo = {
        function() require("ros2_workspace").info() end,
        desc = "Show ROS 2 workspace information",
      },
    },

    mappings = {
      n = {
        ["<Leader>9"] = {
          desc = "ROS 2 Humble",
        },

        ["<Leader>9w"] = {
          "<cmd>RosWorkspace<cr>",
          desc = "Open ROS 2 Workspace",
        },

        ["<Leader>9t"] = {
          "<cmd>RosTerminal<cr>",
          desc = "Open ROS 2 Terminal",
        },

        ["<Leader>9i"] = {
          "<cmd>RosInfo<cr>",
          desc = "ROS 2 Workspace Info",
        },
      },
    },
  },
}
