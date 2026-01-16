local FileJump = {}
FileJump.__index = FileJump

local CURRENT_FILE_ABS_PATH = '%:p'

function FileJump.new(file_abs_path, nvim_api, nvim_functions_api)
    local self = setmetatable({}, FileJump)

    self.nvim_api = nvim_api
    self.abs_path = file_abs_path
    self.nvim_funcs = nvim_functions_api

    return self
end

function FileJump.new_for_current_file(nvim_api, nvim_functions_api)
    local file_abs_path = nvim_functions_api:expand(CURRENT_FILE_ABS_PATH)

    return FileJump.new(file_abs_path, nvim_api, nvim_functions_api)
end

-- Will the jump lead to any external app or it performs inside neovim
function FileJump:to_external_app()
    return false
end

function FileJump:within_current_file()
    return false
end

-- Performs jumping itself
-- @throws Error in case of not available file or issues with file opening
function FileJump:go()
    self.error = ''
    local norm_path = self.nvim_funcs:resolve(self.nvim_funcs:expand(self.abs_path))
    local is_file_exist = self.nvim_funcs:filereadable(norm_path) == 1

    if not is_file_exist then
        error('File referred by the link not exist or cannot be read', 0)
    end

    self.nvim_api:nvim_cmd({cmd = 'edit', args = {norm_path}}, {})
end

return FileJump
