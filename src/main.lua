local love2D       = require("love")

local bump         = require("include.libs.bump")
local entityModule = require("include/entity")
local playerModule = require("include/player")

local Vector2      = require("include.libs.Vector2")

local instancePositions = {}

local entityHandler = entityModule.initTables(bump.newWorld())

local function drawWrapper(object, texture)
    local texture = object.Sprite or texture
    if texture then
        love2D.graphics.draw(texture,
            object.Vector2.x, object.Vector2.y,
            0,
            object.Size, object.Size
       )
    end
end

local function batchLoad(direction, settings, count, startOffset)
    local offset = settings.offset or 0
    local startI = startOffset or 0
    local endI = startOffset and count + startOffset or count

    for i=startI, endI do
        settings.Position = direction and Vector2.new(offset * 64, i * 64) or Vector2.new(i * 64, offset * 64)

        local object = entityHandler:newWorldEntity(settings)
        table.insert(instancePositions[1][1], {object.Vector2, object.Size})
    end
end

function love2D.load()
    entityHandler.player = entityHandler:newWorldEntity({
        texturePath = "assets/player.png",
        Position = Vector2.new(100, 100),
        size = 5,
    }, true)

    local loadedBlockTexture = entityHandler:loadEntityImage("assets/block.png")

    instancePositions[1] = {
        [1] = {},
        [2] = loadedBlockTexture
    }

    batchLoad(false, {
        sprite = loadedBlockTexture,
        offset = 0,
        size = 4
    }, 10, 2)

    batchLoad(true, {
        sprite = loadedBlockTexture,
        offset = 0,
        size = 4
    }, 10)

    batchLoad(false, {
        sprite = loadedBlockTexture,
        offset = 64,
        size = 4
    }, 10, 2)

    local win = entityHandler:newWorldEntity({
        sprite = loadedBlockTexture,
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

    for i=1, #instancePositions do
        for c=1, #instancePositions[i][1] do 
            local instance = instancePositions[i][1][c]
            drawWrapper({Vector2 = instance[1], Size = instance[2]}, instancePositions[i][2])
        end
    end
end