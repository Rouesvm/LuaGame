local module = {}
module.__index = module

local love2D = require("love")
local Vector2 = require("include.libs.Vector2")

local width  = love2D.graphics.getWidth()
local height = love2D.graphics.getHeight()

local function normalizeDirection(direction)
    local normalizeDirection = Vector2.normalize(direction)
            
    if normalizeDirection.x ~= normalizeDirection.x and
        normalizeDirection.y ~= normalizeDirection.y
    then
        normalizeDirection = direction
    end
        
    return normalizeDirection
end

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
    local offset = Vector2.new(
        width - (player.SpriteSize.x * player.Size),
        height - (player.SpriteSize.y * player.Size)
    )

    if player then
        local newDirection = normalizeDirection(module:getDirection())

        local speed = 265
        local sprintSpeed = speed * 1.25

        if love2D.keyboard.isDown("lshift") then
            speed = sprintSpeed
        end

        local newPosition = player.Vector2 + newDirection * speed * deltaTime

        if newPosition.x < 0 then
            newPosition.x = 0
        elseif newPosition.x >= offset.x then
            newPosition.x = offset.x - 1
        end

        if newPosition.y < 0 then
            newPosition.y = 0
        elseif newPosition.y >= offset.y then
            newPosition.y = offset.y - 1
        end
    
        local newX, newY, collisions, len = world:move(player, newPosition.x, newPosition.y)
        player.Vector2 = Vector2.new(newX, newY)
    end
end

return module