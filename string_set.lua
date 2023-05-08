local StringSet = {}
StringSet.__index = StringSet

StringSet.mempty = function()
    local set = setmetatable({}, StringSet)

    return set
end

return StringSet
