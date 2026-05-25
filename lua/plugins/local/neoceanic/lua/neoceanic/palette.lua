local M = {}

M.colors = {
  -- darkest_black = "#002626",
  darker_black  = "#15252e",
  black         = "#192830", -- Default bg color
  black2        = "#203038",
  one_bg        = "#25353e",
  one_bg2       = "#2e3e47",
  one_bg3       = "#36464f",
  grey          = "#43535c",
  grey_fg       = "#4d5d66",
  grey_fg2      = "#576770",
  light_grey    = "#738490",
  white         = "#D8DEE9", -- Default fg color

  red           = "#ec6770", -- "#EC5F67",
  baby_pink     = "#ff7d85",
  pink          = "#ffafb7",
  orange        = "#ed9b64",  -- Oceanic Next original: "#F99157"
  yellow        = "#FAC863",
  vibrant_green = "#b9e75b",
  green         = "#8fc189", -- "#99C794",
  cyan          = "#62B3B2",
  teal          = "#50a4a4",
  nord_blue     = "#598cbf",
  blue          = "#6699CC",
  purple        = "#C594C5",
  dark_purple   = "#ac7bac",

  heading       = "#FAC863",
  statusline_bg = "#203038",
}

M.theme = {
  base00 = M.colors.black,
  base01 = "#343D46",
  base02 = "#4F5B66",
  base03 = "#65737e",
  base04 = "#A7ADBa",
  base05 = "#C0C5Ce",
  base06 = "#CDD3De",
  base07 = M.colors.white,
  base08 = M.colors.cyan,
  base09 = M.colors.yellow,
  base0A = M.colors.orange,
  base0B = M.colors.green,
  base0C = M.colors.teal,
  base0D = M.colors.blue,
  base0E = M.colors.purple,
  base0F = M.colors.red
}

return M
