package.loaded["deepler"] = nil
package.loaded["deepler.module"] = nil

vim.api.nvim_create_user_command("Deepler", function(args)
  require("deepler").ask(args)
end, { nargs = "?", range = true })
