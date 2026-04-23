local M = {}

function M.setup()

  local colors = {
    background = "#010a0c",
    background_faint = "#31363b",
    background_intense = "#000000",

    color0 = "#232627",
    color0_faint = "#31363b",
    color0_intense = "#7f8c8d",

    color1 = "#ed1515",
    color1_faint = "#783228",
    color1_intense = "#c0392b",

    color2 = "#11d116",
    color2_faint = "#17a262",
    color2_intense = "#1cdc9a",

    color3 = "#f67400",
    color3_faint = "#b65619",
    color3_intense = "#fdbc4b",

    color4 = "#1d99f3",
    color4_faint = "#1b668f",
    color4_intense = "#3daee9",

    color5 = "#9b59b6",
    color5_faint = "#614a73",
    color5_intense = "#8e44ad",

    color6 = "#1abc9c",
    color6_faint = "#186c60",
    color6_intense = "#16a085",

    color7 = "#fcfcfc",
    color7_faint = "#63686d",
    color7_intense = "#ffffff",

    foreground = "#fcfcfc",
    foreground_faint = "#eff0f1",
    foreground_intense = "#ffffff",
  }

  for i = 0, 7 do
    vim.g["terminal_color_" .. i] = colors["color" .. i]
    vim.g["terminal_color_" .. (i + 8)] =
      colors["color" .. i .. "_intense"]
  end

end

return M
