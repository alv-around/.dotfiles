return {
	"mrcjkb/rustaceanvim",
	version = "^5", -- Recommended
	lazy = false, -- This plugin is already lazy
	opts = {
		-- This is the main configuration table for rustaceanvim
		server = {
			-- These are the settings passed directly to rust-analyzer LSP server
			settings = {
				["rust-analyzer"] = {
					procMacro = {
						enable = true, -- Ensure proc macros are enabled (should be default)
					},
					diagnostics = {
						-- **USE WITH CAUTION:** Disables specific diagnostic codes
						-- Only use if you are certain these are false positives and your code compiles.
						disabled = {
							"unresolved-proc-macro", -- Often appears with macro issues
							"macro-error", -- This is the specific error you're seeing
						},
						-- You might also try:
						-- enable = true, -- Ensure diagnostics are generally enabled
						-- experimental = {
						--   "displayInlayHints" -- Example of another diagnostic setting
						-- }
					},
					cargo = {
						-- Use a dedicated target directory for rust-analyzer's internal builds.
						-- This can sometimes prevent caching issues or conflicts with `cargo build`.
						targetDir = "target/rust-analyzer",
						-- You can also set features here if needed, e.g.:
						-- features = { "some-feature" },
						-- allFeatures = false,
						-- noDefaultFeatures = false,
					},
					-- Other rust-analyzer settings can go here if you need them
					-- inlayHints = {
					--   enable = true,
					--   -- ... other inlay hint settings
					-- },
					-- lens = {
					--   enable = true,
					--   -- ... other lens settings
					-- },
				},
			},
			-- You can also set capabilities, on_attach, etc., here if needed
			-- capabilities = require("cmp_nvim_lsp").default_capabilities(),
			-- on_attach = function(client, bufnr)
			--   -- your on_attach function
			-- end,
		},
		-- Other rustaceanvim specific options (not directly rust-analyzer settings)
		tools = {
			inlay_hints = {
				-- configure inlay hints if desired
				auto = true,
			},
			-- ... other tool options
		},
	},
}
