local NvimApi = {}
NvimApi.__index = NvimApi

function NvimApi.new(raw_api)
    local self = setmetatable({}, NvimApi)

    self.api = raw_api

    return self
end

function NvimApi:nvim_win_get_cursor(window_id)
    return self.api.nvim_win_get_cursor(window_id)
end

function NvimApi:nvim_win_set_cursor(window_id, position)
    self.api.nvim_win_set_cursor(window_id, position)
end

function NvimApi:nvim_buf_get_lines(buffer_num, from, to, strict_indexing)
    return self.api.nvim_buf_get_lines(buffer_num, from, to, strict_indexing)
end

function NvimApi:nvim_set_current_buf(some_buf_num)
    self.api.nvim_set_current_buf(some_buf_num)
end

function NvimApi:nvim_cmd(command, options)
    self.api.nvim_cmd(command, options)
end

function NvimApi:nvim_buf_line_count(buffer_id)
    return self.api.nvim_buf_line_count(buffer_id)
end

return NvimApi
