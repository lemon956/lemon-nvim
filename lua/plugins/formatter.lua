---@diagnostic disable-next-line: undefined-global
local vim = vim

return {
    'mhartington/formatter.nvim',
    config = function()
        -- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
        require("formatter").setup {
            
            -- Enable or disable logging
            logging = true,
            -- Set the log level
            log_level = vim.log.levels.WARN,
            -- All formatter configurations are opt-in
            filetype = {
                -- Formatter configurations for filetype "lua" go here
                -- and will be executed in order
                lua = {
                    -- "formatter.filetypes.lua" defines default configurations for the
                    -- "lua" filetype
                    require("formatter.filetypes.lua").stylua,

                    -- You can also define your own configuration
                    function()
                        local util = require("formatter.util")
                        -- Supports conditional formatting
                        if util.get_current_buffer_file_name() == "special.lua" then
                            return nil
                        end

                        -- Full specification of configurations is down below and in Vim help
                        -- files
                        return {
                            exe = "stylua",
                            args = {
                                "--search-parent-directories",
                                "--stdin-filepath",
                                util.escape_path(util.get_current_buffer_file_path()),
                                "--",
                                "-",
                            },
                            stdin = true,
                        }
                    end
                },
                go = {
                    require("formatter.filetypes.go").gofmt,
                    require("formatter.filetypes.go").goimports,
                    require("formatter.filetypes.go").goimports_reversed,
                    require("formatter.filetypes.go").gofumpt,
                    require("formatter.filetypes.go").gofumports,
                    require("formatter.filetypes.go").golines,
                },

                -- Use the special "*" filetype for defining formatter configurations on
                -- any filetype
                ["*"] = {
                    -- "formatter.filetypes.any" defines default configurations for any
                    -- filetype
                    require("formatter.filetypes.any").remove_trailing_whitespace,
                    -- Remove trailing whitespace without 'sed'
                    -- require("formatter.filetypes.any").substitute_trailing_whitespace,
                }
            }
        }
    end,
    dependencies = {
        'mhartington/formatter.nvim',
    }
}
