-- module represents a lua module for the plugin
local M = {}

local deepl_buffer = "__DEEPLER__"

local function create_buffer()
  local buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_buf_set_name(buf, deepl_buffer)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  return buf
end

local function get_deepl_buffer()
  local bufId = vim.fn.bufnr(deepl_buffer)
  local buf = nil
  if bufId == -1 then
    buf = create_buffer()
    vim.cmd("vsplit")
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buf)
  else
    local wins = vim.fn.win_findbuf(bufId)
    if #wins > 0 then
      vim.fn.win_gotoid(wins[1])
    else
      vim.cmd("b " .. bufId)
    end
    local win = vim.api.nvim_get_current_win()
    buf = vim.api.nvim_win_get_buf(win)
  end
  return buf
end

local function create_output_text(tb)
  local output = {}
  for index, value in ipairs(tb) do
    if #value > 0 then
      table.insert(output, value)
    end
  end
  return output
end

local function print_stdout(chan_id, data, name)
  local text = create_output_text(data)
  if #text ~= 0 then
    local buf = get_deepl_buffer()
    vim.api.nvim_buf_set_option(buf, "modifiable", true)
    vim.api.nvim_buf_set_lines(buf, -1, -1, true, text)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    add_text = {}
  end
end

M.ask = function(text)
  vim.fn.jobstart({ "deepl", text }, { on_stdout = print_stdout })
end

return M
