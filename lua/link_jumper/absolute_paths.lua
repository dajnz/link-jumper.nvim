local AbsolutePaths = {}
AbsolutePaths.__index = AbsolutePaths

function AbsolutePaths.new(nvim_functions_api)
    local self = setmetatable({}, AbsolutePaths)

    self.api = nvim_functions_api

    return self
end

function AbsolutePaths:home_relative()
    return self.api:expand('~')
end

function AbsolutePaths:project_relative()
    return self.api:getcwd()
end

function AbsolutePaths:current_file_relative()
    return self.api:expand('%:p:h')
end

return AbsolutePaths
