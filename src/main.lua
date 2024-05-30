local love2D       = require("love")

local bump         = require("include.libs.bump")
local entityModule = require("include/entity")
local playerModule = require("include/player")

local Vector2      = require("include.libs.Vector2")

local objects = {}

local player = nil
local world = bump.newWorld()

local function newEntity(entity)
    local object = entityModule.new(entity)

    object.HASH = #objects + 1
    objects[object.HASH] = object

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
    })

    newEntity({
        texturePath = "assets/player.png",
        size = Vector2.new(5, 5)
    })

    player.Vector2.x = 11
    player.Vector2.y = 11
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