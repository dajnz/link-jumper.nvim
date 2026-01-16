local LinkForwardJump = {}
LinkForwardJump.__index = LinkForwardJump

function LinkForwardJump.new(link_jump, current_location_jump, jump_history)
    local self = setmetatable({}, LinkForwardJump)

    self.link_jump = link_jump
    self.history = jump_history
    self.current_location_jump = current_location_jump

    return self
end

function LinkForwardJump.new_for_link(link, jump_history, jump_factory)
    return LinkForwardJump.new(
        jump_factory:make_link_jump(link),
        jump_factory:make_current_location_jump(),
        jump_history
    )
end

-- @throws Jumping error specific for certain type of jump
function LinkForwardJump:go()
    if self.link_jump ~= nil then
        self.link_jump:go()
    else
        error('No valid jump link under cursor found', 0)
    end
end

function LinkForwardJump:history_after_jump()
    if self.link_jump == nil then
        return self.history
    end

    local new_history = self.history

    if self.history:has_jumps() == false or self.link_jump:within_current_file() then
        new_history = new_history:appended_history(self.current_location_jump)
    end

    return new_history:appended_history(self.link_jump)
end

return LinkForwardJump
