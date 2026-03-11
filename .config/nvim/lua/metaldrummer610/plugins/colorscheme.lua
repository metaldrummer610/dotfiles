return {
  "folke/tokyonight.nvim",
  priority = 1000, -- load before all other plugins
  config = function()
    require("tokyonight").setup({
      style = "night",
    })
    vim.cmd.colorscheme("tokyonight")
  end,
}
