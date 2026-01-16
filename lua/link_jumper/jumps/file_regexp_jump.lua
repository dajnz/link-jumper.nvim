local FileRegexpJump = {}
FileRegexpJump.__index = FileRegexpJump

local FileJump = require('link_jumper.jumps.file_jump')
local CurrentFileRegexpJump = require('link_jumper.jumps.current_file_regexp_jump')

local CURRENT_WINDOW = 0
local FIRST_LINE = 1
local FIRST_CUSOR_POS = 0

function FileRegexpJump.new(file_jump, regexp_jump, nvim_api)
    local self = setmetatable({}, FileRegexpJump)

    self.api = nvim_api
    self.file_jump = file_jump
    self.regexp_jump = regexp_jump

    return self;
end

function FileRegexpJump.new_for_file_with_regexp(abs_path, regexp, nvim_api, nvim_functions_api)
    return FileRegexpJump.new(
        FileJump.new(abs_path, nvim_api, nvim_functions_api),
        CurrentFileRegexpJump.new(nvim_api, nvim_functions_api, regexp),
        nvim_api
    )
end

function FileRegexpJump:to_external_app()
    return false
end

function FileRegexpJump.class_name()
    return 'FileRegexpJump'
end

function FileRegexpJump:within_current_file()
    return false
end

function FileRegexpJump:go()
    self.file_jump:go()

    local success, result = pcall(function ()
        self.regexp_jump:go()
    end)

    if not success then
        self.api:nvim_win_set_cursor(CURRENT_WINDOW, {FIRST_LINE, FIRST_CUSOR_POS})
    end
end

return FileRegexpJump
