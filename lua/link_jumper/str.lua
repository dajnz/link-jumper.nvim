---------
-- String utils
---------

local M = {}
local utf8 = require('utf8.init'):init()
local utils = require('link_jumper.utils')

local function escape_regexp_characters(some_string)
    local escaped_string = ''
    local special_characters = { '.', '$', '^', '(', ')', '%', '[', ']', '*', '+', '-', '?' }

    for i = 1, #some_string do
        local character = utf8.sub(some_string, i, i)

        if utils.array_includes(special_characters, character) then
            escaped_string = escaped_string .. '%' .. character
        else
            escaped_string = escaped_string .. character
        end
    end

    return escaped_string
end


local function build_separator_regexp_pattern(separator_string)
    -- splitting by whitespaces by default
    if separator_string == nil or separator_string == '' or type(separator_string) ~= 'string' then
        return '(%s+)'
    end

    return '(' .. escape_regexp_characters(separator_string) .. ')'
end


---------
-- Public stuff, exported from the module
---------

-- Find position of first occurrence of searched_sub_string in some_string
-- @param string some_string
-- @param string searched_sub_string
-- @return number
function M.find_substring_pos(some_string, searched_sub_string)
    local position = utf8.find(some_string, escape_regexp_characters(searched_sub_string))

    if position == nil then
        return 0
    end

    return position
end

-- Checks if some_string starts with searched_sub_string
-- @param string some_string What should have searched_sub_string as the beginning
-- @param string searched_sub_string What should be at the beginning of some_string
-- @return bool
function M.starts_with(some_string, searched_sub_string)
    local found_pos = M.find_substring_pos(some_string, searched_sub_string)

    return found_pos == 1
end

-- Checks if some_string ends with searched_sub_string
-- @param string some_string
-- @param string searched_sub_string What should be at the end of some_string
function M.ends_with(some_string, searched_sub_string)
    if utf8.len(some_string) < utf8.len(searched_sub_string) then
        return false
    end

    local tail_substr_index = utf8.len(some_string) - utf8.len(searched_sub_string) + 1
    local tail_substr = utf8.sub(some_string, tail_substr_index)

    return tail_substr == searched_sub_string
end

-- Splits a string by given separator substring
-- @param string some_string What to split
-- @param string some_separator By what separator to split
-- @return table An array of parts of some_string
function M.split(some_string, some_separator)
    local parts = {}
    local separator_end = 0
    local separator_start = 0
    local prev_separator_end = 0
    local str_size = string.len(some_string)
    local separator = build_separator_regexp_pattern(some_separator)

    repeat
        separator_start, separator_end = utf8.find(some_string, separator, prev_separator_end + 1)

        -- separator not found, so nothing to split
        if separator_start == nil or separator_end == nil then
            break
        end

        -- some_string contains nothing else but the separator, so nothing to split
        if separator_start == 1 and separator_end == str_size then
            break
        end

        if separator_start == 1 then
            -- separator is at the beginning of the string, so just skipping it
            prev_separator_end = separator_end
        else
            -- separator is somewhere in the middle, taking substring between old and new separators
            table.insert(parts, utf8.sub(some_string, prev_separator_end + 1, separator_start - 1))
            prev_separator_end = separator_end
        end
    until separator_start == nil

    if prev_separator_end == 0 then
        -- When string contained no separators, just add it to parts
        table.insert(parts, some_string)
    else
        -- handling case when the last separator is not at the end of the string
        if prev_separator_end < str_size then
            table.insert(parts, utf8.sub(some_string, prev_separator_end + 1))
        end
    end

    return parts
end

-- Combines list of strings into one string using given string separator
-- @param table some_items What items to combine
-- @param string separator What should be used as a separator between items
-- @return string
function M.join(some_items, separator)
    if type(some_items) ~= 'table' then
        return ''
    end

    local result = ''
    separator = separator or ' '

    for i = 1, #some_items do
        if i < #some_items then
            result = result .. some_items[i] .. separator
        else
            result = result .. some_items[i]
        end
    end

    return result
end

return M
