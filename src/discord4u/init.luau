local Websocket = require("gateway/Websocket")
local Signal = require("util/Signal")
local Class = require("util/Class")
local Constants = require("Constants")
local Types = require("types")

local Discord4u = {}
Discord4u.Construct = {}
Discord4u.Impl = {}

function Discord4u.Construct.new(options: ClientOptions)
    local events = {
        ready = Signal.new(),
        interactionCreated = Signal.new()
    }
    local websocket = Websocket.new(`wss://gateway.discord.gg/?v=10&encoding=json`, options.auth, 34316, events):connect()

    return Class(Discord4u.Impl) {
        websocket = websocket,
        event = events
    } :: Discord4u
end

export type EventString = "ready"
    | "interactionCreated"

export type ClientOptions = {
    auth: string,
}

export type Discord4u = {
    websocket: Websocket.Websocket,
    event: Types.Discord4uEvents
} & typeof(Discord4u.Impl)

return Discord4u.Construct