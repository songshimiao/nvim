return {
  {
    "jay-babu/mason-null-ls.nvim",
    opts = function(_, opts)
      opts.handlers = opts.handlers or {}

      -- Ruff already provides Python formatting and import sorting.
      -- Keep Black/isort installed, but do not register them in none-ls.
      opts.handlers.black = function() end
      opts.handlers.isort = function() end
    end,
  },
}
