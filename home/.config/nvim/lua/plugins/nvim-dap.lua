return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
		"nvim-neotest/nvim-nio",
		"williamboman/mason.nvim",
	},
	config = function()
		local dap, dapui = require("dap"), require("dapui")
		dapui.setup()

		-- Signs
		local sign = vim.fn.sign_define

		local dap_round_groups = { "DapBreakpoint", "DapBreakpointCondition", "DapBreakpointRejected", "DapLogPoint" }
		for _, group in pairs(dap_round_groups) do
			sign(group, { text = "●", texthl = group })
		end

		-- Adapters
		-- C, C++, Rust
		dap.adapters.codelldb = {
			type = "server",
			port = "${port}",
			executable = {
				command = "codelldb",
				args = { "--port", "${port}" },
			},
		}

		-- Python
		dap.adapters.python = function(cb, config)
			if config.request == "attach" then
				---@diagnostic disable-next-line: undefined-field
				local port = (config.connect or config).port
				---@diagnostic disable-next-line: undefined-field
				local host = (config.connect or config).host or "localhost"
				cb({
					type = "server",
					port = assert(port, "`connect.port` is required for a python `attach` configuration"),
					host = host,
				})
			else
				cb({
					type = "executable",
					command = "debugpy-adapter",
				})
			end
		end
		-- JS, TS
		for _, js_adapter in pairs({ "pwa-node", "pwa-chrome" }) do
			dap.adapters[js_adapter] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "js-debug-adapter",
					args = { "${port}" },
				},
			}
		end

		-- Keymaps
		vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint)
		vim.keymap.set("n", "<leader>dg", dap.run_to_cursor)

		-- Eval var under cursor
		vim.keymap.set("n", "<leader>d?", function()
			require("dapui").eval(nil, { enter = true })
		end)

		vim.keymap.set("n", "<F7>", dap.continue)
		vim.keymap.set("n", "<F8>", dap.step_over)
		vim.keymap.set("n", "<F9>", dap.step_back)
		vim.keymap.set("n", "<F10>", dap.step_into)
		vim.keymap.set("n", "<F11>", dap.step_out)
		vim.keymap.set("n", "<F12>", dap.restart)

		-- open debug-ui with debugger
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end
	end,
}
