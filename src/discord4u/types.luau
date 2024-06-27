local Signal = require("util/Signal")
local Constants = require("Constants")

export type ApplicationCommandParameter = {
    name: string,
    type: number,
    value: (string | number | boolean)?,
    options: { ApplicationCommandParameter }?,
    focused: boolean?
}

export type ApplicationCommandData = {
    id: string,
    name: string,
    type: number,
    -- TODO resolved
    options: { ApplicationCommandParameter }?,
    guild_id: number?,
    target_id: number?
}

export type RoleTags = {
    bot_id: number?,
    integration_id: number?,
    premium_subscriber: unknown?,
    subscription_listing_id: number?,
    available_for_purchase: unknown?,
    guild_connections: unknown?
}

export type Role = {
    id: string,
    name: string,
    color: number,
    hoist: boolean,
    icon: number?,
    unicode_emoji: string?,
    position: number,
    permissions: string,
    managed: boolean,
    mentionable: boolean,
    tags: RoleTags?,
    flags: number
}

export type Guild = {
    id: string,
    name: string,
    icon: string?,
    icon_hash: string?,
    splash: string?,
    discovery_splash: string?,
    owner_id: number,
    afk_channel_id: number?,
    afk_timeout: number,
    widget_enabled: boolean?,
    widget_channel_id: number?,
    verification_level: number,
    default_message_notifications: number,
    explicit_content_filter: number,
    roles: { Role },
    [any]: any
}

export type Interaction<InteractionData> = {
    id: string,
    application_id: string,
    type: number,
    data: InteractionData?,
    guild: Guild?,
    guild_id: number?,
    token: string,
    [any]: any
}

type BaseCommand = {
    type: number,
    name: string,
    description: string,
}

export type OptionChoice = {
    name: string,
    value: string | number
}

export type CommandOption = BaseCommand & {
    required: boolean?,
    choices: { OptionChoice }
}

export type Discord4uEvents<I> = {
    ready: Signal.Signal<>,
    interactionCreated: Signal.Signal<I>
}

return {}