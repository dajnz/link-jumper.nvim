local M = {}
local jumper = require('link_jumper.jumper')
local default_config = {
    enabled = true,
}

M.config = vim.tbl_deep_extend('force', default_config, {})

function M.setup(opts)
    M.config = vim.tbl_deep_extend('force', default_config, opts or {})
    M.initialize()
end

function M.initialize()
    if not M.config.enabled then return end

    vim.api.nvim_create_user_command(
        'LinkJumperJump',
        function () jumper.jump() end,
        {desc = 'Jump to the link under the cursor'}
    )

    vim.api.nvim_create_user_command(
        'LinkJumperGoBack',
        function () jumper.go_back() end,
        {desc = 'Return back in jump history'}
    )

    vim.keymap.set('n', '<leader>lj', '<cmd>LinkJumperJump<cr>', { desc = 'Jump to the link under the cursor' })
    vim.keymap.set('n', '<leader>lb', '<cmd>LinkJumperGoBack<cr>', { desc = 'Return back in jump history' })
end

return M
