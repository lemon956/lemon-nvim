---@diagnostic disable-next-line: undefined-global
local vim = vim

return {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "mason-org/mason.nvim",
        "neovim/nvim-lspconfig",
    },
    config = function()
        -- Load LSP configuration
        local lsp_config = require("configs.lsp")
        
        -- Setup mason-lspconfig with handlers
        require("mason-lspconfig").setup({
            ensure_installed = {"gopls", "lua_ls", "bashls", "yamlls", "jsonls", "taplo", "buf_ls"},
            automatic_installation = true,
            handlers = {
                -- Default handler for all servers
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        on_attach = lsp_config.on_attach,
                        capabilities = lsp_config.capabilities,
                    })
                end,
                
                -- Special handler for lua_ls
                ["lua_ls"] = function()
                    require("lspconfig").lua_ls.setup({
                        on_attach = lsp_config.on_attach,
                        capabilities = lsp_config.capabilities,
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim" }
                                },
                                workspace = {
                                    library = vim.api.nvim_get_runtime_file("", true),
                                    checkThirdParty = false,
                                },
                                telemetry = {
                                    enable = false,
                                },
                            },
                        },
                    })
                end,
            }
        })
    end,
}