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
---@return love.Image
function TextureManager:addTexture(path,name)
    local texture = Texture.new(path,name)
    table.insert(self.textures,texture)
    return texture.img
end

---@param path string
---@param name string
---@return love.Image
function TextureManager:getTexture(path,name)
    for _,texture in ipairs(self.textures) do
        if name ~= nil and texture.name == name then
            return texture.img
        end
        if path ~= nil and texture.path == path then
            return texture.img
        end
    end
    return self:addTexture(path,name)
end

function TextureManager:dropTexture(path,name)
    for i,texture in ipairs(self.textures) do
        if name ~= nil and texture.name == name then
            table.remove(self.textures,i)
            return
        end
        if path ~= nil and texture.path == path then
            table.remove(self.textures,i)
            return
        end
    end
end

local textureManagerInstance = TextureManager.new()
return textureManagerInstance
