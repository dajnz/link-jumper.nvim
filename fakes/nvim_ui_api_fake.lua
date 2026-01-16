local NvimUiApiFake = {}
NvimUiApiFake.__index = NvimUiApiFake

function NvimUiApiFake.new()
    local self = setmetatable({}, NvimUiApiFake)

    self.last_opened_url = ''

    return self
end

function NvimUiApiFake:open(url)
    self.last_opened_url = url
end

-- Fake helper methods

function NvimUiApiFake:opened_url()
    return self.last_opened_url
end

return NvimUiApiFake
