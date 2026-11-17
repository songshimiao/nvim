-- ROS 2 Humble clangd Operations Integration

return {
  "AstroNvim/astrocore",

  opts = {
    commands = {
      RosClangdStatus = {
        function() require("ros2_clangd_ops").status() end,
        desc = "ROS 2: Show clangd status",
      },

      RosCompdbStatus = {
        function() require("ros2_clangd_ops").compdb_status() end,
        desc = "ROS 2: Show compilation database",
      },

      RosClangdRestart = {
        function() require("ros2_clangd_ops").restart() end,
        desc = "ROS 2: Restart clangd with confirmation",
      },
    },

    mappings = {
      n = {
        ["<Leader>9s"] = {
          "<cmd>RosClangdStatus<cr>",
          desc = "ROS 2 clangd Status",
        },

        ["<Leader>9b"] = {
          "<cmd>RosCompdbStatus<cr>",
          desc = "ROS 2 Compilation Database",
        },

        ["<Leader>9r"] = {
          "<cmd>RosClangdRestart<cr>",
          desc = "ROS 2 Restart clangd",
        },
      },
    },
  },
}
