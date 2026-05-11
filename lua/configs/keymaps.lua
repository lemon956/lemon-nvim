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
map("n", "j", "gj", { desc = "向下移动（屏幕行） (Move down by screen line)" })
map("n", "k", "gk", { desc = "向上移动（屏幕行） (Move up by screen line)" })

-- 更好的缩进
-- map("v", "<", "<gv", { desc = "向左缩进并保持选中 (Indent left and keep selection)" })
-- map("v", ">", ">gv", { desc = "向右缩进并保持选中 (Indent right and keep selection)" })

-- 移动选中的文本
map("v", "J", ":move '>+1<CR>gv=gv", { desc = "向下移动选中行 (Move selection down)" })
map("v", "K", ":move '<-2<CR>gv=gv", { desc = "向上移动选中行 (Move selection up)" })

-- 在插入模式下移动光标
map("i", "<C-h>", "<Left>", { desc = "光标左移 (Move cursor left)" })
map("i", "<C-j>", "<Down>", { desc = "光标下移 (Move cursor down)" })
map("i", "<C-k>", "<Up>", { desc = "光标上移 (Move cursor up)" })
map("i", "<C-l>", "<Right>", { desc = "光标右移 (Move cursor right)" })

-- 快速保存和退出
map("n", "<leader>w", "<cmd>w<cr>", { desc = "保存文件 (Save file)" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "退出 (Quit)" })
map("n", "<leader>wq", "<cmd>wq<cr>", { desc = "保存并退出 (Save and quit)" })

-- 全选
map("n", "<C-a>", "ggVG", { desc = "全选 (Select all)" })

-- 复制到系统剪贴板
map("v", "<leader>y", '"+y', { desc = "复制到系统剪贴板 (Yank to system clipboard)" })
map("n", "<leader>Y", '"+Y', { desc = "复制整行到系统剪贴板 (Yank line to system clipboard)" })

-- 从系统剪贴板粘贴
map("n", "<leader>p", '"+p', { desc = "从系统剪贴板粘贴 (Paste from system clipboard)" })
map("v", "<leader>p", '"+p', { desc = "从系统剪贴板粘贴 (Paste from system clipboard)" })

-- ============================================
-- 缓冲区管理
-- ============================================

