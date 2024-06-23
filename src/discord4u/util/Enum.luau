local Enum = {}
Enum.__metatable = "Metatable cannot be modified at runtime"

function Enum.__newindex()
    error("Cannot modify an enum constant at runtime")
end

export type EnumItem<TableMap> = TableMap

return function(enumList)
    return setmetatable(enumList, Enum)
end