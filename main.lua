local SceneManager = require("src.core.sceneManager")
local LoadManager = require("src.core.loadManager")
local Scene = require("src.core.scene")


local f = io.open("log.txt","w")
if f then
    io.output(f)
    print("hello")
end


local sceneManager = SceneManager.new()
local loadManager = LoadManager.new()
local scene = Scene.new("base")
sceneManager:addScene(scene)
function love.load()
    loadManager:loadFolder("src/init")
    print(loadManager.toLoad[1])
    print(type(loadManager.toLoad[1].Load))
    loadManager:loadScenes(sceneManager)
    sceneManager:setScene("base")
    loadManager:Load(sceneManager)
end

function love.update(dt)
    sceneManager:update(dt)
end
function love.draw()
    sceneManager:draw()
    love.graphics.print("hello",400,300)
end