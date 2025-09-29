
---@class Texture
---@field id number
---@field name string
---@field path string
local Texture = {}

Texture.__index = Texture

local id = 0

---@param path string
---@param name string
---@return Texture
function Texture.new(path,name)
    id = id+1
    local self = setmetatable({},Texture)
    self.id = id
    self.name = name or id
    self.path = path
    return self
end


return Texture