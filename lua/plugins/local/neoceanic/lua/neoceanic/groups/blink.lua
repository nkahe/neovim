local M = {}

function M.get(base16, colors, _)

  local highlights = {
    BlinkCmpMenu                = { bg   = colors.black      },
    BlinkCmpMenuBorder          = { fg   = colors.grey_fg    },
    BlinkCmpMenuSelection       = { link = "PmenuSel",       bold = true },
    BlinkCmpScrollBarThumb      = { bg   = colors.grey       },
    BlinkCmpScrollBarGutter     = { bg   = colors.black2     },
    BlinkCmpLabel               = { fg   = colors.white      },
    BlinkCmpLabelDeprecated     = { fg   = colors.red,       strikethrough = true },
    BlinkCmpLabelMatch          = { fg   = colors.blue,      bold = true },
    BlinkCmpLabelDetail         = { fg   = colors.light_grey },
    BlinkCmpLabelDescription    = { fg   = colors.light_grey },
    BlinkCmpSource              = { fg   = colors.grey_fg    },
    BlinkCmpGhostText           = { fg   = colors.grey_fg    },
    BlinkCmpDoc                 = { bg   = colors.black      },
    BlinkCmpDocBorder           = { fg   = colors.grey_fg    },
    BlinkCmpDocSeparator        = { fg   = colors.grey       },
    BlinkCmpDocCursorLine       = { bg   = colors.one_bg     },
    BlinkCmpSignatureHelp       = { bg   = colors.black      },
    BlinkCmpSignatureHelpBorder = { fg   = colors.grey_fg    },
    BlinkCmpSignatureHelpActiveParameter = { fg = colors.blue, bold = true },
  }

  -- Kind highlights
  local kinds = {
    Constant      = base16.base09,
    Function      = base16.base0D,
    Identifier    = base16.base08,
    Field         = base16.base08,
    Variable      = base16.base0E,
    Snippet       = colors.red,
    Text          = base16.base0B,
    Structure     = base16.base0E,
    Type          = base16.base0A,
    Keyword       = base16.base07,
    Method        = base16.base0D,
    Constructor   = colors.blue,
    Folder        = base16.base07,
    Module        = base16.base0A,
    Property      = base16.base08,
    Enum          = colors.blue,
    Unit          = base16.base0E,
    Class         = colors.teal,
    File          = base16.base07,
    Interface     = colors.green,
    Color         = colors.white,
    Reference     = base16.base05,
    EnumMember    = colors.purple,
    Struct        = base16.base0E,
    Value         = colors.cyan,
    Event         = colors.yellow,
    Operator      = base16.base05,
    TypeParameter = base16.base08,
    Copilot       = colors.green,
    Codeium       = colors.vibrant_green,
    TabNine       = colors.baby_pink,
    SuperMaven    = colors.yellow,
  }

  for kind, color in pairs(kinds) do
    highlights["BlinkCmpKind" .. kind] = { fg = color }
  end

  return highlights
end

return M
