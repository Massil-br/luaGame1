
---@class Component
---@field id number
---@field parent Entity|nil
---@field isUnique boolean
---@field new fun(parent:Entity|nil):Component
---@field start fun(self:Component)
---@field init fun(self:Component)
---@field update fun(self:Component,dt:number)
---@field draw fun(self:Component)
---@field extend fun(self:Component,className:string):any
local Component = {}

Component.__index = Component
Component.__class = "Component"
Component.isUnique = true

local componentId =0


function Component.new(parent)
    componentId = componentId +1
    local self = setmetatable({},Component)
    self.id = componentId
    self.parent = parent or nil
    return self
end

function Component:start()end
function Component:update(dt)end
function Component:draw()end


return Component