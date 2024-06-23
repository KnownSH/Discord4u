local net = require("@lune/net")
local task = require("@lune/task")
local process = require("@lune/process")
local stdio = require("@lune/stdio")

local CloseEventCodes = require("CloseEventCodes")
local WebsocketOpcodes = require("../components/WebsocketOpcodes")
local GatewayOpcodes = WebsocketOpcodes.GatewayOpcodes

local Websocket = {}
Websocket.Construct = {}
Websocket.Impl = {}
Websocket.Impl.__index = Websocket.Impl

local function printTerminal(str)
    stdio.write(stdio.style("bold")..stdio.color("purple").."Discord4u: ")
    stdio.write(stdio.style("reset")..stdio.color("reset"))
    print(str)
end

function Websocket.Impl.connect(self: Websocket, resume: boolean?)
    resume = resume or false
    self.ws = net.socket(self.url)
    self.isRunning = true
    printTerminal("Websocket Started")
    self:listen(resume)
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
            task.wait((self.heartbeatInterval * math.random()) / 1000)
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
    if receivedEvent == "READY" then
        printTerminal("Connection sucessfully established")
        self.url = data['d']["resume_gateway_url"]
        self.sessionId = data['d']["session_id"]
    elseif receivedEvent == "MESSAGE_CREATE" then
        -- TEST
        if data['d']["channel_id"] == "982761892089045064" and data['d']["author"]["id"] ~= "1252925417438838836" then
            local response = net.request({
                url = `https://discord.com/api/v10/channels/{data['d']["channel_id"]}/messages/{data['d']["id"]}`,
                method = "GET",
                headers = {
                    Authorization = `Bot {self.token}`,
                    ["Content-type"] = "application/json; charset=UTF-8",
                    ["User-Agent"] = "DiscordBot (https://knownsh.cc/, 1.0.0)"
                }
            })

            local messageBody = net.jsonDecode(response.body)

            net.request({
                url = `https://discord.com/api/v10/channels/{data['d']["channel_id"]}/messages`,
                method = "POST",
                body = net.jsonEncode({
                    content = `Wow <@!{messageBody.author.id}> said: "{messageBody.content}"`,
                    tts = false
                }),
                headers = {
                    Authorization = `Bot {self.token}`,
                    ["Content-type"] = "application/json; charset=UTF-8",
                    ["User-Agent"] = "DiscordBot (https://knownsh.cc/, 1.0.0)"
                }
            } :: net.FetchParams)
        end
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

function Websocket.Construct.new(url, token, intents)
    local self = {
        url = url,
        heartbeatInterval = nil,
        ws = nil,
        lastSequence = nil,
        heartbeatIntervalId = nil,
        isRunning = false,
        token = token,
        intents = intents,
    }

    return setmetatable(self, Websocket.Impl)
end

export type Websocket = {
    url: string,
    heartbeatInterval: number?,
    ws: net.WebSocket?,
    lastSequence: any,
    heartbeatIntervalId: number?,
    isRunning: boolean,
    token: string,
    intents: number,
    sessionId: number?
} & typeof(Websocket.Impl)

return Websocket.Construct