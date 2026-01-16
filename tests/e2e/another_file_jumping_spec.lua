describe('ANOTHER FILE JUMPING:', function ()
    local Jumper = require('link_jumper.jumper')
    local NvimOpsHelper = require('tests.e2e.fixtures.nvim_ops_helper')

    local LINE_ONE = 1
    local LINE_TEN = 10
    local LINE_WITH_TARGET_LINK = 7
    local LINE_WITH_SOURCE_LINK = 7
    local LINE_WITH_TARGET_TITLE = 3
    local LINE_WITH_LINE_NUM_LINK = 9
    local LINE_WITH_TARGET_TEXT_LINK = 8
    local TARGET_FILE_NAME = 'another-file-jumping-target.txt'
    local SOURCE_FILE_NAME = 'another-file-jumping-source.txt'

    before_each(function ()
        Jumper.clean_history()
        NvimOpsHelper.load_text_file_fixture('another-file-jumping-source.txt')
    end)

    it('makes single and multiple jumps between files', function ()
        -- Inside another-file-jumping-source.txt
        NvimOpsHelper.move_cursor(LINE_WITH_TARGET_LINK)
        Jumper.jump()
        assert.are.equals(LINE_ONE, NvimOpsHelper.cursor_line_num())
        assert.are.equals(TARGET_FILE_NAME, NvimOpsHelper.current_file_name())

        -- Inside another-file-jumping-target.txt
        NvimOpsHelper.move_cursor(LINE_WITH_SOURCE_LINK)
        Jumper.jump()
        assert.are.equals(LINE_ONE, NvimOpsHelper.cursor_line_num())
        assert.are.equals(SOURCE_FILE_NAME, NvimOpsHelper.current_file_name())
    end)

    it('make a jump to specific text of another file', function ()
        NvimOpsHelper.move_cursor(LINE_WITH_TARGET_TEXT_LINK)

        Jumper.jump()

        assert.are.equals(LINE_WITH_TARGET_TITLE, NvimOpsHelper.cursor_line_num())
        assert.are.equals(TARGET_FILE_NAME, NvimOpsHelper.current_file_name())
    end)

    it('makes a jump to specified line of another file', function ()
        NvimOpsHelper.move_cursor(LINE_WITH_LINE_NUM_LINK)

        Jumper.jump()

        assert.are.equals(LINE_TEN, NvimOpsHelper.cursor_line_num())
        assert.are.equals(TARGET_FILE_NAME, NvimOpsHelper.current_file_name())
    end)

    it('returns back by jump history', function ()
        NvimOpsHelper.move_cursor(LINE_WITH_TARGET_LINK)

        Jumper.jump()
        assert.are.equals(TARGET_FILE_NAME, NvimOpsHelper.current_file_name())

        Jumper.go_back()
        assert.are.equals(SOURCE_FILE_NAME, NvimOpsHelper.current_file_name())
        assert.are.equals(LINE_WITH_TARGET_LINK, NvimOpsHelper.cursor_line_num())
    end)
end)

