return {
    "mason-org/mason-lspconfig.nvim",
    build = ":MasonUpdate",
    opts = {
        -- ensure_installed = {"c", "lua", "vim", "vimdoc", "python","go", "goctl", "gomod", "gosum", "gotmpl", "gowork", "java", "javascript", "json", "yaml", "xml", "powershell"},
        ensure_installed = {"python-lsp-server", "clang-format", "luau-lsp", "gofumpt", "goimports", "golangci-lint", "golangci-lint-langserver", "gomodifytags", "gopls"}
    },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
        opts = {
            
        }
    },
}