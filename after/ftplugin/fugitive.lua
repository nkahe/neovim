
-- if require("lazy.core.plugin").has("mini.ai") then
--   local mini_ai = require("mini.ai")
--   mini_ai.disable()  -- disables all global keymaps for this buffer
-- end

vim.keymap.set("n", "<Tab>", "=", { buffer = 0, remap = true })
