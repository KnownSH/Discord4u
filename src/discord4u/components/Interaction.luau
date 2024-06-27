local net = require("@lune/net")

local Types = require("@Discord/types")
local Constants = require("@Discord/Constants")
local Class = require("@Discord/util/class")

local Interaction = {}
Interaction.Impl = {}
Interaction.Construct = {}

Interaction.Headers = {}

function Interaction.Impl.reply(self: Interaction, response: string)
    local url = `{Constants.API}{Constants.Endpoints.CreateInteractionResponse:format(tostring(self.id), self.token)}`
    local reply = net.request({
        url = url,
        method = "POST",
        body = net.jsonEncode({
            type = 4,
            data = {
                tts = false,
                content = response,
                embeds = {}
            }
        }),
        headers = Interaction.Headers
    })
end

function Interaction.Construct.new<T>(interaction: Types.Interaction<T>, headers)
    Interaction.Headers = headers
    return Class(Interaction.Impl)(interaction) :: Interaction
end

export type Interaction = Types.Interaction<Types.ApplicationCommandData> & typeof(Interaction.Impl)

return Interaction.Construct