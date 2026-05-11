---@diagnostic disable-next-line: undefined-global
local vim = vim

local M = {}

function M.is_termux()
    return vim.env.TERMUX_VERSION ~= nil
        or vim.fn.executable("termux-info") == 1
        or vim.fn.isdirectory("/data/data/com.termux/files/usr") == 1
end

return M
