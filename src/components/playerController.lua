local Component = require("src.core.component")
---@class PlayerController:Component
---@field speed number
---@field transform Transform
local PlayerController = setmetatable({},{__index = Component})
PlayerController.__index = PlayerController
PlayerController.__class = "PlayerController"
PlayerController.isUnique = true

---@param speed number?
---@return PlayerController
function PlayerController.new(speed)
    ---@type PlayerController
    local self = setmetatable(Component.new(),PlayerController)
    self.speed = speed or 50
    self:setTransform()

    return self
end

function PlayerController:start()
    self.transform = self.parent:getComponent("Transform")
end

---@param dt  number
function PlayerController:update(dt)
    if love.keyboard.isDown("z") then
        self.transform.y = self.transform.y - self.speed*dt
    end
    if love.keyboard.isDown("s") then
        self.transform.y = self.transform.y + self.speed*dt
    end
    if love.keyboard.isDown("q") then
        self.transform.x = self.transform.x - self.speed*dt
    end
    if love.keyboard.isDown("d") then
        self.transform.x = self.transform.x + self.speed*dt
    end
end
return PlayerController