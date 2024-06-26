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

local GatewayEvents = Enum {
    READY = "READY",
    INTERACTION_CREATE = "INTERACTION_CREATE",
    MESSAGE_CREATE = "MESSAGE_CREATE"
}
export type GatewayEvents = Enum.EnumItem<typeof(GatewayEvents)>

local InteractionTypes = Enum {
    PING = 1,
    APPLICATION_COMMAND = 2,
    MESSAGE_COMPONENT = 3,
    APPLICATION_COMMAND_AUTOCOMPLETE = 4,
    MODAL_SUBMIT = 5
}
export type InteractionTypes = Enum.EnumItem<typeof(InteractionTypes)>

return {
    GatewayOpcodes = GatewayOpcodes,
    GatewayEvents = GatewayEvents
}