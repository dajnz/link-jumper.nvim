---------
-- Library for working with file paths
---------

local Path = {}
Path.__index = Path
local str = require('link_jumper.str')
local utf8 = require('utf8.init'):init()

local function is_win(abs_paths)
    return str.starts_with(abs_paths:current_file_relative(), '/') == false
end

local function normalize_double_dots(current_file_abs_path, parts_of_path_with_dots, path_separator)
    local abs_path_parts = str.split(current_file_abs_path, path_separator)
    local dots_path_part = '..'

    while dots_path_part == '..' do
        if #abs_path_parts > 0 then
            table.remove(abs_path_parts, #abs_path_parts)
        end

        if #parts_of_path_with_dots > 0 then
            table.remove(parts_of_path_with_dots, 1)
        end

        dots_path_part = parts_of_path_with_dots[1]
    end

    return abs_path_parts
end

local function extract_win_drive_letter(current_file_abs_path)
    local parts = str.split(current_file_abs_path, ':')

    return parts[1]
end

local function is_path_without_filename(some_path, path_separator)
    return str.ends_with(some_path, path_separator .. '..')
        or str.ends_with(some_path, path_separator .. '.')
end


---------
-- Public stuff, exported from the module
---------

function Path.new(path, absolute_paths)
    local self = setmetatable({}, Path)

    self.some_path = path
    self.abs_paths = absolute_paths
    self.is_win = is_win(absolute_paths)
    self.path_separator = '/'

    if self.is_win then
        self.path_separator = '\\'
    end

    return self
end

-- Detects if the path is absolute
-- @returns bool
function Path:absolute()
    local is_abs = str.starts_with(self.some_path, '/')

    if is_abs == false then
        -- win abs path starts with windows drive letter followed by backslashes
        local position = utf8.find(self.some_path, '%a:\\.+')

        is_abs = position ~= nil
    end

    return is_abs
end

-- Detects if the path is home relative
-- @returns bool
function Path:home_relative()
    local is_home_relative = str.starts_with(self.some_path, '~/')

    if is_home_relative == false then
        is_home_relative = str.starts_with(self.some_path, self.abs_paths:home_relative())
    end

    return is_home_relative
end

-- Detects if the path is current file relative
-- @returns bool
function Path:current_file_relative()
    local is_file_relative = str.starts_with(self.some_path, '.' .. self.path_separator)

    return is_file_relative and not is_path_without_filename(self.some_path, self.path_separator)
end

-- Detects if the path is file parent relative
-- @returns bool
function Path:current_file_parent_relative()
    local is_parent_relative = str.starts_with(self.some_path, '..' .. self.path_separator)

    return is_parent_relative and not is_path_without_filename(self.some_path, self.path_separator)
end

-- Detects if the path is project relative
-- @returns bool
function Path:project_relative()
    if self.some_path == '' or is_path_without_filename(self.some_path, self.path_separator) then
        return false
    end

    return self:absolute() == false
        and self:home_relative() == false
        and self:current_file_relative() == false
        and self:current_file_parent_relative() == false
end


-- Converts Path instance to absolute path
-- @return string Absolute path
function Path:to_absolute()
    if self:absolute() then
        return self.some_path
    else
        local path_parts = str.split(self.some_path, self.path_separator)

        if self:home_relative() then
            path_parts[1] = self.abs_paths:home_relative()
        elseif self:current_file_relative() then
            path_parts[1] = self.abs_paths:current_file_relative()
        elseif self:current_file_parent_relative() then
            local abs_path_parts = normalize_double_dots(
                self.abs_paths:current_file_relative(),
                path_parts,
                self.path_separator
            )

            if #path_parts == 0 then
                return ''
            end

            table.insert(path_parts, 1, '')

            if #abs_path_parts == 0 then
                if self.is_win then
                    local drive_letter = extract_win_drive_letter(self.abs_paths:current_file_relative())
                    local drive_part = drive_letter .. ':'
                    path_parts[1] = drive_part .. str.join(abs_path_parts, self.path_separator)
                else
                    table.remove(path_parts, 1)
                    path_parts[1] = self.path_separator .. str.join(path_parts, self.path_separator)
                end
            else
                if self.is_win then
                    path_parts[1] = str.join(abs_path_parts, self.path_separator)
                else
                    path_parts[1] = self.path_separator .. str.join(abs_path_parts, self.path_separator)
                end
            end

        elseif self:project_relative() then
            path_parts[1] = self.abs_paths:project_relative() .. self.path_separator .. path_parts[1]
        else
            return ''
        end

        return str.join(path_parts, self.path_separator)
    end
end

return Path
