local Enum = require("util/Enum")

local API: "https://discord.com/api/v10" = "https://discord.com/api/v10"

local Endpoints = {
    CreateGlobalApplicationCommand = "/applications/%s/commands",
    CreateInteractionResponse = "/interactions/%s/%s/callback"
}
export type Endpoints = Enum.EnumItem<typeof(Endpoints)>

local ApplicationCommandTypes = Enum {
    CHAT_INPUT = 1,
    USER = 2,
    MESSAGE = 3
}
export type ApplicationCommandTypes = Enum.EnumItem<typeof(ApplicationCommandTypes)>

local OptionTypes = Enum {
    SUB_COMMAND = 1,
    SUB_COMMAND_GROUP = 2,
    STRING = 3,
    INTEGER = 4,
    BOOLEAN = 5,
    USER = 6,
    CHANNEL = 7,
    ROLE = 8,
    MENTIONABLE = 9,
    NUMBER = 10,
    ATTACHMENT = 11
}
export type OptionTypes = Enum.EnumItem<typeof(OptionTypes)>
export type OptionType = number

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
    API = API,
    ApplicationCommandTypes = ApplicationCommandTypes,
    Endpoints = Endpoints,
    OptionTypes = OptionTypes,
    GatewayOpcodes = GatewayOpcodes,
    GatewayEvents = GatewayEvents
}