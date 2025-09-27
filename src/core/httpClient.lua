local http_request = require "http.request"
local cjson = require "cjson"
---@class HTTPClient
---@field baseUrl string
---@field queue any
---@field retryLimit number
local HTTPClient = {}
HTTPClient.__index = HTTPClient

function HTTPClient.new(baseUrl)
    local self = setmetatable({}, HTTPClient)
    self.baseUrl = baseUrl or ""
    self.token = nil           -- token d'authentification
    self.queue = {}            -- queue des requêtes
    self.retryLimit = 3        -- retry par défaut
    self.active = false        -- si une requête est en cours
    return self
end

-- définir le token
function HTTPClient:setToken(token)
    self.token = token
end

-- ajouter une requête à la queue
function HTTPClient:_enqueue(method, endpoint, data, resolve, reject, retry)
    table.insert(self.queue, {
        method = method,
        endpoint = endpoint,
        data = data,
        resolve = resolve,
        reject = reject,
        retry = retry or self.retryLimit
    })
    self:_processQueue()
end
-- traitement de la queue (async via coroutine)
function HTTPClient:_processQueue()
    if self.active or #self.queue == 0 then return end
    self.active = true

    local reqData = table.remove(self.queue, 1)
    coroutine.wrap(function()
        local ok, response = pcall(function()
            local body = reqData.data and cjson.encode(reqData.data) or nil
            local req = http_request.new_from_uri(self.baseUrl .. reqData.endpoint)
            req.headers:upsert(":method", reqData.method)
            req.headers:upsert("Content-Type", "application/json")
            if self.token then
                req.headers:upsert("Authorization", "Bearer "..self.token)
            end
            if body then req:set_body(body) end
            local headers, stream = req:go()
            local respBody = stream:get_body_as_string()
            local decoded = {}
            if respBody ~= "" then
                decoded = cjson.decode(respBody)
            end
            return decoded
        end)

        if ok then
            if reqData.resolve then reqData.resolve(response) end
        else
            if reqData.retry > 0 then
                -- retry automatique
                reqData.retry = reqData.retry - 1
                table.insert(self.queue, 1, reqData)
            elseif reqData.reject then
                reqData.reject(response)
            end
        end

        self.active = false
        self:_processQueue() -- passer à la requête suivante
    end)()
end
-- méthodes HTTP exposées
function HTTPClient:get(endpoint, data)
    return self:_asyncWrapper("GET", endpoint, data)
end
function HTTPClient:post(endpoint, data)
    return self:_asyncWrapper("POST", endpoint, data)
end
function HTTPClient:put(endpoint, data)
    return self:_asyncWrapper("PUT", endpoint, data)
end
function HTTPClient:patch(endpoint, data)
    return self:_asyncWrapper("PATCH", endpoint, data)
end
function HTTPClient:delete(endpoint, data)
    return self:_asyncWrapper("DELETE", endpoint, data)
end

-- wrapper async qui retourne coroutine-friendly
function HTTPClient:_asyncWrapper(method, endpoint, data)
    local co = coroutine.running()
    local result
    self:_enqueue(method, endpoint, data,
        function(resp) result = { ok=true, data=resp } coroutine.resume(co) end,
        function(err) result = { ok=false, error=err } coroutine.resume(co) end
    )
    coroutine.yield()
    return result
end

-- wrapper métier
function HTTPClient:savePlayerData(playerData)
    return self:post("player/save", playerData)
end

function HTTPClient:sendChat(msg)
    return self:post("chat/send", { message = msg })
end

return HTTPClient