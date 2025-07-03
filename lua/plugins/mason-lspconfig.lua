return {
    "mason-org/mason-lspconfig.nvim",
    build = ":MasonUpdate",
    opts = {
        -- ensure_installed = {"c", "lua", "vim", "vimdoc", "python","go", "goctl", "gomod", "gosum", "gotmpl", "gowork", "java", "javascript", "json", "yaml", "xml", "powershell"},
        ensure_installed = {"gopls", "lua_ls", "bashls", "yamlls", "jsonls", "taplo", "buf_ls"}
    },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
        opts = {}
    },
}