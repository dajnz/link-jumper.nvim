local M = {}

local NvimApi = require('link_jumper.nvim_api')
local LinkText = require('link_jumper.link_text')
local NvimUiApi = require('link_jumper.nvim_ui_api')
local ParsedLink = require('link_jumper.parsed_link')
local JumpFactory = require('link_jumper.jump_factory')
local AbsolutePaths = require('link_jumper.absolute_paths')
local NvimFunctionsApi = require('link_jumper.nvim_functions_api')
local LinkForwardJump = require('link_jumper.jumps.link_forward_jump')
local InternalJumpHistory = require('link_jumper.internal_jump_history')
local HistoryReturnJump = require('link_jumper.jumps.history_return_jump')

local jump_history = InternalJumpHistory.new()

function M.jump()
    local nvim_api = NvimApi.new(vim.api)
    local nvim_ui_api = NvimUiApi.new(vim.ui)
    local nvim_func_api = NvimFunctionsApi.new(vim.fn)
    local jump = LinkForwardJump.new_for_link(
        ParsedLink.new(
            LinkText.new(nvim_api, nvim_func_api),
            AbsolutePaths.new(nvim_func_api)
        ),
        jump_history,
        JumpFactory.new(nvim_api, nvim_func_api, nvim_ui_api, vim.bo.filetype)
    )

    local original_ignorecase = vim.opt.ignorecase
    vim.opt.ignorecase = true

    local success, result = pcall(function()
        jump:go()
    end)

    vim.opt.ignorecase = original_ignorecase

    if success then
        jump_history = jump:history_after_jump()
    else
        M.notify_user(result)
    end
end

function M.notify_user(some_message)
    vim.notify(some_message, vim.log.levels.INFO, { title = 'link-jumper.nvim'})
end

function M.go_back()
    local back_jump = HistoryReturnJump.new(jump_history)

    if back_jump:jumpable() then
        local success, result = pcall(function ()
            back_jump:go()
        end)

        if success then
            jump_history = back_jump:history_after_return()
        else
            M.notify_user(result)
        end
    else
        M.notify_user('No more jumps in jump history')
    end
end

function M.clean_history()
    jump_history = InternalJumpHistory.new()
end

return M
