local AbsolutePathsFake = {}
AbsolutePathsFake.__index = AbsolutePathsFake

function AbsolutePathsFake.new(home_path, project_path, current_file_path)
    local self = setmetatable({}, AbsolutePathsFake)

    self.home = home_path
    self.project = project_path
    self.current = current_file_path

    return self
end

function AbsolutePathsFake:home_relative()
    return self.home
end

function AbsolutePathsFake:project_relative()
    return self.project
end

function AbsolutePathsFake:current_file_relative()
    return self.current
end

return AbsolutePathsFake
