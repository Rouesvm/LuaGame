local love2D            = require("love")

local bump              = require("include.libs.bump")
local entityModule      = require("include/entity")
local playerModule      = require("include/player")

local Vector2           = require("include.libs.Vector2")

local spriteIDS = {}
local instancePositions = {}

local entityHandler     = entityModule.initTables(bump.newWorld())

local LEVEL_ONE = require("src.assets.maps.levelone")

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

local function loadTableMap(TABLE_MAP)
    local entity = {
        size = 4
    }    

    for i = 1, #TABLE_MAP do
        for x, v in pairs(TABLE_MAP[i]) do
            if not spriteIDS[v] then
                goto continue
            end

            entity.sprite = spriteIDS[v]
            entity.Position = Vector2.new((x - 1) * 64, (i - 1) * 64)

            local object = entityHandler:newWorldEntity(entity)

            table.insert(instancePositions[1][1], { object.Vector2, object.Size })    
            ::continue::
        end
    end
end

function love2D.load()
    entityHandler.player = entityHandler:newWorldEntity({
        texturePath = "assets/player.png",
        Position = Vector2.new(100, 100),
        size = 3.5,
    }, true)

    local blockID = entityHandler:loadImage("assets/block.png", spriteIDS)

    instancePositions[1] = {
        [1] = {},
        [2] = spriteIDS[blockID]
    }

    loadTableMap(LEVEL_ONE)

    local win = entityHandler:newWorldEntity({
        sprite = spriteIDS[blockID],
        Position = Vector2.new(20 * 64, 8 * 64),
        size = 4
    })

    table.insert(instancePositions[1][1], { win.Vector2, win.Size })

    entityHandler.player.Vector2.x = 15
    entityHandler.player.Vector2.y = 15
end

function love2D.update(deltaTime)
    playerModule:movePlayer(entityHandler.player, entityHandler.world, deltaTime)
end

function love2D.draw()
    drawWrapper(entityHandler.player)

    for i = 1, #instancePositions do
        for c = 1, #instancePositions[i][1] do
            local instance = instancePositions[i][1][c]
            drawWrapper({ Vector2 = instance[1], Size = instance[2] }, instancePositions[i][2])
        end
    end
end