-- 缓冲区导航
map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "下一个缓冲区 (Next buffer)" })
map("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "上一个缓冲区 (Previous buffer)" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "删除缓冲区 (Delete buffer)" })

-- 标签页管理
map("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "新建标签页 (New tab)" })
map("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "关闭标签页 (Close tab)" })
map("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "只保留当前标签页 (Keep only current tab)" })

-- ============================================
-- 窗口管理（分屏）
-- ============================================

-- 分屏
map("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "垂直分屏 (Vertical split)" })
map("n", "<leader>sh", "<cmd>split<cr>", { desc = "水平分屏 (Horizontal split)" })
map("n", "<leader>se", "<C-w>=", { desc = "均分窗口大小 (Equalize window sizes)" })
map("n", "<leader>sx", "<cmd>close<cr>", { desc = "关闭当前窗口 (Close current window)" })

-- 窗口导航
map("n", "<C-h>", "<C-w>h", { desc = "移动到左侧窗口 (Move to left window)" })
map("n", "<C-j>", "<C-w>j", { desc = "移动到下方窗口 (Move to lower window)" })
map("n", "<C-k>", "<C-w>k", { desc = "移动到上方窗口 (Move to upper window)" })
map("n", "<C-l>", "<C-w>l", { desc = "移动到右侧窗口 (Move to right window)" })

-- 窗口大小调整
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "增加窗口高度 (Increase window height)" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "减少窗口高度 (Decrease window height)" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "减少窗口宽度 (Decrease window width)" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "增加窗口宽度 (Increase window width)" })

-- ============================================
-- 搜索和导航
-- ============================================

-- 清除搜索高亮
map("n", "<leader>nh", "<cmd>nohl<cr>", { desc = "清除搜索高亮 (Clear search highlights)" })

-- 保持搜索居中
map("n", "n", "nzzzv", { desc = "下一个搜索结果（居中） (Next search result centered)" })
map("n", "N", "Nzzzv", { desc = "上一个搜索结果（居中） (Previous search result centered)" })

-- 快速跳转到行首行尾
map("n", "H", "^", { desc = "跳转到行首 (Go to line start)" })
map("n", "L", "$", { desc = "跳转到行尾 (Go to line end)" })

-- ============================================
-- 代码编辑
-- ============================================

-- 快速注释（需要 Comment.nvim 插件）
map("n", "<leader>/", "gcc", { desc = "注释/取消注释行 (Toggle line comment)", remap = true })
map("v", "<leader>/", "gc", { desc = "注释/取消注释选中 (Toggle selection comment)", remap = true })

-- 代码格式化
map("n", "<leader>cf", function()
    vim.lsp.buf.format({ async = true })
end, { desc = "格式化代码 (Format code)" })

-- ============================================
-- 文件操作
-- ============================================

-- 创建新文件
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "新建文件 (New file)" })

-- 重新加载文件
map("n", "<leader>fr", "<cmd>e!<cr>", { desc = "重新加载文件 (Reload file)" })

local function diff_unsaved()
    local source_buf = vim.api.nvim_get_current_buf()
    local source_win = vim.api.nvim_get_current_win()
    local file_path = vim.api.nvim_buf_get_name(source_buf)

    if file_path == "" then
        vim.notify("当前缓冲区没有文件路径，无法比较未保存改动", vim.log.levels.WARN)
        return
    end

    if vim.fn.filereadable(file_path) ~= 1 then
        vim.notify("磁盘文件不存在，无法比较未保存改动: " .. file_path, vim.log.levels.WARN)
        return
    end

    if not vim.bo[source_buf].modified then
        vim.notify("当前文件没有未保存改动", vim.log.levels.INFO)
        return
    end

    vim.cmd("rightbelow vertical new")
    local disk_win = vim.api.nvim_get_current_win()
    local disk_buf = vim.api.nvim_get_current_buf()

    vim.bo[disk_buf].buftype = "nofile"
    vim.bo[disk_buf].bufhidden = "wipe"
    vim.bo[disk_buf].swapfile = false
    vim.bo[disk_buf].filetype = vim.bo[source_buf].filetype
    vim.api.nvim_buf_set_name(disk_buf, "disk://" .. disk_buf .. ":" .. file_path)

    local lines = vim.fn.readfile(file_path)
    vim.api.nvim_buf_set_lines(disk_buf, 0, -1, false, lines)
    vim.bo[disk_buf].modifiable = false

    vim.cmd("diffthis")
    vim.api.nvim_set_current_win(source_win)
    vim.cmd("diffthis")
    vim.api.nvim_set_current_win(source_win)

    vim.notify("已打开未保存改动 diff。关闭窗口或执行 :diffoff! 可退出。", vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("DiffUnsaved", diff_unsaved, {
    desc = "查看未保存改动 (Diff unsaved changes)",
    force = true,
})

map("n", "<leader>du", "<cmd>DiffUnsaved<cr>", { desc = "查看未保存改动 (Diff unsaved changes)" })

-- 显示文件路径
map("n", "<leader>fp", function()
    local filepath = vim.fn.expand("%:p")
    vim.notify(filepath, vim.log.levels.INFO)
    vim.fn.setreg("+", filepath)
end, { desc = "显示并复制文件路径 (Show and copy file path)" })

-- ============================================
-- 实用工具
-- ============================================

-- 切换行号
map("n", "<leader>ln", function()
    vim.opt.number = not vim.opt.number:get()
end, { desc = "切换行号显示 (Toggle line numbers)" })

-- 切换相对行号
map("n", "<leader>lr", function()
    vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, { desc = "切换相对行号显示 (Toggle relative line numbers)" })

-- 切换自动换行
map("n", "<leader>lw", function()
    vim.opt.wrap = not vim.opt.wrap:get()
end, { desc = "切换自动换行 (Toggle line wrap)" })

-- 快速编辑配置文件
map("n", "<leader>ev", function()
    vim.cmd("edit " .. vim.fn.stdpath("config") .. "/init.lua")
end, { desc = "编辑配置文件 (Edit config file)" })


-- ============================================
-- 诊断快捷键（LSP 相关）
-- ============================================

-- 诊断导航
map("n", "<leader>dj", vim.diagnostic.goto_next, { desc = "下一个诊断 (Next diagnostic)" })
map("n", "<leader>dk", vim.diagnostic.goto_prev, { desc = "上一个诊断 (Previous diagnostic)" })
map("n", "<leader>dl", vim.diagnostic.open_float, { desc = "显示诊断信息 (Show diagnostic details)" })
map("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "诊断列表 (Diagnostic location list)" })

-- ============================================
-- 快速修复和列表
-- ============================================

-- QuickFix 列表
map("n", "<leader>qo", "<cmd>copen<cr>", { desc = "打开 QuickFix 列表 (Open quickfix list)" })
map("n", "<leader>qc", "<cmd>cclose<cr>", { desc = "关闭 QuickFix 列表 (Close quickfix list)" })
map("n", "<leader>qn", "<cmd>cnext<cr>", { desc = "QuickFix 下一项 (Next quickfix item)" })
map("n", "<leader>qp", "<cmd>cprev<cr>", { desc = "QuickFix 上一项 (Previous quickfix item)" })

-- Location 列表
map("n", "<leader>lo", "<cmd>lopen<cr>", { desc = "打开 Location 列表 (Open location list)" })
map("n", "<leader>lc", "<cmd>lclose<cr>", { desc = "关闭 Location 列表 (Close location list)" })
map("n", "<leader>lj", "<cmd>lnext<cr>", { desc = "Location 下一项 (Next location item)" })
map("n", "<leader>lk", "<cmd>lprev<cr>", { desc = "Location 上一项 (Previous location item)" })

-- ============================================
-- 其他实用快捷键
-- ============================================

-- 禁用方向键（强制使用 hjkl）
map("n", "<Up>", "<Nop>", { desc = "禁用上方向键 (Disable up arrow)" })
map("n", "<Down>", "<Nop>", { desc = "禁用下方向键 (Disable down arrow)" })
map("n", "<Left>", "<Nop>", { desc = "禁用左方向键 (Disable left arrow)" })
map("n", "<Right>", "<Nop>", { desc = "禁用右方向键 (Disable right arrow)" })

-- telescope plugin
map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = '查找文件 (Find files)' })
map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = '全文搜索 (Live grep)' })
map('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { desc = '搜索缓冲区 (Find buffers)' })
map('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { desc = '搜索帮助标签 (Find help tags)' })

-- 快速替换
map("n", "<leader>rw", ":%s/\\<<C-r><C-w>\\>/", { desc = "替换当前单词 (Replace current word)" })


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
map("n", "K", "<cmd>Lspsaga hover_doc<cr>", { desc = "悬浮文档 (Hover documentation)" })
map("n", "<leader>gd", "<cmd>Lspsaga goto_definition<cr>", { desc = "跳转到定义 (Go to definition)" })
map("n", "<leader>gf", "<cmd>Lspsaga finder<cr>", { desc = "LSP 查找 (LSP finder)" })
map("n", "<leader>t", "<cmd>Lspsaga term_toggle<cr>", { desc = "子终端 (Toggle terminal)" })
map("n", "<leader>ic", "<cmd>Lspsaga incoming_calls<cr>", { desc = "查看传入调用 (Incoming calls)" })
map("n", "<leader>oc", "<cmd>Lspsaga outgoing_calls<cr>", { desc = "查看传出调用 (Outgoing calls)" })
map("n", "<leader>sr", "<cmd>Lspsaga finder ref<cr>", { desc = "查看符号引用 (Symbol references)" })


-- formatter
map("n", "<leader>F", "<cmd>Format<cr>", { desc = "格式化代码 (Format code)" })

-- Git 相关快捷键
vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "打开 LazyGit (Open LazyGit)" })
vim.keymap.set("n", "<leader>gh", ":DiffviewFileHistory<CR>", { desc = "查看提交历史 (View file history)" })
vim.keymap.set("n", "<leader>gD", ":DiffviewOpen<CR>", { desc = "查看 Git diff (View Git diff)" })
vim.keymap.set("n", "<leader>gb", ":Git blame<CR>", { desc = "查看 Git blame (View Git blame)" })

-- 显示快捷键帮助
map("n", "<leader>?", function()
    vim.cmd("help")
end, { desc = "显示帮助 (Show help)" })

-- ============================================
-- 自定义命令
-- ============================================

-- 创建一些有用的命令
vim.api.nvim_create_user_command("ReloadConfig", function()
    local modules = {
        "configs.options",
        "configs.keymaps",
        "configs.lsp",
    }

    for _, name in ipairs(modules) do
        package.loaded[name] = nil
        require(name)
    end

    vim.notify("配置已重新加载!", vim.log.levels.INFO)
end, { desc = "重新加载配置 (Reload config)", force = true })

vim.api.nvim_create_user_command("ShowKeymaps", function()
    vim.cmd("Telescope keymaps")
end, { desc = "显示所有快捷键 (Show all keymaps)", force = true })

-- 添加快捷键来调用这些命令
map("n", "<leader>rc", "<cmd>ReloadConfig<cr>", { desc = "重新加载配置 (Reload config)" })
map("n", "<leader>sk", "<cmd>ShowKeymaps<cr>", { desc = "显示快捷键 (Show keymaps)" })
