local process = require("@lune/process")
local fancyPrint = require("@Discord/components").printTerminal

local Client = require("@Discord/init")
local client = Client.new({auth = process.env.DISCORD_TOKEN})

client:on("ready", function()
    fancyPrint("Connection sucessfully established")
end)