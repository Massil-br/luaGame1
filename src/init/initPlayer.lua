local Entity = require("src.core.entity")

local M = {}

---@param SceneManager SceneManager
function M:Load(SceneManager)
    local scene =SceneManager:getFirstScene()
    local player = Entity.new(scene, "player")
    scene:addEntity(player)

    local PlayerController = require("src.components.playerController").new(2)
    player:addComponent(PlayerController)

    local CircleRenderer = require("src.components.circleRenderer").new(0, 0, 50, 50)
    player:addComponent(CircleRenderer)
end

return M
