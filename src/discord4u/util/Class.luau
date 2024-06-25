--!nocheck

return function<impl>(impl: impl)
    return function<struct>(data: struct): unknown
        local object = setmetatable(data, {
            __index = impl
        })
        return object
    end
end
