local process = require("@lune/process")
local fancyPrint = require("@Discord/components").printTerminal

-- test
local net = require("@lune/net")

local DiscordClient = require("@Discord/")
local client = DiscordClient.new({auth = process.env.DISCORD_TOKEN})
local event = client.event

event.ready:Connect(function()
    fancyPrint("Connection sucessfully established")
    
end)

event.interactionCreated:Connect(function(interaction)
    if interaction.guild and interaction.type == 2 and interaction.data then
        net.request({
            url = `https://discord.com/api/v10/interactions/{interaction.id}/{interaction.token}/callback`,
            method = "POST",
            body = net.jsonEncode({
                type = 4,
                data = {
                    tts = false,
                    content = `Resultant of {interaction.data.name}`,
                    embeds = {}
                }
            }),
            headers = {
                Authorization = `Bot {process.env.DISCORD_TOKEN}`,
                ["Content-type"] = "application/json; charset=UTF-8",
                ["User-Agent"] = "DiscordBot (https://knownsh.cc/, 1.0.0)"
            }
        })
    end
end)