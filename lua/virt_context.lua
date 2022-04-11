local M = {}

local ns_id = vim.api.nvim_create_namespace("context")
local group = vim.api.nvim_create_augroup("context", { clear = true })
local id

M.update_context = function()
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
	vim.api.nvim_create_autocmd("CursorMoved", {
		group = group,
		callback = M.update_context,
	})
end

return M
