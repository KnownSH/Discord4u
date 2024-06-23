local Websocket = require("gateway/Websocket")
local EventEmitter = require("util/EventEmitter")

local Discord4u = {}
Discord4u.Construct = {}
Discord4u.Impl = {}
Discord4u.Impl.__index = Discord4u.Impl

function Discord4u.Impl.on(self: Discord4u, event: EventString, handler: (...any) -> nil)
    self.events:on(event, handler)
end

function Discord4u.Construct.new(options: ClientOptions)
    local self = {}

    self.events = EventEmitter.new()
    self.websocket = Websocket.new(`wss://gateway.discord.gg/?v=10&encoding=json`, options.auth, 33280, self.events)

    self.websocket:connect()
    return setmetatable(self, Discord4u.Impl)
end

export type EventString = "ready"
export type ClientOptions = {
    auth: string,
}
export type Discord4u = {
    websocket: Websocket.Websocket,
    events: EventEmitter.EventEmitter
}

return Discord4u.Construct