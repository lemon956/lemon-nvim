---@diagnostic disable-next-line: undefined-global
local vim = vim

local termux = require("configs.termux")
local lsp_servers = { "gopls", "lua_ls", "bashls", "yamlls", "jsonls", "taplo", "buf_ls" }

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

        local function setup_server(server_name)
            if server_name == "lua_ls" then
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
                return
            end

            require("lspconfig")[server_name].setup({
                on_attach = lsp_config.on_attach,
                capabilities = lsp_config.capabilities,
            })
        end

        local is_termux = termux.is_termux()

        -- Mason provides Linux binaries, but many Mason packages are not available
        -- for Android/Termux. Use PATH-installed language servers there instead.
        require("mason-lspconfig").setup({
            ensure_installed = is_termux and {} or lsp_servers,
            automatic_installation = not is_termux,
            handlers = is_termux and {} or {
                setup_server,
            },
        })

        if is_termux then
            for _, server_name in ipairs(lsp_servers) do
                setup_server(server_name)
            end
        end
    end,
}
