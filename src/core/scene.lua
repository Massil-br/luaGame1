---@class Scene
---@field name string
---@field gameObjects GameObject[]
---@field uiGameObjects GameObject[]
---@field camera Camera
local Scene = {}


Scene.__index = Scene

function Scene.new(name)
    local self = setmetatable({},Scene)
    if not name then
        error("set a name to the Scene")
    end
    self.name = name
    self.gameObjects = {}
    self.uiGameObjects = {}
    self.camera = self:getGameObjectByName("Main Camera")
    return self
end

---@param gameObject GameObject
function Scene:addGameObject(gameObject)
    table.insert(self.gameObjects,gameObject)
    gameObject.parent = self
end

---@param gameObject GameObject
function Scene:addUi(gameObject)
    table.insert(self.uiGameObjects,gameObject)
    gameObject.parent = self
end

---@param dt number
function Scene:update(dt)
    for _,gameObject in ipairs(self.gameObjects) do
        self:updateEntityRecursive(gameObject, dt)
    end
end

---@param gameObject GameObject
---@param dt number
function Scene:updateEntityRecursive(gameObject, dt)
    gameObject:updateComponents(dt)
    for _,child in ipairs(gameObject.children) do
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
        -- trier les entités par leur z croissant (z bas dessiné d'abord)
        table.sort(self.gameObjects, function(a,b)
            local az = (a.transform and a.transform.z) or 0
            local bz = (b.transform and b.transform.z) or 0
            if az == bz then
                return a.id < b.id
            end
            return az < bz
        end)

        for _,gameObject in ipairs(self.gameObjects) do
            self:drawEntityRecursive(gameObject)
        end
        camera:detach()
    end
end

---@param gameObject GameObject
function Scene:drawEntityRecursive(gameObject)
    -- Ne pas dessiner la caméra elle-même
    if gameObject.name ~= "Main Camera" then
        gameObject:drawComponents()
    end
    -- trier les enfants par z avant de dessiner récursivement
    if #gameObject.children > 1 then
        table.sort(gameObject.children, function(a,b)
            local az = (a.transform and a.transform.z) or 0
            local bz = (b.transform and b.transform.z) or 0
            if az == bz then
                return a.id < b.id
            end
            return az < bz
        end)
    end
    for _,child in ipairs(gameObject.children) do
        self:drawEntityRecursive(child)
    end
end

---@param name string
---@return GameObject|nil
function Scene:getGameObjectByName(name)
    for _,gameObject in ipairs(self.gameObjects) do
        local result = self:findEntityRecursive(gameObject, name)
        if result then
            return result
        end
    end
    print("no gameObject "..name.." found in "..self.name .. " scene")
    return nil
end

---@param gameObject GameObject
---@param name string
---@return GameObject|nil
function Scene:findEntityRecursive(gameObject, name)
    if gameObject.name == name then
        return gameObject
    end
    for _,child in ipairs(gameObject.children) do
        local result = self:findEntityRecursive(child, name)
        if result then
            return result
        end
    end
    return nil
end

---@param dt  number
function Scene:updateUi(dt)
    for _,gameObject in ipairs(self.uiGameObjects) do
        self:updateEntityRecursive(gameObject, dt)
    end
end

function Scene:getCamera()
    local CameraEntity = self:getGameObjectByName("Main Camera")
    if CameraEntity ~= nil then
        self.camera = CameraEntity
        return
    end
    error("no camera in scene "..self.name)
end

function Scene:drawUi()
    for _,gameObject in ipairs(self.uiGameObjects) do
        self:drawEntityRecursive(gameObject)
    end
end

return Scene