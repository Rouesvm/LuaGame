local love2D       = require("love")

local bump         = require("include.libs.bump")
local entityModule = require("include/entity")
local playerModule = require("include/player")

local Vector2      = require("include.libs.Vector2")

local entityHandler = entityModule.initTables(bump.newWorld())

local function drawWrapper(object)
    if object.Sprite then
        love2D.graphics.draw(object.Sprite,
            object.Vector2.x, object.Vector2.y,
            0,
            object.Size, object.Size
       )
    end
end

local function batchLoad(whichWay, settings, count, offsetXORY)
    local offset = settings.offset or 0
    local startI = offsetXORY or 0
    local endI = offsetXORY and count + offsetXORY or count

    for i=startI, endI do
        settings.Position = whichWay and Vector2.new(offset, i * 64) or Vector2.new(i * 64, offset)
        entityHandler:newWorldEntity(settings)
    end
end

function love2D.load()
    entityHandler.player = entityHandler:newWorldEntity({
        texturePath = "assets/player.png",
        Position = Vector2.new(100, 100),
        size = 5,
    }, true)

    batchLoad(false, {
        texturePath = "assets/block.png",
        offset = 0,
        size = 4
    }, 10, 2)

    batchLoad(true, {
        texturePath = "assets/block.png",
        offset = 0,
        size = 4
    }, 10)

    batchLoad(false, {
        texturePath = "assets/block.png",
        offset = 64,
        size = 4
    }, 10, 2)

    local win = entityHandler:newWorldEntity({
        texturePath = "assets/block.png",
        Position = Vector2.new(20 * 64, 8 * 64),
        size = 4
    })

    entityHandler.player.Vector2.x = 15
    entityHandler.player.Vector2.y = 15
end

function love2D.update(deltaTime)
    playerModule:movePlayer(entityHandler.player, entityHandler.world, deltaTime)
end

function love2D.draw()
    drawWrapper(entityHandler.player)

    for i=1, #entityHandler.entityList do
        local objects = entityHandler.entityList
        drawWrapper(objects[i])
    end
end