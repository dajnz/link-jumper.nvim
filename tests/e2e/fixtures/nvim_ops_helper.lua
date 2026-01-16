local NvimOpsHelper = {}
NvimOpsHelper.__index = NvimOpsHelper

local CURRENT_WINDOW = 0
local FIXTURES_DIR = '/data/tests/e2e/fixtures/files/'

function NvimOpsHelper.load_text_file_fixture(file_name)
    vim.cmd('edit ' .. vim.fn.fnameescape(FIXTURES_DIR .. file_name))
end

function NvimOpsHelper.cursor_line_num()
    return vim.api.nvim_win_get_cursor(CURRENT_WINDOW)[1]
end

function NvimOpsHelper.cursor_column_num()
    return vim.api.nvim_win_get_cursor(CURRENT_WINDOW)[2]
end

function NvimOpsHelper.move_cursor(one_based_line_num, zero_based_column_num)
    local column_num = zero_based_column_num ~= nil and zero_based_column_num or 0
    vim.api.nvim_win_set_cursor(CURRENT_WINDOW, {one_based_line_num, column_num})
end

function NvimOpsHelper.current_file_name()
    return vim.fn.expand('%:t')
end

return NvimOpsHelper
