local module = {}
module.__index = module

local love2D = require("love")
local Vector2 = require("include.libs.Vector2")

--entity {
--  texturePath = string,
--  size = Vector2,
--}

local function setupEntityTable(self, entity)
    if entity then
        if entity.sprite then
            self.Sprite = entity.sprite
        elseif entity.texturePath then
            self.Sprite = module:loadImage(entity.texturePath)
        end

        if self.Sprite then
            self.SpriteSize = Vector2.new(
                self.Sprite:getWidth(),
                self.Sprite:getHeight()
            )
        end

        if entity.size then
            self.Size = entity.size or 4
        end

        if entity.size and self.Sprite then
            self.Dimensions = self.SpriteSize * self.Size
        end    
    else
        self.Sprite = nil

        self.Size = 4
        self.SpriteSize = Vector2.ZERO

        self.Dimensions = Vector2.ZERO
    end
end

function module.initTables(world)
    local self = {}

    self.player = nil

    self.world = world
    self.entityList = {}

    return setmetatable(self, module)
end

function module.newEntity(entity)
    local self = {}

    setupEntityTable(self, entity)

    self.Health = 0
    self.Vector2 = entity.Position or Vector2.new(0, 0)

    return setmetatable(self, module)
end

function module:loadImage(texturePath, anyTable)
    local info = love2D.filesystem.getInfo(texturePath)

    if info then
        local Sprite = love2D.graphics.newImage(texturePath)
        Sprite:setFilter("nearest", "linear")

        if anyTable then
            local ID = #anyTable + 1
            table.insert(anyTable, ID, Sprite)
            return ID
        end

        return Sprite
    end
end

function module:newWorldEntity(entity, isPlayer) 
    local object = module.newEntity(entity)

    self.world:add(object,
         object.Vector2.x, object.Vector2.y,
         object.Dimensions.x, object.Dimensions.y
    )

    if not isPlayer then
        self.entityList[#self.entityList + 1] = object
    end

    return object
end

return module