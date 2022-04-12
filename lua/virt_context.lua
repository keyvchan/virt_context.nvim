local M = {}

local ns_id = vim.api.nvim_create_namespace("context")
local group = vim.api.nvim_create_augroup("context", { clear = true })
local id = {}
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
M.update_context_top = function()
	local context = require("nvim-treesitter").statusline()
	if context ~= nil then
		local win = vim.api.nvim_get_current_win()
		local cursor = vim.api.nvim_win_get_cursor(win)
		if id ~= nil then
			vim.api.nvim_buf_del_extmark(0, ns_id, id)
		end

		id = vim.api.nvim_buf_set_extmark(0, ns_id, cursor[1], 0, {
			virt_lines = { { { context, "Comment" } } },
			virt_lines_above = true,
			virt_lines_leftcol = true,
		})
	end
end

M.setup = function(opts)
	opts = opts or {}
	if opts.enable == true then
		local update_context
		if opts.position == "top" then
			update_context = M.update_context_top
		else
			update_context = M.update_context_eol
		end
		vim.api.nvim_create_autocmd("CursorMoved", {
			group = group,
			callback = update_context,
		})
	end
end

return M
