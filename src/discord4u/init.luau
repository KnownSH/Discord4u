local Websocket = require("gateway/Websocket")
local EventEmitter = require("util/EventEmitter")
local Class = require("util/Class")

local Discord4u = {}
Discord4u.Construct = {}
Discord4u.Impl = {}

function Discord4u.Impl.on(self: Discord4u, event: EventString, handler: (...any) -> nil)
    self.events:on(event, handler)
end

function Discord4u.Construct.new(options: ClientOptions)
    local events = EventEmitter.new()
    local websocket = Websocket.new(`wss://gateway.discord.gg/?v=10&encoding=json`, options.auth, 33280, events):connect()

    return Class(Discord4u.Impl) {
        websocket = websocket,
        events = events
    } :: Discord4u
end

export type EventString = "ready"

export type ClientOptions = {
    auth: string,
}

export type Discord4u = {
    websocket: Websocket.Websocket,
    events: EventEmitter.EventEmitter
} & typeof(Discord4u.Impl)

return Discord4u.Construct