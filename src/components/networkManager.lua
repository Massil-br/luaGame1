local Component = require("src.core.component")

---@class NetworkManager
---@field api HTTPClient
---@field queue any
---@field co thread 
local NetworkManager = setmetatable({},{__index = Component})
NetworkManager.__index = NetworkManager
NetworkManager.__class = "NetworkManager"
NetworkManager.isUnique = true

function NetworkManager.new(api)
    local self = setmetatable({}, NetworkManager)
    self.api = api
    self.queue = {}
    self.co = coroutine.create(function()
        while true do
            if #self.queue > 0 then
                local job = table.remove(self.queue, 1)
                local resp
                
                -- Utiliser la méthode HTTP appropriée
                if job.method == "GET" then
                    resp = self.api:get(job.endpoint, job.data)
                elseif job.method == "POST" then
                    resp = self.api:post(job.endpoint, job.data)
                elseif job.method == "PUT" then
                    resp = self.api:put(job.endpoint, job.data)
                elseif job.method == "PATCH" then
                    resp = self.api:patch(job.endpoint, job.data)
                elseif job.method == "DELETE" then
                    resp = self.api:delete(job.endpoint, job.data)
                end
                
                if job.callback then
                    job.callback(resp)
                end
            end
            coroutine.yield()
        end
    end)
    return self
end

-- Ajouter une requête dans la queue
function NetworkManager:request(method, endpoint, data, callback)
    table.insert(self.queue, {
        method = method,
        endpoint = endpoint,
        data = data,
        callback = callback
    })
end

-- A appeler dans update()
function NetworkManager:update()
    coroutine.resume(self.co)
end

return NetworkManager