describe('FileCursorPosJump', function ()
    local JumpFake = require('jump_fake')
    local NvimApiFake = require('nvim_api_fake')
    local FileCursorPosJump = require('jumps.file_cursor_pos_jump')

    describe(':to_external_app()', function ()
        it('should always return FALSE since current file is in neovim', function ()
            local jump = FileCursorPosJump.new(NvimApiFake.new(), JumpFake.new())
            assert.is_false(jump:to_external_app())
        end)
    end)

    describe(':within_current_file()', function ()
        it('should always return true since the jump is not only for current file', function ()
            local jump = FileCursorPosJump.new(NvimApiFake.new(), JumpFake.new())
            assert.is_false(jump:within_current_file())
        end)
    end)

    describe(':class_name()', function ()
        it('returns proper class name', function ()
            local jump = FileCursorPosJump.new(NvimApiFake.new(), JumpFake.new())
            assert.are.equal('FileCursorPosJump', jump:class_name())
        end)
    end)

    describe(':go()', function ()
        it('jumps to file using composed file jump object', function ()
            local fileJump = JumpFake.new()
            local jump = FileCursorPosJump.new(NvimApiFake.new(), fileJump)

            jump:go()

            assert.is_true(fileJump:jumped())
        end)

        it('jumps to current file line and cursor pos after jumping to current file', function ()
            local LINE_NUM = 100
            local CURSOR_POS = 10
            local api = NvimApiFake.new('', CURSOR_POS, LINE_NUM)
            local jump = FileCursorPosJump.new(api, JumpFake.new())
            api:change_cursor_pos(0, 0)

            jump:go()

            assert.are.same(LINE_NUM, api:get_line_num())
            assert.are.same(CURSOR_POS, api:get_cursor_pos())
        end)
    end)
end)
