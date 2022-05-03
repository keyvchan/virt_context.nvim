local M = {}

local ns_id = vim.api.nvim_create_namespace("context")
local group = vim.api.nvim_create_augroup("context", { clear = true })
local id = nil
local last_cursor_postion = {}

M.update_context_eol = function()
  local context = require("nvim-treesitter").statusline()
  if context ~= nil then
    local win = vim.api.nvim_get_current_win()
    local cursor = vim.api.nvim_win_get_cursor(win)
    if cursor[1] == last_cursor_postion[1] then
      return
    else
      last_cursor_postion = cursor
    end
    if id ~= nil then
      vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
    end

    id = vim.api.nvim_buf_set_extmark(0, ns_id, cursor[1] - 1, 0, {
      virt_text = { { context, "Comment" } },
      virt_text_pos = "eol",
    })
  end
end
M.update_context_top = function(above)
  local context = require("nvim-treesitter").statusline()
  if context ~= nil then
    local win = vim.api.nvim_get_current_win()
    local cursor = vim.api.nvim_win_get_cursor(win)
    if cursor[1] == last_cursor_postion[1] then
      return
    else
      last_cursor_postion = cursor
    end
    if id ~= nil then
      vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
    end

    local info = vim.fn.getwininfo(win)
    local topline = info[1]["topline"]

    id = vim.api.nvim_buf_set_extmark(0, ns_id, topline - 1, 0, {
      virt_lines = { { { context, "Comment" } } },
      virt_lines_above = above,
      virt_lines_leftcol = true,
    })
  end
end

M.update_context_bottom = function(position)
  local context = require("nvim-treesitter").statusline()
  if context ~= nil then
    local win = vim.api.nvim_get_current_win()
    local cursor = vim.api.nvim_win_get_cursor(win)
    if cursor[1] == last_cursor_postion[1] then
      return
    else
      last_cursor_postion = cursor
    end
    if id ~= nil then
      vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
    end

    id = vim.api.nvim_buf_set_extmark(0, ns_id, position, 0, {
      virt_lines = { { { context, "Comment" } } },
      virt_lines_above = true,
      virt_lines_leftcol = true,
    })
  end
end
local last_win_bottom = 0

M.setup = function(opts)
  opts = opts or {}
  if opts.enable == true then
    local update_context
    if opts.position == "top" then
      update_context = M.update_context_top
    elseif opts.position == "bottom" then
      update_context = M.update_context_bottom
    else
      update_context = M.update_context_eol
    end
    vim.api.nvim_create_autocmd({ "BufWinEnter", "CursorMoved" }, {
      group = group,
      callback = function(params)
        local win = vim.api.nvim_get_current_win()
        local info = vim.fn.getwininfo(win)
        local endline = info[1]["botline"]
        if params.event == "BufWinEnter" then
          endline = endline - 1
        else
          if endline < last_win_bottom then
            endline = endline - 1
          else
            endline = endline
          end
        end
        last_win_bottom = endline
        update_context(endline)
      end,
    })
  end
end

return M
