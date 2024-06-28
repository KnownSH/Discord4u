# Vorjal

**Discord4u** is the library, and </br>
**Vorjal** is the bot its api is focused on... ***for now*** *[cue dramatic thunder]*

```luau
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
```
![image of command working](https://imgur.com/Sdfolb5.png)

## Should you use Discord4u?
The short answer is no, the long answer is that its experimental, and basically untested besides short ~10 min tests i've been doing on a server.

## What can Vorjal/Discord4u do at the moment?
TLDR: It's not really on par with discord.js or discord.py or discord.net or even [Discord Luau](https://github.com/DiscordLuau/discord-luau) but hey, it can at least send messages!
- Websockets "work" (load-bearing air quotes). It's not close to completion, but if you're not afraid to get your hands dirty [with this](https://discord.com/developers/docs/topics/gateway-events), you can handle most events.
- The REST/HTTPS API is practically just a two net requests at this point
- The codebase is absolutely unstable
- But it doesn't rate limit (from my testing) 😲

## The Codebase so far...
Its not very pretty, but weirdly its also kinda fine at the same time. I'll clean it up later. Or you reading this can contribute.

## Why am I making this?
To learn the Discord API, because apparently, I hate myself. While I know there are other (all one of them) Luau Discord bot frameworks, I have very specific, nitpicky reasons for not using them, mostly because of "Roblox holdovers" in codebases that I think have much better alternatives.

## What do I want Vorjal/Discord4u to do?
I could rant about how I want to keep it mimimal and whatnot but let me save you some time: </br>
**I want it to do everything** </br>
Yes that is correct, i'm using this as a opportunity to completely learn the Discord API inside and out. The voice API, while it seems like a big hurdle, I do think I have a pretty neat way get around that issue.

**Will it take me longer to program than it has taken Boeing's Starliner to reach orbit?** </br>Probably.

**Is it realistic?** </br>Depends on my mood.
