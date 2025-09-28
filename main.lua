local SceneManager = require("src.core.sceneManager")
local LoadManager = require("src.core.loadManager")
local Scene = require("src.core.scene")




local sceneManager = SceneManager.new()
local loadManager = LoadManager.new()
local scene = Scene.new("base")
sceneManager:addScene(scene)
function love.load()
    loadManager:loadFolder("src/init")
    loadManager:loadScenes(sceneManager)
    sceneManager:setScene("base")
    loadManager:Load(sceneManager)
end

function love.update(dt)
    sceneManager:update(dt)
end
function love.draw()
    sceneManager:draw()
    -- Le texte sera maintenant positionné dans le système de coordonnées de la caméra
    --love.graphics.print("hello", 0, 0)
end