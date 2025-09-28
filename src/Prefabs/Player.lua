
local player = require("src.core.gameObject").new("player")
local playerController = require("src.components.playerController").new(5)
local CircleRenderer = require("src.components.circleRenderer").new(0,0,10,10)
player:addComponent(playerController)
player:addComponent(CircleRenderer)

return player