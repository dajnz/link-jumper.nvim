describe('FileRegexpJump', function ()
    local JumpFake = require('jump_fake')
    local NvimApiFake = require('nvim_api_fake')
    local FileRegexpJump = require('jumps.file_regexp_jump')

    describe(':to_external_app()', function ()
        it('should be always falsy since we jump by files inside neovim', function ()
            local jump = FileRegexpJump.new()
            assert.is_false(jump:to_external_app())
        end)
    end)

    describe(':class_name()', function ()
        it('returns proper class name', function ()
            local jump = FileRegexpJump.new()
            assert.are.equal('FileRegexpJump', jump:class_name())
        end)
    end)

    describe(':within_current_file()', function ()
        it('should always return true since the jump is not only for current file', function ()
            local jump = FileRegexpJump.new()
            assert.is_false(jump:within_current_file())
        end)
    end)

    describe(':go()', function ()
        it('should jump to given file', function ()
            local file_jump = JumpFake.new()
            local jump = FileRegexpJump.new(file_jump, JumpFake.new())

            jump:go()

            assert.is_true(file_jump:jumped())
        end)

        it('should jump to given regexp inside current file', function ()
            local regexp_jump = JumpFake.new()
            local jump = FileRegexpJump.new(JumpFake.new(), regexp_jump)

            jump:go()

            assert.is_true(regexp_jump:jumped())
        end)

        it('jumps to the beginning of file in case of regexp jump error', function ()
            local api = NvimApiFake.new('', 777, 888)
            local regexp_jump = JumpFake.new(false, '', 0, true, true)
            local jump = FileRegexpJump.new(JumpFake.new(), regexp_jump, api)

            jump:go()

            assert.are.same(1, api:get_line_num())
            assert.are.same(0, api:get_cursor_pos())
        end)
    end)
end)
