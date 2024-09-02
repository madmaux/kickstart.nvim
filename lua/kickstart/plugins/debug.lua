-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
      },
    }

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<F4>', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<F6>', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })

    --   keys = {
    --     { "<leader>b", "", desc = "+debug", mode = {"n", "v"} },
    --     { "<leader>bB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
    --     { "<leader>bb", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    --     { "<leader>bc", function() require("dap").continue() end, desc = "Continue" },
    --     { "<leader>ba", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
    --     { "<leader>bC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    --     { "<leader>bg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
    --     { "<leader>bi", function() require("dap").step_into() end, desc = "Step Into" },
    --     { "<leader>bj", function() require("dap").down() end, desc = "Down" },
    --     { "<leader>bk", function() require("dap").up() end, desc = "Up" },
    --     { "<leader>bl", function() require("dap").run_last() end, desc = "Run Last" },
    --     { "<leader>bo", function() require("dap").step_out() end, desc = "Step Out" },
    --     { "<leader>bO", function() require("dap").step_over() end, desc = "Step Over" },
    --     { "<leader>bp", function() require("dap").pause() end, desc = "Pause" },
    --     { "<leader>br", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    --     { "<leader>bs", function() require("dap").session() end, desc = "Session" },
    --     { "<leader>bt", function() require("dap").terminate() end, desc = "Terminate" },
    --     { "<leader>bw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    --   }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }
  end,
}
