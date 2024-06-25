local process = require("@lune/process")
local fancyPrint = require("@Discord/components").printTerminal

local DiscordClient = require("@Discord/")
local client = DiscordClient.new({auth = process.env.DISCORD_TOKEN})

client:on("ready", function()
    fancyPrint("Connection sucessfully established")
end)