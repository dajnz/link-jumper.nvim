local HistoryReturnJump = {}
HistoryReturnJump.__index = HistoryReturnJump

function HistoryReturnJump.new(history)
    local self = setmetatable({}, HistoryReturnJump)

    self.history = history

    return self
end

function HistoryReturnJump:go()
    local prev_jump = self.history:previous_jump()

    if prev_jump ~= nil then
        prev_jump:go()
    end
end

function HistoryReturnJump:jumpable()
    return self.history:previous_jump() ~= nil
end

function HistoryReturnJump:history_after_return()
    local history = self.history:previous_step_history()

    if history:previous_jump() == nil then
        return history:previous_step_history()
    end

    return history
end

return HistoryReturnJump
