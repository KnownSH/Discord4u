local Websocket = require("gateway/Websocket")
local Signal = require("util/Signal")
local Class = require("util/Class")
local Constants = require("Constants")
local Types = require("types")
local Interaction = require("components/Interaction")

local Discord4u = {}
Discord4u.Construct = {}
Discord4u.Construct.Headers = {}
Discord4u.Impl = {}

function Discord4u.Impl.register(self: Discord4u, registryObject)
    if registryObject.type == "command" then
        registryObject:register(self.websocket.applicationId, self.headers)
    end
end

function Discord4u.Construct.new(options: ClientOptions)
    local events = {
        ready = Signal.new(),
        interactionCreated = Signal.new()
    }
    local headers = {
        Authorization = `Bot {options.auth}`,
        ["Content-type"] = "application/json; charset=UTF-8",
        ["User-Agent"] = "DiscordBot (https://knownsh.cc/, 1.0.0)"
    }
    local websocket = Websocket.new(`wss://gateway.discord.gg/?v=10&encoding=json`, options.auth, 34316, events, headers):connect()

    return Class(Discord4u.Impl) {
        websocket = websocket,
        event = events,
        headers = headers
    } :: Discord4u
end

export type EventString = "ready"
    | "interactionCreated"

export type ClientOptions = {
    auth: string,
}

export type Discord4u = {
    websocket: Websocket.Websocket,
    event: Types.Discord4uEvents<Interaction.Interaction>,
    headers: {[any]: any}
} & typeof(Discord4u.Impl)

return {
    Client = Discord4u.Construct,
    CommandBuilder = require("builders/CommandBuilder"),
    OptionBuilder = require("builders/OptionBuilder")
}