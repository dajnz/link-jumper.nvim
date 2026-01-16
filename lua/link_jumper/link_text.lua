local LinkText = {}
LinkText.__index = LinkText
local utf8 = require('utf8.init'):init()

local CURRENT_BUFFER = 0

local function find_link_text(line_of_text, cursor_pos)
    local start_pos, end_pos, link_text = utf8.find(line_of_text, '%[.+%]%((.+)%)')

    if link_text == nil then
        return ''
    end

    -- checking if a cursor within a link substring
    -- Lua string indices are 1-based, but nvim cursor pos is zero-based
    if cursor_pos < (start_pos - 1) or cursor_pos > (end_pos - 1) then
        return ''
    end

    return link_text
end


---------
-- Public stuff, exported from the module
---------

function LinkText.new(nvim_api, nvim_functions_api)
    local self = setmetatable({}, LinkText)

    self.api = nvim_api
    self.nvim_funcs = nvim_functions_api

    return self
end

function LinkText:to_string()
    unpack = unpack or table.unpack
    local line_num, cursor_byte_pos = unpack(self.api:nvim_win_get_cursor(CURRENT_BUFFER))
    local found_lines = self.api:nvim_buf_get_lines(CURRENT_BUFFER, line_num - 1, line_num, true)

    if #found_lines <= 0 then
        return ''
    end

    local current_line = found_lines[1]
    local cursor_char_pos = self.nvim_funcs:charidx(current_line, cursor_byte_pos)

    return find_link_text(current_line, cursor_char_pos)
end


return LinkText
