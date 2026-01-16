local UrlJump = {}
UrlJump.__index = UrlJump

function UrlJump.new(url, nvim_ui_api)
    local self = setmetatable({}, UrlJump)

    self.url = url
    self.api = nvim_ui_api

    return self
end

function UrlJump.class_name()
    return 'UrlJump'
end

function UrlJump:to_external_app()
    return true
end

function UrlJump:within_current_file()
    return false
end

function UrlJump:go()
    self.api:open(self.url)
end

return UrlJump
