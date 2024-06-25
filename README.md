# Vorjal

**Discord4u** is the library, and </br>
**Vorjal** is the bot its api is focused on... ***for now*** *[cue dramatic thunder]*

```luau
-- Discord4u demo (its not much yet)
local process = require("@lune/process")
local DiscordClient = require("@Discord/")
local client = DiscordClient.new({auth = process.env.DISCORD_TOKEN})

client:on("ready", function()
    print("Connection sucessfully established")
end)
```

## What can Vorjal/Discord4u do at the moment?
TLDR: It's not really on par with discord.js or discord.py or discord.net or even [Discord Luau](https://github.com/DiscordLuau/discord-luau) but hey, it can at least send messages!
- Websockets "work" (load-bearing air quotes). It's not complete, but if you're not afraid to get your hands dirty [with this](https://discord.com/developers/docs/topics/gateway-events), you can handle most events.
- The REST/HTTPS API is practically just a figment of my imagination at this point
- The codebase is absolutely unstable, "whats a sharding?"
- It doesn't rate limit 😲

## The Codebase so far...
Its not very pretty, but weirdly its also kinda fine at the same time. I'll clean it up later.

## Why am I making this?
To learn the Discord API, because apparently, I hate myself. While I know there are other (all one of them) Luau Discord bot frameworks, I have very specific, nitpicky reasons for not using them, mostly because of "Roblox holdovers" in codebases that I think have much better alternatives.

**Am I saying you should use Discord4u over any other framework?**</br>Lmao no, however if you like what im cooking up, then feel free to use this.

## What do I want Vorjal/Discord4u to do?
I could rant about how I want to keep it mimimal and whatnot but let me save you some time: </br>
**I want it to do everything** </br>
Yes that is correct, i'm using this as a opportunity to completely learn the Discord API inside and out. The voice API, while it seems like a big hurdle, I do think I have a pretty neat way get around that issue.

**Will it take me longer to program than it has taken Boeing's Starliner to reach orbit?** </br>Probably.

**Is it realistic?** </br>Depends on my mood.
