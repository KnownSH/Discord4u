local Class = require("@Discord/util/class")
local Constants = require("@Discord/Constants")
local Types = require("@Discord/types")

local OptionTypes = Constants.OptionTypes

local OptionBuilder = {}
OptionBuilder.Impl = {}
OptionBuilder.Construct = {}

function OptionBuilder.Impl.setChoices(self: OptionBuilder, choiceList: { Types.OptionChoice } | Types.OptionChoice)
    local type = self.params.type
    if type == OptionTypes.STRING or type == OptionTypes.INTEGER or type == OptionTypes.NUMBER then
        if (choiceList :: Types.OptionChoice)["name"] ~= nil then
            self.params.choices = {choiceList :: Types.OptionChoice}
        else
            self.params.choices = choiceList
        end
    end
    return self
end

function OptionBuilder.Impl.setDescription(self: OptionBuilder, description: string)
    if #description > 100 then
        error(`Command option Description must be <= 100 characters in length!`)
    end
    self.params.description = description
    return self
end

function OptionBuilder.Impl.setName(self: OptionBuilder, name: string)
    if #name > 32 then
        error(`{name} Command option name must be under 33 characters in length!`)
    end
    self.params.name = name
    return self
end

function OptionBuilder.Construct.choice(name: string, option: string | number): Types.OptionChoice
    return {
        name = name,
        value = option
    }
end

function OptionBuilder.Construct.new(optionType: OptionTypeNames, required: boolean?)
    local optionNumber = Constants.OptionTypes[optionType]
    print(optionNumber)
    return Class(OptionBuilder.Impl) {
        params = {
            type = optionNumber,
            required = required or false
        },
        type = "option"
    } :: OptionBuilder
end

export type OptionTypeNames = "SUB_COMMAND"
    | "SUB_COMMAND_GROUP"
    | "STRING"
    | "INTEGER"
    | "BOOLEAN"
    | "USER"
    | "CHANNEL"
    | "ROLE"
    | "MENTIONABLE"
    | "NUMBER"
    | "ATTACHMENT"

export type OptionBuilder = {
    params: Types.CommandOption,
    type: "option"
} & typeof(OptionBuilder.Impl)

return OptionBuilder.Construct