local Websocket = require("discord4u/discord_websocket").Websocket
local process = require("@lune/process")

local DISCORD_GATEWAY_URL = "wss://gateway.discord.gg"

local function discord_connect()
    Websocket.new(`{DISCORD_GATEWAY_URL}/?v=10&encoding=json`, process.env.DISCORD_TOKEN, 33280):connect()
end

discord_connect()
