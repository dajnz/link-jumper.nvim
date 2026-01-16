local NvimFunctionsApiFake = {}
NvimFunctionsApiFake.__index = NvimFunctionsApiFake

function NvimFunctionsApiFake.new(
    is_readable,
    existing_buf_num,
    expanded_path_map,
    regexp_lines_map,
    current_working_dir,
    unicode_to_byte_map
)
    local self = setmetatable({}, NvimFunctionsApiFake)

    self.is_readable = is_readable
    self.last_found_line_num = 0
    self.regexp_lines_map = regexp_lines_map
    self.expanded_path_map = expanded_path_map
    self.existing_buf_num = existing_buf_num ~= nil and existing_buf_num or -1
    self.search_string = ''
    self.work_dir = current_working_dir
    self.unicode_map = unicode_to_byte_map ~= nil and unicode_to_byte_map or {}

    if is_readable == nil then
        self.is_readable = true
    end

    return self
end


-- API methods

function NvimFunctionsApiFake:getcwd()
    return self.work_dir
end

function NvimFunctionsApiFake:expand(path)
    if self.expanded_path_map ~= nil and self.expanded_path_map[path] then
        return self.expanded_path_map[path]
    end

    return path
end

function NvimFunctionsApiFake:resolve(path)
    return path
end

function NvimFunctionsApiFake:filereadable(path)
    if self.is_readable == true then
        return 1
    end

    return 0
end

function NvimFunctionsApiFake:bufnr()
    return self.existing_buf_num
end

function NvimFunctionsApiFake:fnameescape(path)
    return path
end

function NvimFunctionsApiFake:search(regexp)
    self.last_found_line_num = 0

    if self.regexp_lines_map ~= nil and self.regexp_lines_map[regexp] then
        self.last_found_line_num = self.regexp_lines_map[regexp]
    end

    return self.last_found_line_num
end

function NvimFunctionsApiFake:setreg(register, value)
    if register == '/' then
        self.search_string = value
    end
end

function NvimFunctionsApiFake:charidx(some_line, byte_index)
    if self.unicode_map[byte_index] then
        return self.unicode_map[byte_index]
    end

    return byte_index
end


-- Helper methods of the fake

function NvimFunctionsApiFake:get_last_found_line_num()
    return self.last_found_line_num
end

function NvimFunctionsApiFake:get_search_string()
    return self.search_string
end


return NvimFunctionsApiFake
