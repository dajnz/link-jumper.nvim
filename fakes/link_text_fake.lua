local LinkTextFake = {}
LinkTextFake.__index = LinkTextFake

function LinkTextFake.new(link_text)
    local self = setmetatable({}, LinkTextFake)

    self.link_text = link_text

    return self
end

function LinkTextFake:to_string()
    return self.link_text
end


return LinkTextFake
