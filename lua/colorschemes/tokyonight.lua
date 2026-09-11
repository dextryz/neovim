require("tokyonight").setup({
  style = "night",        -- or "storm", "moon", "day"
  transparent = true,     -- ← This is the key line (disables setting any background color)
  styles = {
    sidebars = "transparent",
    floats = "transparent",
  },
})
