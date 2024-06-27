local net = require("@lune/net")
local task = require("@lune/task")
local process = require("@lune/process")

local CloseEventCodes = require("CloseEventCodes")
local Components = require("../components")
local Constants = require("../Constants")
local Signal = require("@Discord/util/Signal")
local Class = require("@Discord/util/Class")
local Types = require("@Discord/types")
local InteractionClass = require("@Discord/components/Interaction")

local printTerminal = Components.printTerminal
local GatewayOpcodes, GatewayEvents = Constants.GatewayOpcodes, Constants.GatewayEvents

local Websocket = {}
Websocket.Construct = {}
Websocket.Impl = {}

function Websocket.Impl.connect(self: Websocket, resume: boolean?)
    resume = resume or false
    self.ws = net.socket(self.url)
    self.isRunning = true
    printTerminal("Websocket Started")
    task.spawn(function()
        self:listen(resume)
    end)
    return self
end

function Websocket.Impl.listen(self: Websocket, resume)
    local success, _data = xpcall(function()
        while self.isRunning do
            local message = self.ws.next()
            if not message then
                return false
            end
            self:handleMessage(message, resume)
        end 
        return true
    end, function(err)
        printTerminal(`Websocket error: {error}`)
    end)

    if success then
        printTerminal(`Websocket connection closed. Code: {self.ws.closeCode} {CloseEventCodes[self.ws.closeCode]}`)
        if self.isRunning then
            self:connect()
        end
    end
end

function Websocket.Impl.sendHeartbeat(self: Websocket)
    local heartbeatPayload = {
        op = 1,
        d = self.lastSequence or false
    }
    self.ws.send(net.jsonEncode(heartbeatPayload))
end

function Websocket.Impl.startHeartbeat(self: Websocket)
    task.spawn(function()
        while self.isRunning do
            self:sendHeartbeat()
            task.wait((self.heartbeatInterval :: number * math.random()) / 1000)
        end
    end)
end

function Websocket.Impl.sendIdentity(self: Websocket)
    local identityPayload = {
        op = 2,
        d = {
            token = self.token,
            intents = self.intents,
            properties = {
                os = process.os,
                browser = "discord4u",
                device = "discord4u"
            }
        }
    }
    self.ws.send(net.jsonEncode(identityPayload))
end

function Websocket.Impl.sendResume(self: Websocket)
    local resumePayload = {
        op = 6,
        d = {
            token = self.token,
            session_id = self.sessionId,
            seq = self.lastSequence
        }
    }
    self.ws.send(net.jsonEncode(resumePayload))
end

function Websocket.Impl.handleEvent(self: Websocket, data)
    local receivedEvent = data['t']
    if receivedEvent == GatewayEvents.READY then
        self.url = data['d']["resume_gateway_url"]
        self.sessionId = data['d']["session_id"]
        self.applicationId = data['d']["application"]["id"]
        self.events.ready:Fire()
    elseif receivedEvent == GatewayEvents.INTERACTION_CREATE then
        self.events.interactionCreated:Fire(InteractionClass.new(data['d'], self.headers))
    elseif receivedEvent == GatewayEvents.MESSAGE_CREATE then
        print("message")
    else
        print(data['t'])
    end
end

function Websocket.Impl.handleReconnect(self: Websocket)
    self.ws.close(1000)
    self.isRunning = false
    self:connect()
end

function Websocket.Impl.handleHello(self: Websocket, data, resume)
    self.heartbeatInterval = data['d']["heartbeat_interval"]
    self:startHeartbeat()
    if resume and self.sessionId then
        self:sendResume()
    else
        self:sendIdentity()
    end
end

function Websocket.Impl.handleMessage(self: Websocket, message, resume)
    local data = net.jsonDecode(message)
    if data['s'] then
        self.lastSequence = data['s']
    end

    local opcode = data['op']
    if opcode == GatewayOpcodes.EventDispatch then
        self:handleEvent(data)
    elseif opcode == GatewayOpcodes.Heartbeat then
        self:sendHeartbeat()
    elseif opcode == GatewayOpcodes.Reconnect then
        self:handleReconnect()
    elseif opcode == GatewayOpcodes.InvalidSession then
        -- TODO retry
    elseif opcode == GatewayOpcodes.Hello then
        self:handleHello(data, resume)
    elseif opcode == GatewayOpcodes.HeartbeatACK then
        -- Heartbeat recieved by discord
    end
end

function Websocket.Construct.new<T>(
    url: string, 
    token: string, 
    intents: number, 
    events: Types.Discord4uEvents<InteractionClass.Interaction>,
    headers
)
    return Class(Websocket.Impl) {
        url = url,
        heartbeatInterval = nil,
        ws = nil,
        lastSequence = nil,
        isRunning = false,
        token = token,
        intents = intents,
        events = events,
        headers = headers
    } :: Websocket
end

export type Websocket = {
    url: string,
    heartbeatInterval: number?,
    ws: net.WebSocket,
    lastSequence: any,
    isRunning: boolean,
    token: string,
    intents: number,
    sessionId: number?,
    events: Types.Discord4uEvents<InteractionClass.Interaction>,
    headers: any,
    applicationId: number?
} & typeof(Websocket.Impl)

return Websocket.Construct