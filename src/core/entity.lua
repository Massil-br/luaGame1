---@class Entity
---@field id number
---@field components table<string,Component|Component[]>
---@field name string
---@field parent Entity|Scene|nil
---@field children Entity[]
---@field transform Transform
---@field new fun(parent?,name?):Entity
---@field addComponent fun(Entity,Transform)
---@field getComponent fun(Entity,string):Component|nil
---@field getComponents fun(Entity,string):Component[]|nil
---@field hasComponent fun(Entity,string):boolean
---@field updateComponents fun(Entity,dt:number)
---@field drawComponents fun(Entity)
local Entity ={}
Entity.__index = Entity

local entityId = 0

function Entity.new(parent,name)
    entityId = entityId+1
    local self = setmetatable({},Entity)
    self.id = entityId
    self.name = name or tostring(self.id)
    self.components = {}
    self.parent = parent
    self.children = {}
    if parent and parent.children then
        table.insert(parent.children,self)
    end
    self:addComponent(require("src.components.transform").new())
    self.transform = self:getComponent("Transform")
    return self
end


function Entity:addComponent(component)
    if not component or not component.__class then
        error("Cannot add component without __class")
    end

    component.parent = self
    local className = component.__class
    
    if component.isUnique then
        if self.components[className] then
            error("Entity has already a unique component of type ".. className)
        end
        self.components[className] = component
        component:start()
        return
    end

    if not self.components[className] then
        self.components[className] ={}
    end
    table.insert(self.components[className],component)
    component:start()
end


function Entity:getComponent(className)
    local comp = self.components[className]
    if not comp then return nil end

    if comp.isUnique or type(comp)~="table" then
        return comp
    end

    return comp[1]
end

function Entity:getComponents(className)
    local comp = self.components[className]
    if not comp then return nil end
    local list = {}
    if comp.isUnique or type(comp)~="table" then
        table.insert(list,comp)
        return list
    end
    return comp
end

function Entity:hasComponent(className)
    return self.components[className]~=nil
end

function Entity:updateComponents(dt)
    for _,comps in pairs(self.components) do
        if type(comps) == "table" and not comps.isUnique then
            for _,c in pairs(comps)do
                c:update(dt)
            end
        else
            comps:update(dt)
        end
    end
end

function Entity:drawComponents()
    for _,comps in pairs(self.components) do
        if type(comps) == "table" and not comps.isUnique then
            for _,c in pairs(comps)do
                c:draw()
            end
        else
            comps:draw()
        end
    end
end


return Entity