---@class SceneManager
---@field scenes Scene[]
---@field current Scene
local SceneManager = {}
SceneManager.__index = SceneManager

function SceneManager.new()
    local self = setmetatable({},SceneManager)
    self.scenes = {}
    self.current = nil
    return self
end

---@param scene Scene
function SceneManager:addScene(scene)
    self.scenes[scene.name]= scene
end

---@param name string
function SceneManager:setScene(name)
    self.current = self.scenes[name]
end

---@param name string
---@return Scene
function SceneManager:getScene(name)
    return self.scenes[name]
end


---@param dt number
function SceneManager:update(dt)
    if self.current then
        self.current:update(dt)
        self.current:updateUi(dt)
    end
end

function SceneManager:draw()
    if self.current then
        self.current:draw()
        self.current:drawUi()
    end
end

function SceneManager:drawWorldOnly()
    if self.current then
        self.current:draw()
    end
end

function SceneManager:drawUiOnly()
    if self.current then
        self.current:drawUi()
    end
end

function SceneManager:setFirstScene()
    for _, scene in pairs(self.scenes) do
        self.current = scene
        return
    end
end

function SceneManager:getFirstScene()
    for _,scene in pairs(self.scenes)do
        if scene ~= nil then
            return scene
        end
    end
end

return SceneManager