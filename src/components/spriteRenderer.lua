local Component = require("src.core.component")
local Colors = require("src.core.color")
local TextureManager = require("src.core.textureManager")

---@class SpriteRenderer:Component
---@field texture love.Image|nil
---@field offsetX number
---@field offsetY number
---@field rotation number
---@field scaleX number
---@field scaleY number
---@field color Color
local SpriteRenderer = setmetatable({},{__index = Component})
SpriteRenderer.__index = SpriteRenderer
SpriteRenderer.__class = "SpriteRenderer"
SpriteRenderer.isUnique = true

---@return SpriteRenderer
function SpriteRenderer.new(color,offsetX,offsetY, rotation,scaleX,scaleY)
    ---@type SpriteRenderer
    local self = setmetatable(Component.new(),SpriteRenderer)
    self:setTransform()
    self.texture = nil
    self.offsetX = offsetX or 0
    self.offsetY = offsetY or 0
    if self.transform then
        self.rotation = rotation or self.transform.rotation
        self.scaleX = scaleX or self.transform.scaleX
        self.scaleY = scaleY or self.transform.scaleY
    end
    
    self.color = color or Colors.white
    return self
end

function SpriteRenderer:start()
    self:setTransform()
    if self.transform then
        if self.rotation == nil then
            self.rotation = self.transform.rotation
        end
        if self.scaleX == nil then
            self.scaleX = self.transform.scaleX
        end
        if self.scaleY == nil then
            self.scaleY = self.transform.scaleY
        end
    end
end


function SpriteRenderer:update()

end

function SpriteRenderer:draw()
    if self.texture == nil then
        return
    end
    love.graphics.draw(self.texture,self.transform.x,self.transform.y,self.rotation,self.scaleX,self.scaleY,self.offsetX,self.offsetY)
end



function SpriteRenderer:setTexture(path,name)
    self.texture = TextureManager:getTexture(path,name)
end

return SpriteRenderer