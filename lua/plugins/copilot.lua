return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter", -- 自动在进入插入模式加载
    config = function()
      require("copilot").setup({
        panel = {
          enabled = true, -- 显示建议面板
          auto_refresh = true,
        },
        suggestion = {
          enabled = true,
          auto_trigger = true, -- 自动显示建议
          debounce = 75,
          keymap = {
            accept = "<C-l>",  -- 接受建议
            next = "<C-]>",    -- 下一个建议
            prev = "<C-k>",    -- 上一个建议
            dismiss = "<C-/>", -- 取消
          },
        },
        filetypes = {
          ["*"] = true, -- 默认所有文件类型启用
        },
        server_opts_overrides = {},
      })
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    lazy = true,
    event = "VeryLazy",
    tag = "v4.7.4",
    dependencies = {
      { "zbirenbaum/copilot.lua" },                   -- github/copilot.vim or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken",                          -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
