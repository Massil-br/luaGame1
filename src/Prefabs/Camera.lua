local Entity = require("src.core.entity")

local camera = Entity.new("Main Camera")
local CameraComp = require("src.components.camera").new()

camera:addComponent(CameraComp)


return camera