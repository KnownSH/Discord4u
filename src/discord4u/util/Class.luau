--!nocheck

return function<struct, impl>(data: struct, impl: impl): struct & impl
    local object = setmetatable(data, {
        __index = impl
    })
    return object
end
