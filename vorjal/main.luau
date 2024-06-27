local process = require("@lune/process")
local Discord = require("@Discord/")

local ClientBuilder = Discord.Client
local CommandBuilder = Discord.CommandBuilder
local client = ClientBuilder.new({auth = process.env.DISCORD_TOKEN})
local event = client.event

local pingpong = CommandBuilder.new("SLASH_COMMAND")
    :setName("ping")
    :setDescription("Responds with \"Pong!\" if successful.")

event.ready:Connect(function()
    client:register(pingpong)
end)

event.interactionCreated:Connect(function(interaction)
    if interaction.data and interaction.data.name == pingpong.name then
        interaction:reply("Pong!")
    end
end)