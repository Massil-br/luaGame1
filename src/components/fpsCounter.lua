local Component = require("src.core.component")

---@class FpsCounter:Component
---@field counter number
---@field frames number
---@field fpsDisplay number
local FpsCounter = setmetatable({},{__index = Component})
FpsCounter.__index = FpsCounter
FpsCounter.__class = "FpsCounter"
FpsCounter.isUnique = true


function FpsCounter.new()
    local self = setmetatable(Component.new(),FpsCounter)
    self.counter = 0
    self.frames = 0
    self.fpsDisplay = 0
    self:setTransform()
    return self
end

---@param dt number
function FpsCounter:update(dt)
    self.frames = self.frames +1
    self.counter = self.counter + dt
    if self.counter >= 1 then
        self.fpsDisplay = self.frames
        self.frames = 0
        self.counter = 0
        print(self.fpsDisplay .." fps")
    end
end

function FpsCounter:start()
    self.transform = self.parent.transform
end

function FpsCounter:draw()
    love.graphics.print(self.fpsDisplay .. " fps", self.transform.x, self.transform.y)
end


return FpsCounter