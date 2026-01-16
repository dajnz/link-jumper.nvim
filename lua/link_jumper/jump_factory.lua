local JumpFactory = {}
JumpFactory.__index = JumpFactory

local UrlJump = require('link_jumper.jumps.url_jump')
local FileRegexpJump = require('link_jumper.jumps.file_regexp_jump')
local FileLineNumJump = require('link_jumper.jumps.file_line_num_jump')
local FileCursorPosJump = require('link_jumper.jumps.file_cursor_pos_jump')
local CurrentFileRegexpJump = require('link_jumper.jumps.current_file_regexp_jump')

local function internal_file_link(link)
    return link:internal_file_link()
        and link:anchor_search_pattern() ~= ''
        and link:absolute_path() == ''
end

local function external_file_link(link)
    return link:absolute_path() ~= ''
        and link:web_link() == false
end

local function is_positive_int_string(some_string)
    local num_value = tonumber(some_string, 10)

    return num_value ~= nil and num_value > 0
end


-- Class public API

function JumpFactory.new(nvim_api, nvim_functions_api, nvim_ui_api, current_file_type)
    local self = setmetatable({}, JumpFactory)

    self.nvim_api = nvim_api
    self.nvim_ui_api = nvim_ui_api
    self.file_type = current_file_type
    self.nvim_functions_api = nvim_functions_api

    return self
end

function JumpFactory:make_link_jump(link)
    if internal_file_link(link) then
        return CurrentFileRegexpJump.new(
            self.nvim_api,
            self.nvim_functions_api,
            link:anchor_search_pattern()
        )
    elseif is_positive_int_string(link:anchor_search_pattern()) then
        return FileLineNumJump.new_for_file_path(
            link:absolute_path(),
            tonumber(link:anchor_search_pattern(), 10),
            self.nvim_api,
            self.nvim_functions_api
        )
    elseif external_file_link(link) then
        return FileRegexpJump.new_for_file_with_regexp(
            link:absolute_path(),
            link:anchor_search_pattern(),
            self.nvim_api,
            self.nvim_functions_api
        )
    elseif link:web_link() then
        return UrlJump.new(link:absolute_path(), self.nvim_ui_api)
    end
end

function JumpFactory:make_current_location_jump()
    if self.file_type ~= 'help' then
        return FileCursorPosJump.new_for_current_file(self.nvim_api, self.nvim_functions_api)
    end
end

return JumpFactory
