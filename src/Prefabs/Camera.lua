local GameObject = require("src.core.gameObject")

local camera = GameObject.new("Main Camera")
local CameraComp = require("src.components.camera").new()

camera:addComponent(CameraComp)


return camera