describe('FileJump', function ()
    local FileJump = require('jumps.file_jump')
    local NvimApiFake = require('nvim_api_fake')
    local NvimFunctionsApiFake = require('nvim_functions_api_fake')

    local FILE_PATH = '/some/file.md'
    local CURRENT_FILE_PATH = '/current/file.md'

    describe(':to_external_app()', function ()
        it('always false, since the object is for local files jumps', function ()
            local api = NvimApiFake.new('', 0)
            local funcs = NvimFunctionsApiFake.new(FILE_PATH)
            assert.is_false(FileJump.new(FILE_PATH, api, funcs):to_external_app())
        end)
    end)

    describe(':within_current_file()', function ()
        it('should always return true since the jump is not only for current file', function ()
            local api = NvimApiFake.new('', 0)
            local funcs = NvimFunctionsApiFake.new(FILE_PATH)
            assert.is_false(FileJump.new(FILE_PATH, api, funcs):within_current_file())
        end)
    end)

    describe(':go()', function ()
        it('if no buffer exists, it should open file by its path', function ()
            local api = NvimApiFake.new('', 0)
            local jump = FileJump.new(FILE_PATH, api, NvimFunctionsApiFake.new(true))

            jump:go()

            local cmd = api:get_command()
            assert.are.same('edit', cmd.cmd)
            assert.are.same(FILE_PATH, cmd.args[1])
        end)

        it('if no file exists or not readable, it should add error notification', function ()
            local api = NvimApiFake.new('', 0)
            local jump = FileJump.new(FILE_PATH, api, NvimFunctionsApiFake.new(false))

            assert.has_errors(function ()
                jump:go()
            end)
        end)

        it('should jump to current file when used current file constructor', function ()
            local api = NvimApiFake.new('', 0)
            local funcs = NvimFunctionsApiFake.new(true, nil, {['%:p'] = CURRENT_FILE_PATH})
            local jump = FileJump.new_for_current_file(api, funcs)

            jump:go()

            local cmd = api:get_command()
            assert.are.same(CURRENT_FILE_PATH, cmd.args[1])
        end)
    end)
end)
