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

local function reset_modules(names)
    for _, name in ipairs(names) do
        package.loaded[name] = nil
        package.preload[name] = nil
    end
end

vim.env.TERMUX_VERSION = vim.env.TERMUX_VERSION or "test"

test("blink.cmp uses Lua fuzzy matching on Termux", function()
    reset_modules({ "plugins.blink-cmp" })

    local specs = require("plugins.blink-cmp")
    local spec = specs[1]

    assert_equal(spec.opts.fuzzy.implementation, "lua", "Termux must avoid the Rust fuzzy matcher binary")
end)

test("mason-lspconfig does not auto-install LSP packages on Termux", function()
    reset_modules({ "plugins.mason-lspconfig", "mason-lspconfig", "lspconfig" })

    local captured_mason_opts
    package.preload["mason-lspconfig"] = function()
        return {
            setup = function(opts)
                captured_mason_opts = opts
            end,
        }
    end

    package.preload["lspconfig"] = function()
        return setmetatable({}, {
            __index = function(t, server_name)
                local server = {
                    setup = function() end,
                }
                rawset(t, server_name, server)
                return server
            end,
        })
    end

    require("plugins.mason-lspconfig").config()

    assert_truthy(captured_mason_opts, "mason-lspconfig.setup must be called")
    assert_equal(#captured_mason_opts.ensure_installed, 0, "Termux must skip Mason ensure_installed")
    assert_equal(captured_mason_opts.automatic_installation, false, "Termux must disable Mason automatic_installation")
end)

test("Termux LSP setup uses PATH executables instead of Mason installs", function()
    reset_modules({ "plugins.mason-lspconfig", "mason-lspconfig", "lspconfig" })

    local configured_servers = {}
    package.preload["mason-lspconfig"] = function()
        return {
            setup = function() end,
        }
    end

    package.preload["lspconfig"] = function()
        return setmetatable({}, {
            __index = function(t, server_name)
                local server = {
                    setup = function(_, opts)
                        configured_servers[server_name] = opts or {}
                    end,
                }
                rawset(t, server_name, server)
                return server
            end,
        })
    end

    require("plugins.mason-lspconfig").config()

    for _, server_name in ipairs({ "gopls", "lua_ls", "bashls", "yamlls", "jsonls", "taplo", "buf_ls" }) do
        assert_truthy(configured_servers[server_name], "expected lspconfig setup for " .. server_name)
    end
end)

test("lazy.nvim update checker stays disabled on the fixed branch", function()
    local lazy_config = assert(io.open(root .. "/lua/configs/lazy.lua", "r"))
    local content = lazy_config:read("*a")
    lazy_config:close()

    assert_truthy(
        content:find("checker%s*=%s*{%s*enabled%s*=%s*false%s*}") ~= nil,
        "fixed branch must keep lazy.nvim checker disabled"
    )
end)

test("lazy-lock.json is trackable on the fixed branch", function()
    local lockfile = assert(io.open(root .. "/lazy-lock.json", "r"))
    lockfile:close()

    vim.fn.system({ "git", "check-ignore", "-q", "lazy-lock.json" })
    assert_equal(vim.v.shell_error, 1, "lazy-lock.json must not be ignored")
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
    error(string.format("%d Termux config check(s) failed", failed), 0)
end
