local Component = require("src.core.component")
---@class Transform : Component
---@field x number
---@field y number
---@field rotation number
---@field scaleX number
---@field scaleY number
---@field new fun(x:number?,y:number?,scaleX:number?,scaleY:number?):Transform
local Transform = setmetatable({},{__index = Component})
Transform.__index = Transform
Transform.__class = "Transform"
Transform.isUnique = true


function Transform.new(x,y,scaleX,scaleY)
    ---@type Transform
    local self = setmetatable(Component.new(),Transform)
    self.x = x or 0
    self.y = y or 0
    self.scaleX = scaleX or 1
    self.scaleY = scaleY or 1
    self.rotation = 0
    return self
end

return Transform