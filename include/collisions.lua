local module = {}
module.__index = module

local Vector2 = require("include.libs.Vector2")

function module.checkCollision(a, b)
    return a.Vector2.x < b.Vector2.x + b.Dimensions.x and
           b.Vector2.x < a.Vector2.x + a.Dimensions.x and
           a.Vector2.y < b.Vector2.y + b.Dimensions.y and
           b.Vector2.y < a.Vector2.y + a.Dimensions.y
end

return module