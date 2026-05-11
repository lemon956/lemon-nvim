return {
    { "nvim-tree/nvim-web-devicons", lazy = false },
    {
        "nvim-tree/nvim-tree.lua",
        lazy = false, -- 启动时立即加载
        priority = 1000, -- 确保优先加载
        config = function()
            local function on_attach(bufnr)
                local api = require("nvim-tree.api")

                local function opts(desc)
                    return {
                        desc = desc,
                        buffer = bufnr,
                        noremap = true,
                        silent = true,
                        nowait = true,
                    }
                end

                api.config.mappings.default_on_attach(bufnr)

                local function change_root_to_node(node)
                    node = node or api.tree.get_node_under_cursor()
                    if node == nil then
                        return
                    end

                    local cwd = node.absolute_path
                    if node.type ~= "directory" then
                        cwd = vim.fs.dirname(cwd)
                    end

                    if cwd == nil then
                        return
                    end

                    vim.api.nvim_set_current_dir(cwd)

                    if node.type == "directory" then
                        api.tree.change_root_to_node(node)
                    else
                        api.tree.change_root(cwd)
                    end
                end

                local function change_root_to_parent(node)
                    local abs_path
                    if node == nil then
                        local root_node = api.tree.get_nodes()
                        abs_path = root_node and root_node.absolute_path
                    else
                        abs_path = node.absolute_path
                    end

                    if abs_path == nil then
                        return
                    end

                    local parent_path = vim.fs.dirname(abs_path)
                    vim.api.nvim_set_current_dir(parent_path)
                    api.tree.change_root(parent_path)
                end

                vim.keymap.set("n", "C", change_root_to_node, opts("nvim-tree: 设置当前目录 (Set current directory)"))
                vim.keymap.set("n", "-", change_root_to_parent, opts("nvim-tree: 返回上级目录 (Go to parent directory)"))
            end

            require("nvim-tree").setup({
                on_attach = on_attach,
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
                desc = "自动打开 nvim-tree (Auto-open nvim-tree)"
            })
        end,
        keys = {
            { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "切换文件树 (Toggle file tree)" },
            { "<leader>o", "<cmd>NvimTreeFindFile<cr>", desc = "在文件树中定位当前文件 (Find current file in tree)" },
        },
    },
}
