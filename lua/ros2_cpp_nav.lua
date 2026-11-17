-- ROS 2 Humble C++ Navigation
-- Uses the existing clangd LSP client.

local M = {}

local function clangd_ready()
  local ft = vim.bo.filetype

  if ft ~= "cpp" and ft ~= "c" then
    vim.notify("ROS C++ navigation requires a C/C++ buffer", vim.log.levels.WARN)
    return false
  end

  local clients = vim.lsp.get_clients {
    bufnr = 0,
    name = "clangd",
  }

  if #clients ~= 1 then
    vim.notify("Expected one clangd client, found " .. #clients, vim.log.levels.WARN)
    return false
  end

  return true
end

function M.definition()
  if not clangd_ready() then return end
  vim.lsp.buf.definition()
end

function M.declaration()
  if not clangd_ready() then return end
  vim.lsp.buf.declaration()
end

function M.implementation()
  if not clangd_ready() then return end
  vim.lsp.buf.implementation()
end

function M.references()
  if not clangd_ready() then return end
  vim.lsp.buf.references()
end

function M.hover()
  if not clangd_ready() then return end
  vim.lsp.buf.hover()
end

function M.code_action()
  if not clangd_ready() then return end
  vim.lsp.buf.code_action()
end

function M.diagnostics()
  if not clangd_ready() then return end

  vim.diagnostic.setloclist {
    open = true,
  }
end

return M
