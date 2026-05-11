local root = vim.fn.getcwd()
package.path = root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path

local tests = {}

local function test(name, fn)
    tests[#tests + 1] = { name = name, fn = fn }
end

local function assert_equal(actual, expected, message)
    if actual ~= expected then
        error(string.format("%s: expected %s, got %s", message, vim.inspect(expected), vim.inspect(actual)), 2)
    end
end

local function assert_truthy(value, message)
    if not value then
        error(message, 2)
    end
end

local function read_file(path)
    local file = assert(io.open(path, "r"))
    local content = file:read("*a")
    file:close()
    return content
end

local function list_lua_files()
    return vim.fn.glob(root .. "/lua/**/*.lua", false, true)
end

local function has_chinese(text)
    return text:find("[\228-\233][\128-\191][\128-\191]") ~= nil
end

local function has_english(text)
    return text:find("%a") ~= nil
end

local function has_bilingual_desc_shape(text)
    return text:find("%(") ~= nil and text:find("%)") ~= nil
end

test("all desc strings are bilingual", function()
    for _, file in ipairs(list_lua_files()) do
        local content = read_file(file)
        for quote, desc in content:gmatch("desc%s*=%s*([\"'])(.-)%1") do
            assert_truthy(has_chinese(desc), file .. " desc lacks Chinese: " .. desc)
            assert_truthy(has_english(desc), file .. " desc lacks English: " .. desc)
            assert_truthy(has_bilingual_desc_shape(desc), file .. " desc must use Chinese (English): " .. desc)
            assert_truthy(quote == '"' or quote == "'", "keeps luacheck quiet")
        end
    end
end)

test("direct keymap.set calls include desc", function()
    for _, file in ipairs(list_lua_files()) do
        local content = read_file(file)
        for line in content:gmatch("[^\n]+") do
            if line:find("vim%.keymap%.set%(")
                and not line:find("local function")
                and not line:find("vim%.keymap%.set%(mode, lhs, rhs, options%)")
                and not line:find("vim%.keymap%.set%(mode, lhs, rhs, opts%)")
                and not line:find("opts%(")
            then
                assert_truthy(line:find("desc%s*=") ~= nil, file .. " keymap.set lacks desc: " .. line)
            end
        end
    end
end)

test("line number and location list keymaps do not collide", function()
    package.loaded["configs.keymaps"] = nil
    require("configs.keymaps")

    assert_equal(vim.fn.maparg("<leader>ln", "n", false, true).desc, "切换行号显示 (Toggle line numbers)", "ln should toggle line numbers")
    assert_equal(vim.fn.maparg("<leader>lj", "n", false, true).desc, "Location 下一项 (Next location item)", "lj should go to next location item")
    assert_equal(vim.fn.maparg("<leader>lk", "n", false, true).desc, "Location 上一项 (Previous location item)", "lk should go to previous location item")
end)

test("unsaved diff keymap is explicit and U keeps default behavior", function()
    package.loaded["configs.keymaps"] = nil
    require("configs.keymaps")

    local diff_unsaved = vim.fn.maparg("<leader>du", "n", false, true)
    local undo = vim.fn.maparg("U", "n", false, true)
    local commands = vim.api.nvim_get_commands({})

    assert_equal(diff_unsaved.rhs, "<cmd>DiffUnsaved<cr>", "du should open unsaved diff")
    assert_equal(diff_unsaved.desc, "查看未保存改动 (Diff unsaved changes)", "du desc should explain unsaved diff")
    assert_equal(undo.rhs, nil, "U should keep Neovim default line-undo behavior")
    assert_truthy(commands.DiffUnsaved ~= nil, "DiffUnsaved command must exist")
end)

test("DiffUnsaved opens a persistent diff split", function()
    package.loaded["configs.keymaps"] = nil
    require("configs.keymaps")

    local original_cwd = vim.fn.getcwd()
    local path = "/tmp/lemon-nvim-diff-unsaved-test.txt"
    vim.fn.writefile({ "disk line" }, path)

    local ok, err = pcall(function()
        vim.cmd("edit " .. vim.fn.fnameescape(path))
        local source_buf = vim.api.nvim_get_current_buf()
        vim.api.nvim_buf_set_lines(source_buf, 0, -1, false, { "buffer line" })

        vim.cmd("DiffUnsaved")

        local current_win = vim.api.nvim_get_current_win()
        local current_buf = vim.api.nvim_get_current_buf()
        local wins = vim.api.nvim_tabpage_list_wins(0)
        assert_truthy(#wins >= 2, "DiffUnsaved must open another window")
        assert_equal(vim.wo[current_win].diff, true, "source window must enter diff mode")

        local disk_buf
        for _, win in ipairs(wins) do
            local bufnr = vim.api.nvim_win_get_buf(win)
            if bufnr ~= current_buf then
                disk_buf = bufnr
                assert_equal(vim.wo[win].diff, true, "disk window must enter diff mode")
                break
            end
        end

        assert_truthy(disk_buf ~= nil, "DiffUnsaved must create disk buffer")
        assert_equal(vim.bo[disk_buf].buftype, "nofile", "disk buffer must be scratch")
        assert_equal(vim.api.nvim_buf_get_lines(disk_buf, 0, -1, false)[1], "disk line", "disk buffer must show saved file")
    end)

    vim.cmd("silent! diffoff!")
    vim.cmd("silent! %bwipeout!")
    vim.cmd("cd " .. vim.fn.fnameescape(original_cwd))
    vim.fn.delete(path)

    if not ok then
        error(err, 0)
    end
end)

test("nvim-tree directory root keymaps update cwd", function()
    package.loaded["plugins.nvim-tree"] = nil
    package.loaded["nvim-tree"] = nil
    package.loaded["nvim-tree.api"] = nil

    local test_root = "/tmp/lemon-nvim-tree-root-test"
    local selected_dir = test_root .. "/sub"
    vim.fn.mkdir(selected_dir, "p")

    local captured_setup
    local default_attach_bufnr
    local changed_node
    local changed_root
    local selected_node = {
        type = "directory",
        absolute_path = selected_dir,
    }

    package.preload["nvim-tree"] = function()
        return {
            setup = function(opts)
                captured_setup = opts
            end,
        }
    end

    package.preload["nvim-tree.api"] = function()
        return {
            config = {
                mappings = {
                    default_on_attach = function(bufnr)
                        default_attach_bufnr = bufnr
                    end,
                },
            },
            tree = {
                get_node_under_cursor = function()
                    return selected_node
                end,
                get_nodes = function()
                    return selected_node
                end,
                change_root_to_node = function(node)
                    changed_node = node
                end,
                change_root = function(path)
                    changed_root = path
                end,
            },
        }
    end

    local original_keymap_set = vim.keymap.set
    local original_cwd = vim.fn.getcwd()
    local keymaps = {}

    vim.keymap.set = function(mode, lhs, rhs, opts)
        keymaps[lhs] = { mode = mode, rhs = rhs, opts = opts }
    end

    local ok, err = pcall(function()
        require("plugins.nvim-tree")[2].config()
        assert_truthy(captured_setup and type(captured_setup.on_attach) == "function", "nvim-tree setup must define on_attach")

        local bufnr = vim.api.nvim_create_buf(false, true)
        captured_setup.on_attach(bufnr)

        assert_equal(default_attach_bufnr, bufnr, "nvim-tree default mappings must stay enabled")
        assert_truthy(keymaps.C and type(keymaps.C.rhs) == "function", "C must set selected directory as root")
        assert_equal(keymaps.C.opts.desc, "nvim-tree: 设置当前目录 (Set current directory)", "C desc must explain root change")
        assert_truthy(keymaps["-"] and type(keymaps["-"].rhs) == "function", "- must move root to parent")
        assert_equal(keymaps["-"].opts.desc, "nvim-tree: 返回上级目录 (Go to parent directory)", "- desc must explain parent root")

        keymaps.C.rhs()
        assert_equal(vim.fn.getcwd(), selected_dir, "C must update Neovim cwd")
        assert_equal(changed_node, selected_node, "C must update nvim-tree root to selected node")

        keymaps["-"].rhs()
        assert_equal(vim.fn.getcwd(), test_root, "- must update Neovim cwd to parent")
        assert_equal(changed_root, test_root, "- must update nvim-tree root to parent")
    end)

    vim.keymap.set = original_keymap_set
    vim.cmd("cd " .. vim.fn.fnameescape(original_cwd))
    package.preload["nvim-tree"] = nil
    package.preload["nvim-tree.api"] = nil

    if not ok then
        error(err, 0)
    end
end)

local failed = 0
for _, entry in ipairs(tests) do
    local ok, err = pcall(entry.fn)
    if ok then
        print("ok - " .. entry.name)
    else
        failed = failed + 1
        print("not ok - " .. entry.name)
        print("  " .. tostring(err):gsub("\n", "\n  "))
    end
end

if failed > 0 then
    error(string.format("%d keymap check(s) failed", failed), 0)
end
