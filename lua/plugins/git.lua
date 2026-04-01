return {

    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        config = function()
            require("gitsigns").setup({
                current_line_blame = true,
            })
        end,
    },

    {
        "tpope/vim-fugitive",
        cmd = { "Git", "G" },
    },

    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    },

    {
        "kdheepak/lazygit.nvim",
        cmd = { "LazyGit" },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    }

}
