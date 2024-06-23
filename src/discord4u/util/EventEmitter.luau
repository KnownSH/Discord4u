--[=[
    @class EventEmitter
    An event emitter that supports both synchronous and asynchronous event handling.
]=]
local EventEmitter = {}
EventEmitter.Construct = {}
EventEmitter.Impl = {}
EventEmitter.Impl.__index = EventEmitter.Impl

--[=[
    Registers a callback function for a specific event.

    @method on
    @within EventEmitter
    @param event string -- The name of the event
    @param callback function -- The function to be called when the event is emitted
]=]
function EventEmitter.Impl.on(self: EventEmitter, event: string, callback: (...any) -> ())
    self.listeners[event] = self.listeners[event] or {}
    table.insert(self.listeners[event], callback)
end

--[=[
    Emits an event, calling all registered callbacks.
    @method emit
    @within EventEmitter
    @param event string -- The name of the event to emit
    @param ... ...any -- Additional arguments to pass to the callbacks
    @yields
]=]
function EventEmitter.Impl.emit(self: EventEmitter, event: string, ...)
    if self.listeners[event] then
        for _, callback in self.listeners[event] do
            callback(...)
        end
    end
end

--[=[
    Waits for a specific event to occurs
    @method waitFor
    @within EventEmitter

    @param event string -- The name of the event to wait for
    @return ...any -- The arguments passed to the emit function
    @yields -- This function always yields
]=]
function EventEmitter.Impl.waitFor(self: EventEmitter, event: string)
    local co = coroutine.running()
    local function callback(...)
        self:removeListener(event, callback)
        coroutine.resume(co, ...)
    end
    self:on(event, callback)
    return coroutine.yield()
end

--[=[
    Removes a specific listener from an event.
    @method removeListener
    @within EventEmitter

    @param event string -- The name of the event
    @param callback function -- The callback function to remove
]=]
function EventEmitter.Impl.removeListener(self: EventEmitter, event: string, callback)
    if self.listeners[event] then
        local index = table.find(self.listeners[event], callback)
        table.remove(self.listeners[event], index)
    end
end

--[=[
    Creates a new EventEmitter instance.
    @return EventEmitter
    @within EventEmitter
]=]
function EventEmitter.Construct.new()
    local self = {
        listeners = {}
    } 
    return setmetatable(self, EventEmitter.Impl)
end

type EventListeners = { 
    [string]: { (...any) -> () }
}

export type EventEmitter = {
    listeners: EventListeners
} & typeof(EventEmitter.Impl)

return EventEmitter.Construct