-- ROS 2 C++ Navigation Integration

return {
  "AstroNvim/astrocore",

  opts = {
    commands = {
      RosCppDefinition = {
        function() require("ros2_cpp_nav").definition() end,
        desc = "ROS C++: Go to definition",
      },

      RosCppDeclaration = {
        function() require("ros2_cpp_nav").declaration() end,
        desc = "ROS C++: Go to declaration",
      },

      RosCppImplementation = {
        function() require("ros2_cpp_nav").implementation() end,
        desc = "ROS C++: Go to implementation",
      },

      RosCppReferences = {
        function() require("ros2_cpp_nav").references() end,
        desc = "ROS C++: Find references",
      },

      RosCppHover = {
        function() require("ros2_cpp_nav").hover() end,
        desc = "ROS C++: Hover information",
      },

      RosCppAction = {
        function() require("ros2_cpp_nav").code_action() end,
        desc = "ROS C++: Code actions",
      },

      RosCppDiagnostics = {
        function() require("ros2_cpp_nav").diagnostics() end,
        desc = "ROS C++: Buffer diagnostics",
      },
    },

    mappings = {
      n = {
        ["<Leader>9d"] = {
          "<cmd>RosCppDefinition<cr>",
          desc = "ROS C++ Definition",
        },

        ["<Leader>9f"] = {
          "<cmd>RosCppReferences<cr>",
          desc = "ROS C++ References",
        },

        ["<Leader>9a"] = {
          "<cmd>RosCppAction<cr>",
          desc = "ROS C++ Code Action",
        },

        ["<Leader>9e"] = {
          "<cmd>RosCppDiagnostics<cr>",
          desc = "ROS C++ Diagnostics",
        },
      },
    },
  },
}
