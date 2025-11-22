return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        files = {
          hidden = true,
          ignored = true,
        },
        grep = {
          hidden = true, -- Also search in hidden files
          ignored = false,
        },
      },
    },
  },
}
