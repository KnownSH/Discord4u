local Signal = require("util/Signal")
local Constants = require("Constants")

-- Type definition for Discords API V10

-- Other --

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

export type AvatarDecorationData = {
    asset: string,
    sku_id: string
}

export type User = {
    id: string,
    username: string,
    discriminator: string,
    global_name: string?,
    avatar: string?,
    bot: boolean?,
    system: boolean?,
    mfa_enabled: boolean?,
    banner: string?,
    accent_color: number?,
    locale: string?,
    verified: boolean?,
    email: string?,
    flags: number?,
    premium_type: number?,
    public_flags: number?,
    avatar_decoration_data: AvatarDecorationData?
}

export type Interaction<InteractionData> = {
    id: string,
    application_id: string,
    type: number,
    data: InteractionData?,
    guild: Guild?,
    guild_id: number?,
    user: User?,
    token: string,
    version: number,

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

-- Message Object --

export type ChannelMention = {
    id: string,
    guild_id: string,
    type: number,
    name: string
}

export type Attachment = {
    id: string,
    filename: string,
    title: string?,
    description: string?,
    content_type: string?,
    size: number,
    url: string,
    proxy_url: string,
    height: number?,
    width: number?,
    ephemeral: boolean?,
    duration_secs: number?,
    waveform: string?,
    flags: number?
}

export type Embed = {
    title: string?,
    type: string?,
    description: string?,
    url: string?,
    timestamp: string?,
    color: number?,
    footer: {
        text: string,
        icon_url: string?,
        proxy_icon_url: string?
    }?,
    image: {
        url: string,
        proxy_url: string?,
        height: number?,
        width: number?
    }?,
    thumbnail: {
        url: string,
        proxy_url: string?,
        height: number?,
        width: number?
    }?,
    video: {
        url: string?,
        proxy_url: string?,
        height: number?,
        width: number?
    }?,
    provider: {
        name: string?,
        url: string?
    }?,
    author: {
        name: string,
        url: string?,
        icon_url: string?,
        proxy_icon_url: string?
    }?,
    fields: {{
        name: string,
        value: string,
        inline: boolean?
    }}?
}

export type Emoji = { -- Partial
    id: string?,
    name: string?,
    roles: { Role }?,
    user: User?,
    require_colons: boolean?,
    managed: boolean?,
    animated: boolean?,
    available: boolean?
}

export type Reaction = {
    count: number,
    count_details: {
        burst: number,
        normal: number
    },
    me: boolean,
    me_burst: boolean,
    emoji: Emoji,
    burst_color: { any }
}

export type MessageActivity = {
    type: number,
    party_id: string?
}

type _ApplicationCommon = {
    icon: string?,
    rpc_origins: { string }?,

}

export type Message = {
    id: string,
    channel_id: string,
    author: User,
    content: string,
    timestamp: string,
    edited_timestamp: string?,
    tts: boolean,
    mention_everyone: boolean,
    mentions: { User },
    mention_roles: any, -- UNFINISHED
    mention_channels: { ChannelMention }?,
    attachments: { Attachment },
    embeds: { Embed },
    reactions: { Reaction },
    nonce: (string | number)?,
    pinned: boolean,
    webhook_id: string?,
    type: number,
    activity: MessageActivity?,

}

export type Discord4uEvents<I> = {
    ready: Signal.Signal<>,
    interactionCreated: Signal.Signal<I>
}

return {}