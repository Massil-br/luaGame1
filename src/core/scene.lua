---@class Scene
---@field name string
---@field entities Entity[]
---@field ui Entity[]
---@field camera Camera
local Scene = {}

Scene.__index = Scene

function Scene.new(name)
    local self = setmetatable({},Scene)
    if not name then
        error("set a name to the Scene")
    end
    self.name = name
    self.entities = {}
    self.ui = {}
    self.camera = self:getEntityByName("Main Camera")
    return self
end

---@param entity Entity
function Scene:addEntity(entity)
    table.insert(self.entities,entity)
    entity.parent = self
end

---@param entity Entity
function Scene:addUi(entity)
    table.insert(self.entities,entity)
    entity.parent = self
end

---@param dt number
function Scene:update(dt)
    for _,entity in ipairs(self.entities) do
        self:updateEntityRecursive(entity, dt)
    end
end

---@param entity Entity
---@param dt number
function Scene:updateEntityRecursive(entity, dt)
    entity:updateComponents(dt)
    for _,child in ipairs(entity.children) do
        self:updateEntityRecursive(child, dt)
    end
end

function Scene:draw()
    if self.camera == nil then
        self:getCamera()
        if self.camera == nil then
            error("no camera in scene " .. self.name)
        end
    end
    local cameraComponent = self.camera:getComponent("Camera")
    if cameraComponent then
        ---@type Camera
        local camera = cameraComponent
        camera:attach()
        for _,entity in ipairs(self.entities) do
            self:drawEntityRecursive(entity)
        end
        camera:detach()
    end
end

---@param entity Entity
function Scene:drawEntityRecursive(entity)
    -- Ne pas dessiner la caméra elle-même
    if entity.name ~= "Main Camera" then
        entity:drawComponents()
    end
    for _,child in ipairs(entity.children) do
        self:drawEntityRecursive(child)
    end
end

---@param name string
---@return Entity|nil
function Scene:getEntityByName(name)
    for _,entity in ipairs(self.entities) do
        local result = self:findEntityRecursive(entity, name)
        if result then
            return result
        end
    end
    print("no entity "..name.." found in "..self.name .. " scene")
    return nil
end

---@param entity Entity
---@param name string
---@return Entity|nil
function Scene:findEntityRecursive(entity, name)
    if entity.name == name then
        return entity
    end
    for _,child in ipairs(entity.children) do
        local result = self:findEntityRecursive(child, name)
        if result then
            return result
        end
    end
    return nil
end

---@param dt  number
function Scene:updateUi(dt)
    for _,entity in ipairs(self.ui) do
        self:updateEntityRecursive(entity, dt)
    end
end

function Scene:getCamera()
    local CameraEntity = self:getEntityByName("Main Camera")
    if CameraEntity ~= nil then
        self.camera = CameraEntity
        return
    end
    error("no camera in scene "..self.name)
end

function Scene:drawUi()
    for _,entity in ipairs(self.ui) do
        self:drawEntityRecursive(entity)
    end
end

return Scene