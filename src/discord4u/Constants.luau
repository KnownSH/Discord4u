local Enum = require("util/Enum")

local GatewayOpcodes = Enum {
    EventDispatch = 0,
    Heartbeat = 1,
    Identify = 2,
    PresenceUpdate = 3,
    VoiceStateUpdate = 4,
    Resume = 6,
    Reconnect = 7,
    RequestGuildMembers = 8,
    InvalidSession = 9,
    Hello = 10,
    HeartbeatACK = 11
}
export type GatewayOpcodes = Enum.EnumItem<typeof(GatewayOpcodes)>

return {
    GatewayOpcodes = GatewayOpcodes
}