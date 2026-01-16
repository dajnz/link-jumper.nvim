describe('JumpFactory', function ()
    local UrlJump = require('jumps.url_jump')
    local JumpFactory = require('jump_factory')
    local NvimApiFake = require('nvim_api_fake')
    local NvimUiApiFake = require('nvim_ui_api_fake')
    local ParsedLinkFake = require('parsed_link_fake')
    local FileRegexpJump = require('jumps.file_regexp_jump')
    local FileLineNumJump = require('jumps.file_line_num_jump')
    local NvimFunctionsApiFake = require('nvim_functions_api_fake')
    local FileCursorPosJump = require('jumps.file_cursor_pos_jump')
    local CurrentFileRegexpJump = require('jumps.current_file_regexp_jump')

    local TARGET_LINE_NUM = '777'
    local SOME_URL = 'https://website.com'

    local factory = JumpFactory.new(
        NvimApiFake.new(),
        NvimFunctionsApiFake.new(),
        NvimUiApiFake.new(),
        'non-vim-help-type'
    )

    describe(':make_link_jump()', function ()
        it('creates current file regexp jump for link with empty path and non-empty anchor', function ()
            local jump = factory:make_link_jump(ParsedLinkFake.new('', 'test', false))

            assert.are.equal(CurrentFileRegexpJump.class_name(), jump.class_name())
        end)

        it('creates external file regexp jump for file link with non-empty path', function ()
            local jump = factory:make_link_jump(ParsedLinkFake.new('/some/file.md', '', false))

            assert.are.equal(FileRegexpJump.class_name(), jump:class_name())
        end)

        it('creates external file regexp jump for file link with non empty path and pattern', function ()
            local jump = factory:make_link_jump(ParsedLinkFake.new('/some/file.md', 'test', false))

            assert.are.equal(FileRegexpJump.class_name(), jump:class_name())
        end)

        it('creates file line number jump for link with line number as anchor', function ()
            local link = ParsedLinkFake.new('/some/file.md', TARGET_LINE_NUM, false)
            local jump = factory:make_link_jump(link)

            assert.are.equal(FileLineNumJump.class_name(), jump:class_name())
        end)

        it('creates url jump for link with url', function ()
            local link = ParsedLinkFake.new(SOME_URL, '', true)
            local jump = factory:make_link_jump(link)

            assert.are.equal(UrlJump.class_name(), jump:class_name())
        end)

        -- add jump for vim help
    end)

    describe(':make_current_location_jump()', function ()
        it('creates file position jump if current buffer is regular file buffer', function ()
            local jump = factory:make_current_location_jump()

            assert.are.equal(FileCursorPosJump.class_name(), jump:class_name())
        end)

        -- it creates vim help jump if current buffer is vim help buffer
    end)
end)
