local FileCursorPosJump = {}
FileCursorPosJump.__index = FileCursorPosJump

local FileJump = require('link_jumper.jumps.file_jump')

local CURRENT_WINDOW_ID = 0
local CURSOR_POS_INDEX = 2
local LINE_NUM_INDEX = 1

function FileCursorPosJump.new(nvim_api, current_file_jump)
    local self = setmetatable({}, FileCursorPosJump)
    local position = nvim_api:nvim_win_get_cursor(CURRENT_WINDOW_ID)

    self.api = nvim_api
    self.line_num = position[LINE_NUM_INDEX]
    self.cursor_pos = position[CURSOR_POS_INDEX]
    self.file_jump = current_file_jump

    return self
end

function FileCursorPosJump.class_name()
    return 'FileCursorPosJump'
end

function FileCursorPosJump.new_for_current_file(nvim_api, nvim_functions_api)
    return FileCursorPosJump.new(nvim_api, FileJump.new_for_current_file(nvim_api, nvim_functions_api))
end

function FileCursorPosJump:to_external_app()
    return false
end

function FileCursorPosJump:within_current_file()
    return false
end

function FileCursorPosJump:go()
    self.file_jump:go()
    self.api:nvim_win_set_cursor(CURRENT_WINDOW_ID, {self.line_num, self.cursor_pos})
end

return FileCursorPosJump
