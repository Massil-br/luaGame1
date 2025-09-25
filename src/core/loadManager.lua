local LoadManager = {}
LoadManager.__index = LoadManager

function LoadManager.new()
    local self = setmetatable({}, LoadManager)
    self.scenesToLoad = {}
    self.toLoad = {}
    return self
end

function LoadManager:add(script)
    if not script or type(script.Load) ~= "function" then
        error("Script must have a Load function")
    end
    table.insert(self.toLoad, script)
end

function LoadManager:addScene(scene)
    table.insert(self.scenesToLoad, scene)
end

function LoadManager:loadScenes(sceneManager)
    for _, scene in ipairs(self.scenesToLoad) do
        sceneManager:addScene(scene)
    end
end

function LoadManager:Load(sceneManager)
    for _, script in ipairs(self.toLoad) do
        script:Load(sceneManager)
    end
end

function LoadManager:loadFolder(folder)
    local items = love.filesystem.getDirectoryItems(folder)
    for _, file in ipairs(items) do
        local path = folder .. "/" .. file
        local info = love.filesystem.getInfo(path)

        if info.type == "file" and file:sub(-4) == ".lua" then
            local moduleName = folder:gsub("/", ".") .. "." .. file:sub(1, -5)
            local success, mod = pcall(require, moduleName)
            if success and mod then
                self:add(mod)
            else
                print("Error loading module:", path, mod)
            end
        elseif info.type == "directory" then
            self:loadFolder(path) -- récursif
        end
    end
end

return LoadManager