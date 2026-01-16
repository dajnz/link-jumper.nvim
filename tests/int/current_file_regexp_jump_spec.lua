describe('CurrentFileRegexpJump', function ()
    local NvimApiFake = require('nvim_api_fake')
    local NvimFunctionsApiFake = require('nvim_functions_api_fake')
    local CurrentFileRegexpJump = require('jumps.current_file_regexp_jump')

    local INITIAL_LINE_NUM = 100
    local INITIAL_CURSOR_POS = 100
    local SAMPLE_REGEXP = 'first_regexp'
    local LINES_WITH_REGEXPS = {
        [SAMPLE_REGEXP] = 5,
    }

    describe(':to_external_app()', function ()
        it('should always return FALSE since it works for current file in neovim', function ()
            local jump = CurrentFileRegexpJump.new(NvimApiFake.new(), NvimFunctionsApiFake.new())
            assert.is_false(jump:to_external_app())
        end)
    end)

    describe(':within_current_file()', function ()
        it('should always return true since the jump is for current file', function ()
            local jump = CurrentFileRegexpJump.new(NvimApiFake.new(), NvimFunctionsApiFake.new())
            assert.is_true(jump:within_current_file())
        end)
    end)

    describe(':class_name()', function ()
        it('returns proper class name', function ()
            local jump = CurrentFileRegexpJump.new(NvimApiFake.new(), NvimFunctionsApiFake.new())
            assert.are.equal('CurrentFileRegexpJump', jump:class_name())
        end)
    end)

    describe(':go()', function ()
        it('should throw error if regexp is empty', function ()
            local api = NvimApiFake.new('', INITIAL_CURSOR_POS, INITIAL_LINE_NUM)
            local funcs = NvimFunctionsApiFake.new(true, 0, nil, LINES_WITH_REGEXPS)
            local jump = CurrentFileRegexpJump.new(api, funcs, '')

            assert.has.errors(function() jump:go() end)
            assert.are.same(0, funcs:get_last_found_line_num())
            assert.are.same(INITIAL_LINE_NUM, api:get_line_num())
        end)

        it('should throw error if line with regexp not exists', function ()
            local api = NvimApiFake.new('', INITIAL_CURSOR_POS, INITIAL_LINE_NUM)
            local funcs = NvimFunctionsApiFake.new(true, 0, nil, LINES_WITH_REGEXPS)
            local jump = CurrentFileRegexpJump.new(api, funcs, 'non-existing-regexp')

            assert.has.errors(function() jump:go() end)
            assert.are.same(0, funcs:get_last_found_line_num())
            assert.are.same(INITIAL_LINE_NUM, api:get_line_num())
        end)

        it('goes to the line with the first found substring matching the regexp', function ()
            local api = NvimApiFake.new('', INITIAL_CURSOR_POS, INITIAL_LINE_NUM)
            local funcs = NvimFunctionsApiFake.new(true, 0, nil, LINES_WITH_REGEXPS)
            local jump = CurrentFileRegexpJump.new(api, funcs, SAMPLE_REGEXP)

            jump:go()

            assert.are.same(5, funcs:get_last_found_line_num())
        end)

        it('allow using "next search" for possible next substrings matching the regexp', function ()
            local api = NvimApiFake.new('', INITIAL_CURSOR_POS, INITIAL_LINE_NUM)
            local funcs = NvimFunctionsApiFake.new(true, 0, nil, LINES_WITH_REGEXPS)
            local jump = CurrentFileRegexpJump.new(api, funcs, SAMPLE_REGEXP)

            jump:go()

            assert.are.same(SAMPLE_REGEXP, funcs:get_search_string())
        end)
    end)
end)
