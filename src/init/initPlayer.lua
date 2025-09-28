local Entity = require("src.core.entity")

local M = {}

---@param SceneManager SceneManager
function M:Load(SceneManager)
    local scene =SceneManager:getFirstScene()
    local player = Entity.new( "player",scene)
    scene:addEntity(player)

    local PlayerController = require("src.components.playerController").new(500)
    player:addComponent(PlayerController)

    local CircleRenderer = require("src.components.circleRenderer").new(0, 0, 50, 50)
    player:addComponent(CircleRenderer)
    local camera = require("src.Prefabs.Camera")

    player:addChild(camera)

    local object = Entity.new("object1",scene)
    scene:addEntity(object)
    CircleRenderer1 = require("src.components.circleRenderer").new(1500, 0, 50, 50)
    object:addComponent(CircleRenderer1)
end

return M
