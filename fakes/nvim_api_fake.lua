local NvimApiFake = {}
NvimApiFake.__index = NvimApiFake

function NvimApiFake.new(line_text, cursor_pos, line_num, total_lines_num)
    local self = setmetatable({}, NvimApiFake)

    self.cmd = nil
    self.custom_buf_num = -1
    self.line_num = line_num ~= nil and line_num or 1
    self.line_text = line_text ~= nil and line_text or ''
    self.cursor_pos = cursor_pos ~= nil and cursor_pos or 0
    self.total_lines = total_lines_num ~= nil and total_lines_num or 100
    self.search_string = ''

    return self
end


-- API methods

function NvimApiFake:nvim_win_get_cursor(window_id)
    if window_id == 0 then
        return { self.line_num, self.cursor_pos }
    end

    return nil
end

function NvimApiFake:nvim_win_set_cursor(window_id, position)
    if window_id == 0 then
        self.line_num = position[1]
        self.cursor_pos = position[2]
    end
end

function NvimApiFake:nvim_buf_get_lines()
    if self.line_text == nil then
        return {}
    end

    return { self.line_text }
end

function NvimApiFake:nvim_set_current_buf(some_buf_num)
    self.custom_buf_num = some_buf_num
end

function NvimApiFake:nvim_cmd(command, options)
    self.cmd = command
end

function NvimApiFake:nvim_buf_line_count(buffer_id)
    return self.total_lines
end


-- Fake helper methods

function NvimApiFake:get_custom_buf_num()
    return self.custom_buf_num
end

function NvimApiFake:get_command()
    return self.cmd
end

function NvimApiFake:get_line_num()
    return self.line_num
end

function NvimApiFake:get_cursor_pos()
    return self.cursor_pos
end

function NvimApiFake:change_cursor_pos(cursor_pos, line_num)
    self.line_num = line_num
    self.cursor_pos = cursor_pos
end

function NvimApiFake:get_search_string()
    return self.search_string
end

return NvimApiFake
