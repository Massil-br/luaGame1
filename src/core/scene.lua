---@class Scene
---@field name string
---@field entities Entity[]
local Scene = {}

Scene.__index = Scene

function Scene.new(name)
    local self = setmetatable({},Scene)
    if not name then
        error("set a name to the Scene")
    end
    self.name = name
    self.entities = {}
    return self
end

---@param entity Entity
function Scene:addEntity(entity)
    table.insert(self.entities,entity)
    entity.parent = self
end

---@param dt number
function Scene:update(dt)
    for _,entity in ipairs(self.entities) do
        entity:updateComponents(dt)
        for _,child in ipairs(entity.children) do
            child:updateComponents(dt)
        end
    end
end

function Scene:draw()
    for _,entity in ipairs(self.entities) do
        entity:drawComponents()
        for _,child in ipairs(entity.children)do
            child:drawComponents()
        end
    end
end

return Scene