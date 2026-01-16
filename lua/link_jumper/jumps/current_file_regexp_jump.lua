local CurrentFileRegexpJump = {}
CurrentFileRegexpJump.__index = CurrentFileRegexpJump

local CURRENT_WINDOW_ID = 0
local NO_MATCH_FOR_REGEXP = 0
local FIRST_LINE_INDEX = 1
local FIRST_CHARACTER_INDEX = 0

function CurrentFileRegexpJump.new(nvim_api, nvim_functions_api, searched_regexp)
    local self = setmetatable({}, CurrentFileRegexpJump)

    self.nvim_api = nvim_api
    self.regexp = searched_regexp
    self.nvim_funcs = nvim_functions_api

    return self
end

function CurrentFileRegexpJump:to_external_app()
    return false
end

function CurrentFileRegexpJump.class_name()
    return 'CurrentFileRegexpJump'
end

function CurrentFileRegexpJump:within_current_file()
    return true
end

-- @throws Error, when no match found for non-empty regexp
function CurrentFileRegexpJump:go()
    if self.regexp == '' then
        error('Empty string cannot be used as regexp value')
    end

    local original_position = self.nvim_api:nvim_win_get_cursor(CURRENT_WINDOW_ID)
    self.nvim_api:nvim_win_set_cursor(CURRENT_WINDOW_ID, {FIRST_LINE_INDEX, FIRST_CHARACTER_INDEX})
    local found_line_num = self.nvim_funcs:search(self.regexp)

    if found_line_num == NO_MATCH_FOR_REGEXP then
        self.nvim_api:nvim_win_set_cursor(CURRENT_WINDOW_ID, original_position)

        error('Cannot find text referred by the link', 0)
    else
        self.nvim_funcs:setreg('/', self.regexp)
    end
end

return CurrentFileRegexpJump
