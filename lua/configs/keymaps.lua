---@diagnostic disable-next-line: undefined-global
local vim = vim

-- ============================================
-- Neovim 快捷键配置
-- ============================================

-- 设置 leader 键
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 快捷键设置函数
local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end


-- ============================================
-- 基本编辑快捷键
-- ============================================

-- 更好的上下移动
map("n", "j", "gj", { desc = "向下移动（屏幕行）" })
map("n", "k", "gk", { desc = "向上移动（屏幕行）" })

-- 更好的缩进
-- map("v", "<", "<gv", { desc = "向左缩进并保持选中" })
-- map("v", ">", ">gv", { desc = "向右缩进并保持选中" })

-- 移动选中的文本
map("v", "J", ":move '>+1<CR>gv=gv", { desc = "向下移动选中行" })
map("v", "K", ":move '<-2<CR>gv=gv", { desc = "向上移动选中行" })

-- 在插入模式下移动光标
map("i", "<C-h>", "<Left>", { desc = "光标左移" })
map("i", "<C-j>", "<Down>", { desc = "光标下移" })
map("i", "<C-k>", "<Up>", { desc = "光标上移" })
map("i", "<C-l>", "<Right>", { desc = "光标右移" })

-- 快速保存和退出
map("n", "<leader>w", "<cmd>w<cr>", { desc = "保存文件" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "退出" })
map("n", "<leader>wq", "<cmd>wq<cr>", { desc = "保存并退出" })

-- 全选
map("n", "<C-a>", "ggVG", { desc = "全选" })

-- 复制到系统剪贴板
map("v", "<leader>y", '"+y', { desc = "复制到系统剪贴板" })
map("n", "<leader>Y", '"+Y', { desc = "复制整行到系统剪贴板" })

-- 从系统剪贴板粘贴
map("n", "<leader>p", '"+p', { desc = "从系统剪贴板粘贴" })
map("v", "<leader>p", '"+p', { desc = "从系统剪贴板粘贴" })

-- ============================================
-- 缓冲区管理
-- ============================================

