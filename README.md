# Discord4u
**Discord4u** is an abstracted Discord bot library for Luau.

## Update: This project is "kinda not dead" again!
I've been going though some major Luau burnout recently, thankfully it is slowly going away, I won't make any soild promises but I hope to finally get this library into a working/deployable state sometime after the new year.
I plan on finally cleaning up the codebase and slightly changing how you write bots in Discord4u.

```luau
-- Proposed 4u rewrite
local process = require("@lune/process")
local Discord = require("@Discord/")

local CommandBuilder = Discord.CommandBuilder
local client = Discord.client({auth = process.env.DISCORD_TOKEN})
local event = client.event

local pingpong = CommandBuilder.new("SLASH_COMMAND")
    :setName("ping")
    :setDescription("Responds with \"Pong!\" if successful.")

event.ready:Connect(function()
    -- registering commands is no longer needed
end)

pingpong:Connect(function(interaction)
    interaction:reply("Pong!")
end)
```
![image of command working](https://imgur.com/Sdfolb5.png)

## Should you use Discord4u?
The short answer is no, the long answer is that its experimental, and basically untested besides short ~10 min tests i've been doing on a server.

## What can Discord4u do at the moment?
TLDR: It's not really on par with discord.js or discord.py or discord.net or even [Discord Luau](https://github.com/DiscordLuau/discord-luau) but hey, it can at least send messages!
- Websockets "work" (load-bearing air quotes). It's not close to completion, but if you're not afraid to get your hands dirty [with this](https://discord.com/developers/docs/topics/gateway-events), you can handle most events.
- The REST/HTTPS API is practically just a two net requests at this point
- The codebase is absolutely unstable
- It doesn't rate limit (from my testing) 😲

## The Codebase so far...
Its not very pretty, but weirdly its also kinda fine at the same time. I'll clean it up later. Or you reading this can contribute.

## Why am I making this?
To learn the Discord API, because apparently, I hate myself. While I know there are other Luau Discord bot frameworks I decided to make this to learn how to work with the Discord API without using already built libraries.
