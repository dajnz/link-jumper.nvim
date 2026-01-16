local JumpFake = {}
JumpFake.__index = JumpFake

function JumpFake.new(is_for_external_app, file_path, jump_id, is_within_current_file, is_jump_error)
    local self = setmetatable({}, JumpFake)

    self.is_jumped = false
    self.file_path = file_path
    self.jump_id = jump_id ~= nil and jump_id or 1
    self.is_external = is_for_external_app ~= nil and is_for_external_app or false
    self.is_within = false
    self.is_jump_error = is_jump_error ~= nil and is_jump_error or false

    if is_within_current_file ~= nil then
        self.is_within = is_within_current_file
    end

    return self
end

function JumpFake.new_for_current_file()
    return JumpFake.new()
end


-- Jump interface methods

function JumpFake:go()
    if self.is_jump_error then
        error('oops')
    end

    self.is_jumped = true
end

function JumpFake:to_external_app()
    return self.is_external
end

function JumpFake:within_current_file()
    return self.is_within
end


-- Fake helper methods

function JumpFake:jumped()
    return self.is_jumped
end

function JumpFake:path()
    return self.file_path
end

function JumpFake:id()
    return self.jump_id
end

return JumpFake
