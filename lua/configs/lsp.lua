---@diagnostic disable-next-line: undefined-global
local vim = vim

-- LSP Configuration

-- Global diagnostic configuration
vim.diagnostic.config({
    virtual_text = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
        }
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

-- LSP keybindings that will be set when LSP attaches to a buffer
local function on_attach(client, bufnr)
    local function buf_map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.buffer = bufnr
        opts.noremap = true
        opts.silent = true
        vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- Check if lspsaga is available
    local has_lspsaga = pcall(require, "lspsaga")

    -- Basic LSP keybindings
    buf_map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
    buf_map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
    buf_map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
    buf_map("n", "gr", vim.lsp.buf.references, { desc = "Show references" })
    
    -- Only map K if lspsaga is not available (lspsaga uses <leader>K)
    if not has_lspsaga then
        buf_map("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
    end
    
    buf_map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
    buf_map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
    buf_map("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
    end, { desc = "Format code" })
end

-- LSP capabilities (for completion)
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Try to enhance capabilities with completion plugin
local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if has_cmp then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- Try to enhance capabilities with blink.cmp if available
local has_blink, blink = pcall(require, "blink.cmp")
if has_blink then
    capabilities = blink.get_lsp_capabilities(capabilities)
end

return {
    on_attach = on_attach,
    capabilities = capabilities,
}
