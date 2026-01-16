local InternalJumpHistory = {}
InternalJumpHistory.__index = InternalJumpHistory

local function shallow_copy(orig)
    local copy = {}

    for _, orig_value in ipairs(orig) do
        table.insert(copy, orig_value)
    end

    return copy
end


-- Public API of the class

function InternalJumpHistory.new(jumps)
    local self = setmetatable({}, InternalJumpHistory)

    self.jumps = jumps ~= nil and jumps or {}

    return self
end

-- Returns history with appended new jump
function InternalJumpHistory:appended_history(jump)
    if jump:to_external_app() then
        return self
    end

    local old_jumps = shallow_copy(self.jumps)
    table.insert(old_jumps, jump)

    return InternalJumpHistory.new(old_jumps)
end

-- Returns history with the most recent jump removed
function InternalJumpHistory:previous_step_history()
    local old_jumps = shallow_copy(self.jumps)

    if #old_jumps > 0 then
        table.remove(old_jumps, #old_jumps)
    end

    return InternalJumpHistory.new(old_jumps)
end


function InternalJumpHistory:has_jumps()
    return #self.jumps > 0
end

function InternalJumpHistory:last_jump()
    if not self:has_jumps() then
        return nil
    end

    return self.jumps[#self.jumps]
end

function InternalJumpHistory:previous_jump()
    if #self.jumps <= 1 then
        return nil
    end

    return self.jumps[#self.jumps - 1]
end

return InternalJumpHistory
