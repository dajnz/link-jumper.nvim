local ParsedLinkFake = {}
ParsedLinkFake.__index = ParsedLinkFake

function ParsedLinkFake.new(abs_path, pattern, is_web)
    local self = setmetatable({}, ParsedLinkFake)

    self.abs_path = abs_path ~= nil and abs_path or ''
    self.pattern = pattern ~= nil and pattern or ''
    self.is_web = is_web ~= nil and is_web or false

    return self
end

function ParsedLinkFake:absolute_path()
    return self.abs_path
end

function ParsedLinkFake:anchor_search_pattern()
    return self.pattern
end

function ParsedLinkFake:internal_file_link()
    return self.pattern ~= '' and self.abs_path == ''
end

function ParsedLinkFake:external_file_link()
    return self.abs_path ~= '' and self.is_web == false
end

function ParsedLinkFake:web_link()
    return self.is_web
end

return ParsedLinkFake
