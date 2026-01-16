local NvimFunctionsApi = {}
NvimFunctionsApi.__index = NvimFunctionsApi

function NvimFunctionsApi.new(raw_functions_api)
    local self = setmetatable({}, NvimFunctionsApi)

    self.api = raw_functions_api

    return self
end

function NvimFunctionsApi:getcwd()
    return self.api.getcwd()
end

function NvimFunctionsApi:expand(path)
    return self.api.expand(path)
end

function NvimFunctionsApi:resolve(path)
    return self.api.resolve(path)
end

function NvimFunctionsApi:filereadable(path)
    return self.api.filereadable(path)
end

function NvimFunctionsApi:bufnr()
    return self.api.bufnr()
end

function NvimFunctionsApi:fnameescape(path)
    return self.api.fnameescape(path)
end

function NvimFunctionsApi:search(regexp)
    return self.api.search(regexp)
end

function NvimFunctionsApi:setreg(register, value)
    self.api.setreg(register, value)
end

function NvimFunctionsApi:charidx(current_line, cursor_byte_pos)
    return self.api.charidx(current_line, cursor_byte_pos)
end

return NvimFunctionsApi
