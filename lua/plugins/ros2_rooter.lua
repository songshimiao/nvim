-- ROS 2 workspace root detection
return {
  "AstroNvim/astrocore",

  opts = function(_, opts)
    opts.rooter = opts.rooter or {}

    local detectors = opts.rooter.detector
      or {
        "lsp",
        { ".git", "_darcs", ".hg", ".bzr", ".svn" },
        { "lua", "Makefile", "package.json" },
      }

    -- Give ROS 2 workspace marker highest priority.
    -- Preserve existing project root detectors.
    table.insert(detectors, 1, { ".ros2-workspace" })

    opts.rooter.detector = detectors

    -- Manual switching avoids disrupting debugging sessions.
    opts.rooter.autochdir = false
    opts.rooter.scope = "global"
    opts.rooter.notify = false
  end,
}
