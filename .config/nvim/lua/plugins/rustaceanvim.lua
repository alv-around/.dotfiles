return {
	"mrcjkb/rustaceanvim",
	version = "^5", -- Recommended
	lazy = false, -- This plugin is already lazy
	opts = {
		default_settings = {
			["rust-analyzer"] = {
				-- INFO: this line disable an anoying rust-analyzer error when using ark_ff
				procMacro = {
					enable = false, -- Disable proc-macro support
				},
			},
		},
	},
}
