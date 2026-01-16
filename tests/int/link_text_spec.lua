describe('LinkText', function ()
    local LinkText = require('link_text')
    local NvimApiFake = require('nvim_api_fake')
    local NvimFunctionsApiFake = require('nvim_functions_api_fake')

    local LINK_ACHNOR = '#heading'
    local FILE_PATH = '/some/file.md#' .. LINK_ACHNOR
    local SAME_FILE_LINK = '[link](' .. LINK_ACHNOR .. ')'
    local ANOTHER_FILE_LINK = '[link](' .. FILE_PATH .. ')'
    local LINE_WITH_SAME_FILE_LINK = 'bla ' .. SAME_FILE_LINK .. ' bla'
    local UNICODE_LINK_ANCHOR = '#юни'
    local SAME_FILE_UNICODE_LINK = 'bla [link](' .. UNICODE_LINK_ANCHOR .. ') bla'

    describe(':to_string()', function ()
        it('returns empty string when current buffer is empty or unloaded', function ()
            local funcs = NvimFunctionsApiFake.new()
            assert.are.equals('', LinkText.new(NvimApiFake.new(nil, 1), funcs):to_string())
        end)

        it('returns empty string when current buffer line with cursor is empty', function ()
            local funcs = NvimFunctionsApiFake.new()
            assert.are.equals('', LinkText.new(NvimApiFake.new('', 1), funcs):to_string())
        end)

        it('returns empty string when current line has no link', function ()
            local funcs = NvimFunctionsApiFake.new()
            assert.are.equals('', LinkText.new(NvimApiFake.new('some-nonlink-text', 3), funcs):to_string())
        end)

        it('returns empty string when cursor is not within a link', function ()
            local funcs = NvimFunctionsApiFake.new()
            local text = LinkText.new(NvimApiFake.new(LINE_WITH_SAME_FILE_LINK, 3), funcs)
            assert.are.equals('', text:to_string())
        end)

        it('returns link text for same file link when cursor is at first character of a link', function ()
            local funcs = NvimFunctionsApiFake.new()
            local text = LinkText.new(NvimApiFake.new(LINE_WITH_SAME_FILE_LINK, 4), funcs)
            assert.are.equals(LINK_ACHNOR, text:to_string())
        end)

        it('returns link text for a link when cursor is at the last character of a link', function ()
            local funcs = NvimFunctionsApiFake.new()
            local text = LinkText.new(NvimApiFake.new(LINE_WITH_SAME_FILE_LINK, 19), funcs)
            assert.are.equals(LINK_ACHNOR, text:to_string())
        end)

        it('returns empty string for link with unicode, when cursor is before 1st character', function ()
            local funcs = NvimFunctionsApiFake.new()
            local text = LinkText.new(NvimApiFake.new(SAME_FILE_UNICODE_LINK, 3), funcs)
            assert.are.equals('', text:to_string())
        end)

        it('returns empty string for link with unicode, when cursor is after the last char', function ()
            -- Setting proper byte index for unicode index whitespace after closing ")" of the link
            -- Word "юни" из Unicode, each character is 2 bytes
            local unicode_map = { [19] = 16 }
            local funcs = NvimFunctionsApiFake.new(true, 0, nil, nil, '', unicode_map)
            -- Cursor position is actually zero-based byte index in a string
            local text = LinkText.new(NvimApiFake.new(SAME_FILE_UNICODE_LINK, 19), funcs)
            assert.are.equals('', text:to_string())
        end)

        it('returns link text for link with unicode, when cursor is at the 1st character', function ()
            local funcs = NvimFunctionsApiFake.new()
            local text = LinkText.new(NvimApiFake.new(SAME_FILE_UNICODE_LINK, 4), funcs)
            assert.are.equals(UNICODE_LINK_ANCHOR, text:to_string())
        end)

        it('returns link text for link with unicode, when cursor is at the last character', function ()
            -- Setting proper byte index for unicode index of closing ")" of the link
            -- Word "юни" из Unicode, each character is 2 bytes
            local unicode_map = { [18] = 15 }
            local funcs = NvimFunctionsApiFake.new(true, 0, nil, nil, '', unicode_map)
            -- Cursor position is actually zero-based byte index in a string
            local text = LinkText.new(NvimApiFake.new(SAME_FILE_UNICODE_LINK, 18), funcs)
            assert.are.equals(UNICODE_LINK_ANCHOR, text:to_string())
        end)

        it('returns text for anoter file link without anchor', function ()
            local funcs = NvimFunctionsApiFake.new()
            local text = LinkText.new(NvimApiFake.new('bla ' .. ANOTHER_FILE_LINK .. ' bla', 10), funcs)
            assert.are.equals(FILE_PATH, text:to_string())
        end)
    end)
end)
