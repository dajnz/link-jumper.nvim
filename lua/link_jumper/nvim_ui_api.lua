local NvimUiApi = {}
NvimUiApi.__index = NvimUiApi

function NvimUiApi.new(raw_nvim_ui_api)
    local self = setmetatable({}, NvimUiApi)

    self.api = raw_nvim_ui_api

    return self
end

function NvimUiApi:open(url)
    self.api.open(url)
end

return NvimUiApi
