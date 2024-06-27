local process = require("@lune/process")
local Discord = require("@Discord/")

local ClientBuilder = Discord.Client
local CommandBuilder = Discord.CommandBuilder
local OptionBuilder = Discord.OptionBuilder
local client = ClientBuilder.new({auth = process.env.DISCORD_TOKEN})
local event = client.event

local pingpong = CommandBuilder.new("SLASH_COMMAND")
    :setName("ping")
    :setDescription("Responds with \"Pong!\" if successful.")

local RPS_CHOICES = {
    rock = {
        description = "sedimentary, igneous, or perhaps even metamorphic",
        virus = "outwaits",
        computer = "smashes",
        scissors = "crushes",
    },
    cowboy = {
        description = "yeehaw~",
        scissors = "puts away",
        wumpus = "lassos",
        rock = "steel-toe kicks",
    },
    scissors = {
        description = "careful ! sharp ! edges !!",
        paper = "cuts",
        computer = "cuts cord of",
        virus = "cuts DNA of",
    },
    virus = {
        description = "genetic mutation, malware, or something inbetween",
        cowboy = "infects",
        computer = "corrupts",
        wumpus = "infects",
    },
    computer = {
        description = "beep boop beep bzzrrhggggg",
        cowboy = "overwhelms",
        paper = "uninstalls firmware for",
        wumpus = "deletes assets for",
    },
    wumpus = {
        description = "the purple Discord fella",
        paper = "draws picture on",
        rock = "paints cute face on",
        scissors = "admires own reflection in",
    },
    paper = {
        description = "versatile and iconic",
        virus = "ignores",
        cowboy = "gives papercut to",
        rock = "covers",
    },
}

local function createCommandChoices()
    local choices = {}
    for name: string in RPS_CHOICES :: {[string]: any} do
        local uppercase = name:gsub("^%l", string.upper)
        table.insert(choices, OptionBuilder.choice(uppercase, name))
    end
    return choices
end

-- discord-example-app RPS challenge recreation
local challengeCommand = CommandBuilder.new("SLASH_COMMAND")
    :setName("challenge")
    :setDescription("Challenge to a match of rock paper scissors")
    :options({
        OptionBuilder.new("STRING", true)
            :setName("object")
            :setDescription("Pick your object")
            :setChoices(createCommandChoices())
    })

event.ready:Connect(function()
    client:register(pingpong)
end)

event.interactionCreated:Connect(function(interaction)
    if interaction.data and interaction.data.name == pingpong.name then
        interaction:reply("Pong!")
    end
end)