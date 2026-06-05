return {
    'nvimdev/lspsaga.nvim',
    event = "LspAttach",
    config = function()
        require('lspsaga').setup({
            -- 跳转定义：回车直接在当前窗口替换打开（不分屏）
            definition = {
                keys = {
                    edit = "<CR>",   -- 当前窗口替换打开 (open in current window)
                    vsplit = "<C-v>", -- 需要时才左右分屏
                    split = "<C-s>",  -- 需要时才上下分屏
                    tabe = "<C-t>",
                    quit = "q",
                },
            },
            -- 查找引用(finder)：回车在当前窗口替换打开
            finder = {
                keys = {
                    toggle_or_open = "<CR>", -- 当前窗口替换打开 (open in current window)
                    vsplit = "<C-v>",
                    split = "<C-s>",
                    tabe = "<C-t>",
                    quit = "q",
                },
            },
        })
    end,
    dependencies = {
        'nvim-treesitter/nvim-treesitter', -- optional
        'nvim-tree/nvim-web-devicons',     -- optional
    }
}
