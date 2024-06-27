local net = require("@lune/net")
local Constants = require("@Discord/Constants")
local Class = require("@Discord/util/Class")
local Types = require("@Discord/types")
local ApplicationCommandTypes = require("@Discord/Constants").ApplicationCommandTypes

local CommandBuilder = {}
CommandBuilder.Impl = {}
CommandBuilder.Construct = {}

function CommandBuilder.Impl.register(self: CommandBuilder, id, headers)
    local url = `{Constants.API}{Constants.Endpoints.CreateGlobalApplicationCommand:format(tostring(id))}`
    local response = net.request({
        url = url,
        method = "POST",
        body = net.jsonEncode(self.params),
        headers = headers
    })
    local responseBody = net.jsonDecode(response.body)
    if response.statusCode == 200 or response.statusCode == 201 then
        self.id = responseBody.id
        self.name = responseBody.name
    end
end

function CommandBuilder.Impl.options(self: CommandBuilder, optionsList)
    if optionsList["type"] ~= nil then
        self.params.options = {optionsList.params}
    else
        local optionParamList = {}
        for _, option: {[string]: any} in optionsList :: any do
            table.insert(optionParamList, option.params)
        end
        self.params.options = optionParamList
    end
    return self
end

function CommandBuilder.Impl.setDescription(self: CommandBuilder, description: string): CommandBuilder
    if #description > 100 then
        error(`Command Description must be <= 100 characters in length!`)
    end
    self.params.description = description
    return self
end

function CommandBuilder.Impl.setName(self: CommandBuilder, name: string): CommandBuilder
    if #name > 32 then
        error(`{name} Command name must be under 33 characters in length!`)
    end
    self.params.name = name
    return self
end

local function parseCommandType(commandType) 
    return if not commandType or commandType == "SLASH_COMMAND" then 
            ApplicationCommandTypes.CHAT_INPUT
        elseif commandType == "USER" then 
            ApplicationCommandTypes.USER
        else 
            ApplicationCommandTypes.MESSAGE
end

function CommandBuilder.Construct.new(commandType: CommandTypes?): CommandBuilder
    return Class(CommandBuilder.Impl) {
        params = {
            type = parseCommandType(commandType)
        },
        type = "command"
    } :: CommandBuilder
end

type CommandTypes = "SLASH_COMMAND" | "USER" | "MESSAGE"

export type CommandBuilder = {
    params: any,
    type: "command",
    id: string?,
    name: string?,
    options: any
} & typeof(CommandBuilder.Impl)

return CommandBuilder.Construct