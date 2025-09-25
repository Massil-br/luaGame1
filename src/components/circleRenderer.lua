local Component = require("src.core.component")
---@class CircleRenderer:Component
---@field color nil|string
---@field offsetX number
---@field offsetY number
---@field sizeX number
---@field sizeY number
---@field transform Transform
local CircleRenderer = setmetatable({},{__index = Component})
CircleRenderer.__index = CircleRenderer
CircleRenderer.__class = "CircleRenderer"
CircleRenderer.isUnique = true

---@param offsetX number?
---@param offsetY number?
---@param sizeX number?
---@param sizeY number?
function CircleRenderer.new(offsetX,offsetY,sizeX,sizeY)
    local self = setmetatable(Component.new(),CircleRenderer)
    self.color = nil
    self.offsetX = offsetX or 0
    self.offsetY = offsetY or 0
    self.sizeX = sizeX or 100
    self.sizeY = sizeY or 100
    return self
end

function CircleRenderer:start()
   self.transform = self.parent.transform
end

function CircleRenderer:draw()
    love.graphics.circle("fill",self.transform.x+self.offsetX,self.transform.y+self.offsetY,self.sizeX,self.sizeY)
end



return CircleRenderer