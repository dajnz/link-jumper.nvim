describe('InternalJumpHistory', function ()
    local JumpFake = require('jump_fake')
    local InternalJumpHistory = require('internal_jump_history')

    describe(':has_jumps()', function ()
        it('returns FALSE when no jumps in history', function ()
            local history = InternalJumpHistory.new()

            assert.is_false(history:has_jumps())
        end)

        it('returns TRUE when it has at least one jump', function ()
            local history = InternalJumpHistory.new({JumpFake.new()})

            assert.is_true(history:has_jumps())
        end)

        it('returns TRUE when at least one jump is added', function ()
            local history = InternalJumpHistory.new()
            history = history:appended_history(JumpFake.new())

            assert.is_true(history:has_jumps())
        end)
    end)

    describe(':appended_history()', function ()
        it('does not append jump for external app', function ()
            local external_jump = JumpFake.new(true)
            local history = InternalJumpHistory.new()
            history = history:appended_history(external_jump)

            assert.is_false(history:has_jumps())
        end)
    end)

    describe(':previous_jump()', function ()
        it('returns nil for empty history', function ()
            local history = InternalJumpHistory.new()

            assert.is_nil(history:previous_jump())
        end)

        it('returns nil if the only one jump in a history', function ()
            local history = InternalJumpHistory.new({JumpFake.new()})

            assert.is_nil(history:previous_jump())
        end)

        it('returns the jump before the last one when history has 2 or more jumps', function ()
            local prev_jump = JumpFake.new()
            local history = InternalJumpHistory.new({prev_jump, JumpFake.new()})

            assert.are.same(prev_jump, history:previous_jump())
        end)
    end)

    describe(':last_jump()', function ()
        it('returns nil for empty history', function ()
            local history = InternalJumpHistory.new()

            assert.is_nil(history:last_jump())
        end)

        it('returns latest jump in the history', function ()
            local last_jump = JumpFake.new()
            local history = InternalJumpHistory.new({JumpFake.new(), last_jump})

            assert.are.same(last_jump, history:last_jump())
        end)
    end)

    describe(':previous_step_history()', function ()
        it('has no error when calling on empty history', function ()
            local history = InternalJumpHistory.new()

            assert.has_no.errors(function() history:previous_step_history() end)
        end)

        it('removes the last jump if history has only one', function ()
            local history = InternalJumpHistory.new({JumpFake.new()})

            history = history:previous_step_history()

            assert.is_false(history:has_jumps())
        end)

        it('removes only the most recently added jump', function ()
            local first_jump = JumpFake.new()
            local history = InternalJumpHistory.new({first_jump})
            history = history:appended_history(JumpFake.new())

            history = history:previous_step_history()

            assert.are.same(first_jump, history:last_jump())
        end)
    end)
end)
