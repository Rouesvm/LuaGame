local module = {}
module.__index = module

local love2D = require("love")
local Vector2 = require("include.libs.Vector2")

local width  = love2D.graphics.getWidth()
local height = love2D.graphics.getHeight()

function module:getDirection()
    local x, y = 0, 0

    if love2D.keyboard.isDown("w") then
        y = -1
    end

    if love2D.keyboard.isDown("s") then
        y = 1
    end

    if love2D.keyboard.isDown("a") then
        x = -1
    end

    if love2D.keyboard.isDown("d") then
       x = 1
    end

    return Vector2.new(x, y)
end

function module:movePlayer(player, world, deltaTime)
    local direction = module:getDirection()
    local normalizeDirection = Vector2.normalize(direction)

    local offsetX = width - (player.SpriteSize.x * player.Size.x)
    local offsetY = height - (player.SpriteSize.y * player.Size.y)

    if player then
        local speed = 250
        
        if normalizeDirection.x ~= normalizeDirection.x and
             normalizeDirection.y ~= normalizeDirection.y
        then
            normalizeDirection = direction
        end

        local newPosition = player.Vector2 + normalizeDirection * speed * deltaTime

        if newPosition.x < 0 then
            newPosition.x = 0
        elseif newPosition.x >= offsetX then
            newPosition.x = offsetX - 1
        end

        if newPosition.y < 0 then
            newPosition.y = 0
        elseif newPosition.y >= offsetY then
            newPosition.y = offsetY - 1
        end
    
        local actualX, actualY, cols, len = world:move(player, newPosition.x, newPosition.y)
        player.Vector2 = Vector2.new(actualX, actualY)
    end
end

return module