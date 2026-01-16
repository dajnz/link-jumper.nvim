local JumpFactoryFake = {}
JumpFactoryFake.__index = JumpFactoryFake

function JumpFactoryFake.new(link_jump, current_location_jump)
    local self = setmetatable({}, JumpFactoryFake)

    self.link_jump = link_jump
    self.current_location_jump = current_location_jump

    return self
end

function JumpFactoryFake:make_link_jump()
    return self.link_jump
end

function JumpFactoryFake:make_current_location_jump()
    return self.current_location_jump
end

return JumpFactoryFake
