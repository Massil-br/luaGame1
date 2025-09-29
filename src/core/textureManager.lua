local Texture = require("src.core.texture")
---@class TextureManager
---@field textures Texture[]
local TextureManager = {}

TextureManager.__index = TextureManager

function TextureManager.new()
    local self = setmetatable({},TextureManager)
    self.textures = {}
    return self
end

---@param path string
---@param name string
---@return Texture
function TextureManager:addTexture(path,name)
    local texture = Texture.new(path,name)
    table.insert(self.textures,texture)
    return texture
end

---@param path string
---@param name string
---@return Texture
function TextureManager:getTexture(path,name)
    for _,texture in ipairs(self.textures) do
        if texture.name == name then
            return texture
        end
        if texture.path == path then
            return texture
        end
    end
    local texture = self:addTexture(path,name)
    return texture
end

local textureManagerInstance = TextureManager.new()
return textureManagerInstance
