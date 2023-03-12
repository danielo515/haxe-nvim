---@private
--- Get a single line or line range from the buffer.
--- If only start_lnum is specified, return a single line as a string.
--- If both start_lnum and end_lnum are omitted, return all lines from the buffer.
---
---@param bufnr number|nil The buffer to get the lines from
---@param start_lnum number|nil The line number of the first line (inclusive, 1-based)
---@param end_lnum number|nil The line number of the last line (inclusive, 1-based)
---@return table<string>|string Array of lines, or string when end_lnum is omitted
function M.getlines(bufnr, start_lnum, end_lnum)
	if end_lnum then
		-- Return a line range
		return api.nvim_buf_get_lines(bufnr, start_lnum - 1, end_lnum, false)
	end
	if start_lnum then
		-- Return a single line
		return api.nvim_buf_get_lines(bufnr, start_lnum - 1, start_lnum, false)[1] or ""
	else
		-- Return all lines
		return api.nvim_buf_get_lines(bufnr, 0, -1, false)
	end
end
