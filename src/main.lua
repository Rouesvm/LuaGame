local love2D       = require("love")

local bump         = require("include.libs.bump")
local entityModule = require("include/entity")
local playerModule = require("include/player")

local Vector2      = require("include.libs.Vector2")

local objects = {}

local player = nil
local world = bump.newWorld()

local function newEntity(entity, Vector2)
    local object = entityModule.new(entity)

    print(object)

    object.HASH = #objects + 1
    objects[object.HASH] = object

    object.Vector2 = Vector2 or object.Vector2 

    world:add(object,
         object.Vector2.x, object.Vector2.y, 
         object.Dimensions.x, object.Dimensions.y
    )

    return object
end

function love2D.load()
    player = newEntity({
        texturePath = "assets/player.png",
        size = Vector2.new(5, 5)
    }, Vector2.new(100, 100))


    for i=0, 10 do 
        newEntity({
            texturePath = "assets/block.png",
            size = Vector2.new(4, 4)
        }, Vector2.new(0, i * 64))    
    end

    for i=0, 8 do
        newEntity({
            texturePath = "assets/block.png",
            size = Vector2.new(4, 4)
        }, Vector2.new(3 * 64, i * 64))    

        newEntity({
            texturePath = "assets/block.png",
            size = Vector2.new(4, 4)
        }, Vector2.new(6 * 64, i * 64 + 64 + 64))    

        newEntity({
            texturePath = "assets/block.png",
            size = Vector2.new(4, 4)
        }, Vector2.new(9 * 64, i * 64))    

        newEntity({
            texturePath = "assets/block.png",
            size = Vector2.new(4, 4)
        }, Vector2.new(12 * 64, i * 64 + 64 + 64))    

        newEntity({
            texturePath = "assets/block.png",
            size = Vector2.new(4, 4)
        }, Vector2.new(15 * 64, i * 64))    

        newEntity({
            texturePath = "assets/block.png",
            size = Vector2.new(4, 4)
        }, Vector2.new(18 * 64, i * 64 + 64 + 64))    
    end

    local win = newEntity({
        texturePath = "assets/block.png",
        size = Vector2.new(4, 4)
    }, Vector2.new(20 * 64, 8 * 64))    

    player.Vector2.x = 15
    player.Vector2.y = 15
end

function love2D.update(deltaTime)
    playerModule:movePlayer(player, world, deltaTime)
end

function love2D.draw()
    for i=1, #objects do
        if objects[i].Sprite then
            love2D.graphics.draw(
                objects[i].Sprite,
                objects[i].Vector2.x, objects[i].Vector2.y,
                0, 
                objects[i].Size.x, objects[i].Size.y
           )
        end
    end
end