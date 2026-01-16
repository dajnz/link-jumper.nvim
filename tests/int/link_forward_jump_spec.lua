describe('LinkForwardJump', function ()
    local JumpFake = require('jump_fake')
    local ParsedLinkFake = require('parsed_link_fake')
    local JumpFactoryFake = require('jump_factory_fake')
    local LinkForwardJump = require('jumps.link_forward_jump')
    local InternalJumpHistory = require('internal_jump_history')

    describe(':go()', function ()
        it('jumps using encapsulated jump object', function ()
            local internal_jump = JumpFake.new()
            local forward = LinkForwardJump.new(internal_jump)

            forward:go()

            assert.is_true(internal_jump:jumped())
        end)

        it('should be an error when passing nil instead of internal jump object', function ()
            local forward = LinkForwardJump.new(nil)

            assert.has.errors(function() forward:go() end)
        end)
    end)

    describe(':history_after_jump()', function ()
        it('for empty history it adds current position jump first', function ()
            local current_jump = JumpFake.new()
            local history = InternalJumpHistory.new()
            local forward = LinkForwardJump.new(JumpFake.new(), current_jump, history)

            local changed_history = forward:history_after_jump()

            assert.are.same(current_jump, changed_history:previous_jump())
        end)

        it('for empty history adds new jump as the last one', function ()
            local new_jump = JumpFake.new()
            local history = InternalJumpHistory.new()
            local forward = LinkForwardJump.new(new_jump, JumpFake.new(), history)

            local changed_history = forward:history_after_jump()

            assert.are.same(new_jump, changed_history:last_jump())
        end)

        it('adds current position jump before new one if new one is within current file', function ()
            local new_jump = JumpFake.new(false, '', 0, true)
            local current_location_jump = JumpFake.new()
            local history = InternalJumpHistory.new({JumpFake.new()})
            local forward = LinkForwardJump.new(new_jump, current_location_jump, history)

            local changed_history = forward:history_after_jump()

            assert.are.equals(new_jump, changed_history:last_jump())
            assert.are.equals(current_location_jump, changed_history:previous_jump())
        end)

        it('for non-empty history adds new jump as the last one', function ()
            local new_jump = JumpFake.new()
            local history = InternalJumpHistory.new({JumpFake.new()})
            local forward = LinkForwardJump.new(new_jump, JumpFake.new(), history)

            local changed_history = forward:history_after_jump()

            assert.are.same(new_jump, changed_history:last_jump())
        end)

        it('for non-empty history it should not add current position jump before new jump', function ()
            local old_jump = JumpFake.new()
            local history = InternalJumpHistory.new({old_jump})
            local forward = LinkForwardJump.new(JumpFake.new(), JumpFake.new(), history)

            local changed_history = forward:history_after_jump()

            assert.are.same(old_jump, changed_history:previous_jump())
        end)

        it('should return the same history for nil internal jump object', function ()
            local history = InternalJumpHistory.new()
            local forward = LinkForwardJump.new(nil, JumpFake.new(), history)

            assert.are.same(history, forward:history_after_jump())
        end)

        -- for empty history it adds nvim help page jump first, if the buffer is help page
    end)

    describe('.new_for_link()', function ()
        it('creates instances properly', function ()
            local new_jump = JumpFake.new()
            local current_location_jump = JumpFake.new()
            local factory = JumpFactoryFake.new(new_jump, current_location_jump)
            local history = InternalJumpHistory.new()
            local link = ParsedLinkFake.new()
            local forward = LinkForwardJump.new_for_link(link, history, factory)

            local changed_history = forward:history_after_jump()

            assert.are.same(current_location_jump, changed_history:previous_jump())
            assert.are.same(new_jump, changed_history:last_jump())
        end)
    end)

end)
