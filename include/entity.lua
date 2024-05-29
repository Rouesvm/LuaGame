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
        if entity.texturePath then
            self.Sprite = module:loadEntityImage(entity.texturePath)
    
            if self.Sprite then
                self.SpriteSize = Vector2.new(
                    self.Sprite:getWidth(),
                    self.Sprite:getHeight()
                )
            end
        end

        if entity.size then
            self.Size = entity.size
        end

        if entity.size and self.Sprite then
            self.Dimensions = self.SpriteSize * self.Size
        end    
    else
        self.Sprite = nil

        self.Size = Vector2.ZERO
        self.SpriteSize = Vector2.ZERO

        self.Dimensions = Vector2.ZERO
    end
end

function module.new(entity)
    local self = {}

    setupEntityTable(self, entity)

    self.Health = 0
    self.Vector2 = Vector2.new(0, 0)

    return setmetatable(self, module)
end

function module:loadEntityImage(texturePath)
    local info = love2D.filesystem.getInfo(texturePath)
    if info then
        self.Sprite = love2D.graphics.newImage(texturePath)
        return self.Sprite
    end
end

return module