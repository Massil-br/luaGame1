local Component = require("src.core.component")
---@class Camera:Component
---@field zoom number
---@field new fun(zoom:number?):Camera
local Camera = setmetatable({},{__index = Component})
Camera.__index = Camera
Camera.__class = "Camera"
Camera.isUnique = true


---@param zoom number?
---@return Camera
function Camera.new(zoom)
    ---@type Camera
    local self = setmetatable({},Camera)
    self.zoom = zoom or 1
    self:setTransform()
    return self
end

function Camera:attach()
    love.graphics.push()
    ---@type Transform
    local t = self:getComponent("Transform")
    if t then
        local screenWidth = love.graphics.getWidth()
        local screenHeight = love.graphics.getHeight()
        
        love.graphics.translate(screenWidth / 2, screenHeight / 2)
        love.graphics.rotate(-t.rotation)
        love.graphics.scale(self.zoom * t.scaleX, self.zoom * t.scaleY)
        
        -- Centrer sur le joueur (parent de l'entité caméra)
        if self.parent and self.parent.parent then
            ---@type Transform
            local playerTransform = self.parent.parent:getComponent("Transform")
            if playerTransform then
                love.graphics.translate(-playerTransform.x, -playerTransform.y)
            end
        end
    else
        error("cant get transform in camera")
    end
end

function Camera:detach()
    love.graphics.pop()
end

function Camera:start()

end

---@param dt number
function Camera:update(dt)
    -- Ne pas suivre le joueur - la caméra reste à (0,0)
    -- Le joueur sera dessiné à sa position relative
end

function Camera:draw()

end

return Camera