return {
    "nvim-treesitter/nvim-treesitter",
    branch = 'master',
    lazy = false,
    build = ":TSUpdate",
   config = function ()
    require('nvim-treesitter.configs').setup {
        ensure_installed = {"c", "lua", "vim", "vimdoc", "python","go", "goctl", "gomod", "gosum", "gotmpl", "gowork", "java", "javascript", "json", "yaml", "xml", "powershell", "markdown", "markdown_inline"},
        sync_install = false,
        highlight = {
            enable = true,
        },
        indent = {
            enable = true,
        },
    }
   end 
}