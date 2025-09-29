local SceneManager = require("src.core.sceneManager")
local LoadManager = require("src.core.loadManager")
local Scene = require("src.core.scene")




local sceneManager = SceneManager.new()
local loadManager = LoadManager.new()
local scene = Scene.new("base")
sceneManager:addScene(scene)

-- Résolution virtuelle (comme Unity: aspect fixe, mise à l'échelle proportionnelle)
local BASE_WIDTH = 1280
local BASE_HEIGHT = 720

-- Viewport calculé à chaque resize
local viewport = { x = 0, y = 0, w = BASE_WIDTH, h = BASE_HEIGHT, scale = 1 }

local function updateViewport(w, h)
    local winW = w or love.graphics.getWidth()
    local winH = h or love.graphics.getHeight()

    local scaleX = winW / BASE_WIDTH
    local scaleY = winH / BASE_HEIGHT
    local scale = math.min(scaleX, scaleY)

    local viewW = math.floor(BASE_WIDTH * scale + 0.5)
    local viewH = math.floor(BASE_HEIGHT * scale + 0.5)
    local offX = math.floor((winW - viewW) / 2)
    local offY = math.floor((winH - viewH) / 2)

    viewport.x = offX
    viewport.y = offY
    viewport.w = viewW
    viewport.h = viewH
    viewport.scale = scale
end

function love.load()
    -- Fenêtre redimensionnable
    local desktopW, desktopH = love.window.getDesktopDimensions()
    local startW = math.min(BASE_WIDTH, desktopW)
    local startH = math.min(BASE_HEIGHT, desktopH)
    love.window.setMode(startW, startH, { resizable = true, minwidth = 640, minheight = 360, highdpi = true })
    updateViewport(startW, startH)

    loadManager:loadFolder("src/init")
    loadManager:loadScenes(sceneManager)
    sceneManager:setScene("base")
    loadManager:Load(sceneManager)
end

function love.resize(w, h)
    updateViewport(w, h)
end

function love.update(dt)
    sceneManager:update(dt)
end

function love.draw()
    -- Effacer l'arrière-plan (barres letterbox/pillarbox)
    love.graphics.clear(0, 0, 0, 1)

    -- Clipper au viewport dans les coordonnées fenêtre
    love.graphics.setScissor(viewport.x, viewport.y, viewport.w, viewport.h)

    -- Appliquer la transformation de viewport (offset + scale) avant la scène
    love.graphics.push()
    love.graphics.translate(viewport.x, viewport.y)
    love.graphics.scale(viewport.scale, viewport.scale)

    -- Dessin du monde en résolution virtuelle (scalé)
    sceneManager:drawWorldOnly()

    love.graphics.pop()
    love.graphics.setScissor()

    -- Dessin de l'UI en pixels écran (non-scalé)
    sceneManager:drawUiOnly()

    -- Debug: infos viewport (non-scalées)
    -- love.graphics.print(string.format("%dx%d -> %dx%d scale=%.3f", love.graphics.getWidth(), love.graphics.getHeight(), viewport.w, viewport.h, viewport.scale), 10, 10)
end