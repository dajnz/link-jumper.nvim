local FileLineNumJump = {}
FileLineNumJump.__index = FileLineNumJump

local FileJump = require('link_jumper.jumps.file_jump')

local CURRENT_WINDOW_ID = 0
local CURRENT_BUFFER_ID = 0

function FileLineNumJump.new(file_jump, line_number, nvim_api)
    local self = setmetatable({}, FileLineNumJump)

    self.api = nvim_api
    self.file_jump = file_jump
    self.line_num = line_number

    return self
end

function FileLineNumJump.new_for_file_path(path, line_number, nvim_api, nvim_functions_api)
    return FileLineNumJump.new(
        FileJump.new(path, nvim_api, nvim_functions_api),
        line_number,
        nvim_api
    )
end

function FileLineNumJump.class_name()
    return 'FileLineNumJump'
end

function FileLineNumJump:to_external_app()
    return false
end

function FileLineNumJump:within_current_file()
    return false
end

function FileLineNumJump:go()
    local success = pcall(function()
        self.file_jump:go()
    end)

    if success then
        local line_to_go = math.min(self.api:nvim_buf_line_count(CURRENT_BUFFER_ID), self.line_num)
        self.api:nvim_win_set_cursor(CURRENT_WINDOW_ID, {line_to_go, 0})
    end
end

return FileLineNumJump
