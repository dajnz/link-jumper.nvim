---------
-- Array utils
---------

local M = {}

local function validate_map_arguments(some_map, some_key)
    if type(some_map) ~= 'table' then
        error('Argument some_map should be a table')
    end

    if type(some_key) ~= 'string' or #some_key < 1 then
        error('Argument some_key should be a non-empty string')
    end

end

-- Check if given value exists in the array
-- @param table some_array
-- @param any some_value
-- @return bool
function M.array_includes(some_array, some_value)
    if type(some_array) ~= 'table' then
        return false
    end

    for i = 1, #some_array do
        if some_array[i] == some_value then
            return true
        end
    end

    return false
end

-- @param table some_map
-- @param any some_key
-- @return bool
function M.map_has_key(some_map, some_key)
    validate_map_arguments(some_map, some_key)

    return some_map[some_key] ~= nil
end

function M.count_map_items(some_map)
    validate_map_arguments(some_map, ' ')
    local num = 0

    for key, _ in pairs(some_map) do
        if type(key) == 'string' then
            num = num + 1
        end
    end

    return num
end

return M

