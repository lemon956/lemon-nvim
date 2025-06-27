return {
    { "nvim-tree/nvim-web-devicons", lazy = false },
    {
        "nvim-tree/nvim-tree.lua",
        lazy = false, -- 启动时立即加载
        priority = 1000, -- 确保优先加载
        config = function()
            require("nvim-tree").setup({
                sort = {
                    sorter = "case_sensitive",
                },
                view = {
                    width = 30,
                    side = "left",
                },
                renderer = {
                    group_empty = true,
                    icons = {
                        show = {
                            file = true,
                            folder = true,
                            folder_arrow = true,
                            git = true,
                        },
                    },
                },
                filters = {
                    dotfiles = false,
                },
                git = {
                    enable = true,
                },
                actions = {
                    open_file = {
                        quit_on_open = false, -- 打开文件后不关闭侧边栏
                    },
                },
            })

            -- 自动打开 nvim-tree
            local function auto_open_nvim_tree()
                -- 如果没有参数（即没有打开特定文件），则自动打开 nvim-tree
                if vim.fn.argc() == 0 then
                    vim.cmd("NvimTreeOpen")
                end
            end

            -- 在 VimEnter 事件后打开
            vim.api.nvim_create_autocmd("VimEnter", {
                callback = auto_open_nvim_tree,
                desc = "自动打开 nvim-tree"
            })
        end,
        keys = {
            { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "切换文件树" },
            { "<leader>o", "<cmd>NvimTreeFindFile<cr>", desc = "在文件树中定位当前文件" },
        },
    },
}