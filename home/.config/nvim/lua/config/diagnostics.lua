vim.diagnostic.config({
	-- Configure how diagnostics are displayed in floating windows
	float = {
		-- Border style for the floating window (e.g., "rounded", "single", "double", "none")
		border = "rounded",
		-- Highlight group for the border (optional)
		-- border_hl = "DiagnosticFloating",
		-- Determines how a long diagnostic message is displayed.
		-- Set to `true` to wrap lines within the floating window.
		wrap = true,
		-- Maximum width of the floating window. If `wrap` is true, lines will wrap within this width.
		-- Adjust this value based on your screen size and preference.
		-- A value of 0 means no explicit max width, and it will try to fit content.
		-- However, it's often good to set a reasonable max for wrapping.
		max_width = 80, -- Example: Limit float to 80 characters wide before wrapping
		-- If you want to customize the position of the float.
		-- Defaults to cursor position, which is usually fine.
		-- source = "always", -- Show source in the float
		-- suffix = " (LSP)", -- Add a suffix
		-- header = "", -- Add a header
	},
	-- Other diagnostic display options (not directly for float but related)
	underline = true, -- Underline diagnostics in the buffer
	signs = true, -- Show signs in the sign column
	virtual_text = false, -- Disable virtual text (often preferred if using floats)
	update_in_insert = false, -- Don't update diagnostics in insert mode
	severity_sort = true, -- Sort diagnostics by severity
})
