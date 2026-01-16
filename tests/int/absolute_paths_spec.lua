describe('AbsolutePaths', function()
    local AbsolutePaths = require('absolute_paths')
    local NvimFunctionsApiFake = require('nvim_functions_api_fake')

    local HOME_PATH = '/home'
    local PROJECT_PATH = '/project'
    local CURRENT_FILE_PATH = '/current_file'

    local expand_map = {
        ['~'] = HOME_PATH,
        ['%:p:h'] = CURRENT_FILE_PATH
    }
    local nvim_api = NvimFunctionsApiFake.new(true, 0, expand_map, nil , PROJECT_PATH)
    local abs_paths = AbsolutePaths.new(nvim_api)

    describe('home_relative()', function ()
        it('returns correct abs home path', function ()
            assert.are.same(HOME_PATH, abs_paths:home_relative())
        end)
    end)

    describe('project_relative()', function ()
        it('returns correct abs path for current project', function ()
            assert.are.same(PROJECT_PATH, abs_paths:project_relative())
        end)
    end)

    describe('current_file_relative()', function ()
        it('returns corrent abs path of current edited file', function ()
            assert.are.same(CURRENT_FILE_PATH, abs_paths:current_file_relative())
        end)
    end)
end)
