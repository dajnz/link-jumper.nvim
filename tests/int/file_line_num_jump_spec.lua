describe('FileLineNumJump', function ()
    local JumpFake = require('jump_fake')
    local NvimApiFake = require('nvim_api_fake')
    local FileLineNumJump = require('jumps.file_line_num_jump')

    local TARGET_LINE_NUM = 7
    local INITIAL_LINE_NUM = 1
    local TOTAL_LINES_NUM = 999

    describe('.class_name()', function ()
        it('returns proper class name', function ()
            local jump = FileLineNumJump.new(JumpFake.new(), TARGET_LINE_NUM, NvimApiFake.new())
            assert.are.equal('FileLineNumJump', jump:class_name())
        end)
    end)

    describe(':to_external_app()', function ()
        it('should be always FALSE since the jump is for local files', function ()
            local jump = FileLineNumJump.new(JumpFake.new(), TARGET_LINE_NUM, NvimApiFake.new())
            assert.is_false(jump:to_external_app())
        end)
    end)

    describe(':within_current_file()', function ()
        it('should be always false because the jump is for external file', function ()
            local jump = FileLineNumJump.new(JumpFake.new(), TARGET_LINE_NUM, NvimApiFake.new())
            assert.is_false(jump:within_current_file())
        end)
    end)

    describe(':go()', function ()
        it('should invoke internal file jump', function ()
            local internal_jump = JumpFake.new()
            local jump = FileLineNumJump.new(internal_jump, TARGET_LINE_NUM, NvimApiFake.new())

            jump:go()

            assert.is_true(internal_jump:jumped())
        end)

        it('should move current window cursor to specified line', function ()
            local api = NvimApiFake.new('', 0, 1)
            local jump = FileLineNumJump.new(JumpFake.new(), TARGET_LINE_NUM, api)

            jump:go()

            assert.are.same(TARGET_LINE_NUM, api:get_line_num())
        end)

        it('moves current window cursor to the last line if specified line num is too big', function ()
            local api = NvimApiFake.new('', 0, 1, TOTAL_LINES_NUM)
            local jump = FileLineNumJump.new(JumpFake.new(), 999999, api)

            jump:go()

            assert.are.same(TOTAL_LINES_NUM, api:get_line_num())
        end)

        it('should not change cursor position if internal file jump failed', function ()
            local internal_jump = JumpFake.new(false, '', 0, true, true)
            local api = NvimApiFake.new('', 0, INITIAL_LINE_NUM)
            local jump = FileLineNumJump.new(internal_jump, 10, api)

            jump:go()

            assert.are.same(INITIAL_LINE_NUM, api:get_line_num())
        end)
    end)
end)
