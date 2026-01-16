describe('HistoryReturnJump', function ()
    local JumpFake = require('jump_fake')
    local HistoryReturnJump = require('jumps.history_return_jump')
    local InternalJumpHistory = require('internal_jump_history')

    describe(':go()', function ()
        it('jumps using the previous jump in the history', function ()
            local previous_jump = JumpFake.new()
            local history = InternalJumpHistory.new({previous_jump, JumpFake.new()})
            local return_jump = HistoryReturnJump.new(history)

            return_jump:go()

            assert.is_true(previous_jump:jumped())
        end)

        it('should not be an error when there is no previous jump in the history' ,function ()
            local history = InternalJumpHistory.new({JumpFake.new()})
            local return_jump = HistoryReturnJump.new(history)

            assert.has_no.errors(function () return_jump:go() end)
        end)
    end)

    describe(':jumpable()', function ()
        it('should return TRUE if there is previous jump in history', function ()
            local history = InternalJumpHistory.new({JumpFake.new(), JumpFake.new()})
            local return_jump = HistoryReturnJump.new(history)

            assert.is_true(return_jump:jumpable())
        end)
    end)

    describe(':history_after_return()', function ()
        it('returns history with removed last jump when history has 2+ jumps', function ()
            local first_jump = JumpFake.new()
            local prev_jump = JumpFake.new()
            local initial_history = InternalJumpHistory.new({first_jump, prev_jump, JumpFake.new()})
            local return_jump = HistoryReturnJump.new(initial_history)

            local updated_history = return_jump:history_after_return()

            assert.are.same(prev_jump, updated_history:last_jump())
            assert.are.same(first_jump, updated_history:previous_jump())
        end)

        it('removes the last one jump if history has no previous jump', function ()
            local initial_history = InternalJumpHistory.new({JumpFake.new(), JumpFake.new()})
            local return_jump = HistoryReturnJump.new(initial_history)

            local updated_history = return_jump:history_after_return()

            assert.is_nil(updated_history:last_jump())
            assert.is_nil(updated_history:previous_jump())
            assert.is_false(updated_history:has_jumps())
        end)
    end)
end)
