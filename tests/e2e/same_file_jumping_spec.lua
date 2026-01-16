describe('SAME FILE JUMPING:', function ()
    local Jumper = require('link_jumper.jumper')
    local NvimOpsHelper = require('tests.e2e.fixtures.nvim_ops_helper')

    local LINE_WITH_LINK_ONE = 15
    local LINE_WITH_LINK_TWO = 16
    local LINE_WITH_DASH_SEPARATED_LINK = 17

    local LINE_WITH_TITLE_ONE = 3
    local LINE_WITH_TITLE_TWO = 7
    local LINE_WITH_DASH_SEARATED_TITLE = 11

    before_each(function ()
        NvimOpsHelper.load_text_file_fixture('same-file-jumping.txt')
    end)

    it('single and multiple jumps to space-separated text work properly', function ()
        NvimOpsHelper.move_cursor(LINE_WITH_LINK_ONE)
        Jumper.jump()
        assert.are.equals(LINE_WITH_TITLE_ONE, NvimOpsHelper.cursor_line_num())

        NvimOpsHelper.move_cursor(LINE_WITH_LINK_TWO)
        Jumper.jump()
        assert.are.equals(LINE_WITH_TITLE_TWO, NvimOpsHelper.cursor_line_num())
    end)

    it('jump to dash-separated text works properly', function ()
        NvimOpsHelper.move_cursor(LINE_WITH_DASH_SEPARATED_LINK)

        Jumper.jump()
        
        assert.are.equals(LINE_WITH_DASH_SEARATED_TITLE, NvimOpsHelper.cursor_line_num())
    end)

    it('returns cursor to previous position when going back by jump history', function ()
        NvimOpsHelper.move_cursor(LINE_WITH_LINK_ONE)
        Jumper.jump()
        NvimOpsHelper.move_cursor(LINE_WITH_LINK_TWO)
        Jumper.jump()

        Jumper.go_back()
        assert.are.equals(LINE_WITH_LINK_TWO, NvimOpsHelper.cursor_line_num())

        Jumper.go_back()
        assert.are.equals(LINE_WITH_LINK_ONE, NvimOpsHelper.cursor_line_num())
    end)
end)
