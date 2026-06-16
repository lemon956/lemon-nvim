return {
    "nvim-treesitter/nvim-treesitter",
    branch = 'main',
    lazy = false,
    build = ":TSUpdate",
    config = function()
        local parsers = {
            "c", "lua", "vim", "vimdoc", "query", "python", "go",
            "gomod", "gosum", "gotmpl", "gowork", "java", "javascript",
            "json", "yaml", "xml", "powershell", "markdown", "markdown_inline",
        }
        require('nvim-treesitter').install(parsers)

        vim.api.nvim_create_autocmd('FileType', {
            pattern = parsers,
            callback = function()
                -- 语法高亮(Neovim 内置)
                pcall(vim.treesitter.start)
                -- 折叠(Neovim 内置)
                vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                vim.wo[0][0].foldmethod = 'expr'
                -- 缩进(nvim-treesitter 提供,实验性)
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end,
}
