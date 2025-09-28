local GameObject  = require("src.core.gameObject")
local fpsCounter = GameObject.new("fpsCounter")

local fpsCountercomp = require("src.components.fpsCounter").new()

fpsCounter:addComponent(fpsCountercomp)

return fpsCounter