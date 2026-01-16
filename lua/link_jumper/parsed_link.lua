local ParsedLink = {}
ParsedLink.__index = ParsedLink
local str = require('link_jumper.str')
local Path = require('link_jumper.path')
local utf8 = require('utf8.init'):init()

-- Parsed link path elements
local PARSED_PATH = 'path'
local PARSED_ANCHOR = 'anchor'

local function parse_link_text(link_text)
    local separator_pos = str.find_substring_pos(link_text, '#')
    local parse_result = { [PARSED_PATH] = '', [PARSED_ANCHOR] = '' }

    if separator_pos == 0 then
        -- Link has only path part
        parse_result[PARSED_PATH] = link_text
    else
        local parts = str.split(link_text, '#')

        if separator_pos == 1 then
            -- Link has only anchor part

            if #parts > 1 then
                -- Invalid link format, it should be single #
                return parse_result
            end

            parse_result[PARSED_ANCHOR] = parts[1]
        else
            -- Link has both parts
            parse_result[PARSED_PATH] = parts[1]

            if #parts == 2 then
                -- Only for valid link format we consider anchor as correct, it should be single #
                parse_result[PARSED_ANCHOR] = parts[2]
            end
        end
    end

    return parse_result
end

local function valid_url(some_text)
    local valid_protocol = str.starts_with(some_text, 'http://') or str.starts_with(some_text, 'https://')
    local position = utf8.find(some_text, '[^%s]+%.[^%s]+')

    return valid_protocol and position ~= nil
end


---------
-- Public stuff, exported from the module
---------

function ParsedLink.new(link_text, abs_paths)
    local self = setmetatable({}, ParsedLink)

    self.link_text = link_text
    self.abs_paths = abs_paths
    self.link_parts = parse_link_text(link_text:to_string())

    return self
end

function ParsedLink:absolute_path()
    if self.link_parts[PARSED_PATH] == '' then
        return ''
    end

    if valid_url(self.link_parts[PARSED_PATH]) then
        if self.link_parts[PARSED_ANCHOR] ~= '' then
            return self.link_parts[PARSED_PATH] .. '#' .. self.link_parts[PARSED_ANCHOR]
        end

        return self.link_parts[PARSED_PATH]
    end

    return (Path.new(self.link_parts[PARSED_PATH], self.abs_paths)):to_absolute()
end

function ParsedLink:anchor_search_pattern()
    if self.link_parts[PARSED_ANCHOR] == '' then
        return ''
    end

    if valid_url(self.link_parts[PARSED_PATH]) then
        return ''
    end

    local anchor = self.link_parts[PARSED_ANCHOR]

    return string.gsub(anchor, '-', '\\(\\s\\|\\-\\)\\+')
end

function ParsedLink:internal_file_link()
    return self.link_parts[PARSED_ANCHOR] ~= '' and self.link_parts[PARSED_PATH] == ''
end

function ParsedLink:external_file_link()
    return self.link_parts[PARSED_PATH] ~= '' and valid_url(self.link_parts[PARSED_PATH]) == false
end

function ParsedLink:web_link()
    return valid_url(self.link_parts[PARSED_PATH])
end

return ParsedLink