-- 缓冲区导航
map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "下一个缓冲区" })
map("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "上一个缓冲区" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "删除缓冲区" })

-- 标签页管理
map("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "新建标签页" })
map("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "关闭标签页" })
map("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "只保留当前标签页" })

-- ============================================
-- 窗口管理（分屏）
-- ============================================

-- 分屏
map("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "垂直分屏" })
map("n", "<leader>sh", "<cmd>split<cr>", { desc = "水平分屏" })
map("n", "<leader>se", "<C-w>=", { desc = "均分窗口大小" })
map("n", "<leader>sx", "<cmd>close<cr>", { desc = "关闭当前窗口" })

-- 窗口导航
map("n", "<C-h>", "<C-w>h", { desc = "移动到左侧窗口" })
map("n", "<C-j>", "<C-w>j", { desc = "移动到下方窗口" })
map("n", "<C-k>", "<C-w>k", { desc = "移动到上方窗口" })
map("n", "<C-l>", "<C-w>l", { desc = "移动到右侧窗口" })

-- 窗口大小调整
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "增加窗口高度" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "减少窗口高度" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "减少窗口宽度" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "增加窗口宽度" })

-- ============================================
-- 搜索和导航
-- ============================================

-- 清除搜索高亮
map("n", "<leader>nh", "<cmd>nohl<cr>", { desc = "清除搜索高亮" })

-- 保持搜索居中
map("n", "n", "nzzzv", { desc = "下一个搜索结果（居中）" })
map("n", "N", "Nzzzv", { desc = "上一个搜索结果（居中）" })

-- 快速跳转到行首行尾
map("n", "H", "^", { desc = "跳转到行首" })
map("n", "L", "$", { desc = "跳转到行尾" })

-- ============================================
-- 代码编辑
-- ============================================

-- 快速注释（需要 Comment.nvim 插件）
map("n", "<leader>/", "gcc", { desc = "注释/取消注释行", remap = true })
map("v", "<leader>/", "gc", { desc = "注释/取消注释选中", remap = true })

-- 代码格式化
map("n", "<leader>cf", function()
    vim.lsp.buf.format({ async = true })
end, { desc = "格式化代码" })

-- ============================================
-- 文件操作
-- ============================================

-- 创建新文件
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "新建文件" })

-- 重新加载文件
map("n", "<leader>fr", "<cmd>e!<cr>", { desc = "重新加载文件" })

-- 显示文件路径
map("n", "<leader>fp", function()
    local filepath = vim.fn.expand("%:p")
    vim.notify(filepath, vim.log.levels.INFO)
    vim.fn.setreg("+", filepath)
end, { desc = "显示并复制文件路径" })

-- ============================================
-- 实用工具
-- ============================================

-- 切换行号
map("n", "<leader>ln", function()
    vim.opt.number = not vim.opt.number:get()
end, { desc = "切换行号显示" })

-- 切换相对行号
map("n", "<leader>lr", function()
    vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, { desc = "切换相对行号显示" })

-- 切换自动换行
map("n", "<leader>lw", function()
    vim.opt.wrap = not vim.opt.wrap:get()
end, { desc = "切换自动换行" })

-- 快速编辑配置文件
map("n", "<leader>ev", function()
    vim.cmd("edit " .. vim.fn.stdpath("config") .. "/init.lua")
end, { desc = "编辑配置文件" })


-- ============================================
-- 诊断快捷键（LSP 相关）
-- ============================================

-- 诊断导航
map("n", "<leader>dj", vim.diagnostic.goto_next, { desc = "下一个诊断" })
map("n", "<leader>dk", vim.diagnostic.goto_prev, { desc = "上一个诊断" })
map("n", "<leader>dl", vim.diagnostic.open_float, { desc = "显示诊断信息" })
map("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "诊断列表" })

-- ============================================
-- 快速修复和列表
-- ============================================

-- QuickFix 列表
map("n", "<leader>qo", "<cmd>copen<cr>", { desc = "打开 QuickFix 列表" })
map("n", "<leader>qc", "<cmd>cclose<cr>", { desc = "关闭 QuickFix 列表" })
map("n", "<leader>qn", "<cmd>cnext<cr>", { desc = "QuickFix 下一项" })
map("n", "<leader>qp", "<cmd>cprev<cr>", { desc = "QuickFix 上一项" })

-- Location 列表
map("n", "<leader>lo", "<cmd>lopen<cr>", { desc = "打开 Location 列表" })
map("n", "<leader>lc", "<cmd>lclose<cr>", { desc = "关闭 Location 列表" })
map("n", "<leader>ln", "<cmd>lnext<cr>", { desc = "Location 下一项" })
map("n", "<leader>lp", "<cmd>lprev<cr>", { desc = "Location 上一项" })

-- ============================================
-- 其他实用快捷键
-- ============================================

-- 禁用方向键（强制使用 hjkl）
map("n", "<Up>", "<Nop>", { desc = "禁用上方向键" })
map("n", "<Down>", "<Nop>", { desc = "禁用下方向键" })
map("n", "<Left>", "<Nop>", { desc = "禁用左方向键" })
map("n", "<Right>", "<Nop>", { desc = "禁用右方向键" })

-- telescope plugin
map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = '搜索文件' })
map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = '搜索文件' })
map('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { desc = '搜索缓冲区' })
map('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { desc = '搜索帮助标签' })

-- 快速替换
map("n", "<leader>rw", ":%s/\\<<C-r><C-w>\\>/", { desc = "替换当前单词" })


-- ============================================
-- LSP 快捷键（在 LSP attach 时会自动设置）
-- ============================================
-- gd - 跳转到定义 (Go to Definition)
-- gD - 跳转到声明 (Go to Declaration)
-- gi - 跳转到实现 (Go to Implementation)
-- gr - 显示引用 (Show References)
-- K - 悬浮文档 (Hover Documentation)
-- <leader>rn - 重命名 (Rename)
-- <leader>ca - 代码操作 (Code Action)

-- Lspsaga keymaps (optional, will override default LSP keymaps if lspsaga is available)
map("n", "K", "<cmd>Lspsaga hover_doc<cr>", { desc = "悬浮文档" })
map("n", "<leader>gd", "<cmd>Lspsaga goto_definition<cr>", { desc = "跳转到定义" })
map("n", "<leader>gf", "<cmd>Lspsaga finder<cr>", { desc = "LSP 查找" })
map("n", "<leader>t", "<cmd>Lspsaga term_toggle<cr>", { desc = "子终端" })
map("n", "<leader>ic", "<cmd>Lspsaga incoming_calls<cr>", { desc = "查看调用" })
map("n", "<leader>oc", "<cmd>Lspsaga outgoing_calls<cr>", { desc = "查看被调用" })


-- formatter
map("n", "<leader>F", "<cmd>Format<cr>", { desc = "格式化代码" })

-- 显示快捷键帮助
map("n", "<leader>?", function()
    vim.cmd("help")
end, { desc = "显示帮助" })

-- ============================================
-- 自定义命令
-- ============================================

-- 创建一些有用的命令
vim.api.nvim_create_user_command("ReloadConfig", function()
    for name, _ in pairs(package.loaded) do
        if name:match("^configs") or name:match("^plugins") then
            package.loaded[name] = nil
        end
    end
    dofile(vim.env.MYVIMRC)
    vim.notify("配置已重新加载!", vim.log.levels.INFO)
end, { desc = "重新加载配置" })

vim.api.nvim_create_user_command("ShowKeymaps", function()
    vim.cmd("Telescope keymaps")
end, { desc = "显示所有快捷键" })

-- 添加快捷键来调用这些命令
map("n", "<leader>rc", "<cmd>ReloadConfig<cr>", { desc = "重新加载配置" })
map("n", "<leader>sk", "<cmd>ShowKeymaps<cr>", { desc = "显示快捷键" })
