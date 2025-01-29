return {
	"mrcjkb/rustaceanvim",
	version = "^5", -- Recommended
	lazy = false, -- This plugin is already lazy
	opts = {
		default_settings = {
			["rust-analyzer"] = {
				diagnostics = {
					-- INFO: this line disable an anoying rust-analyzer error when using ark_ff
					disable = "proc-macro-panicked",
				},
			},
		},
	},
}
