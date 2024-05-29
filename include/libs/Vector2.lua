local Vector2 = {}
Vector2.yScale = 1 -- -1 for games & graphics, 1 for mathimatical authenticity

--Common functions (local)
local function sign(t)
  if t == 0 then
    return 0
  elseif t < 0 then
    return -1
  end
  return 1
end

local function unpack(t) -- Global unpack() still be available as _G.unpack()
  local x, y
  x = t.x or t[1]
  y = t.y or t[2]
  return x, y
end
Vector2.unpack = unpack

local function factor(f) -- Convert factor f to an {x, y} sequence
  if type(f) == 'number' then
    return f, f
  end
  return unpack(f)
end

--Object creation & metatable
local function new(x, y)
  local t = {}
  t.x = x or 0
  t.y = y or 0
  return setmetatable(t, Vector2)
end
Vector2.new = new


function Vector2.__index(t, k)
  if k == 'x' then
    return rawget(t, 1)
  elseif k == 'y' then
    return rawget(t, 2)
  end
  return rawget(t, k) or Vector2[k]
end

function Vector2.__newindex(t, k, v)
  if k == 'x' then
    return rawset(t, 1, v)
  elseif k == 'y' then
    return rawset(t, 2, v)
  end
  return rawset(t, k, v)
end

function Vector2.__tostring(t)
  return string.format("(%s, %s)", t.x, t.y)
end

function Vector2.__pairs(t)
  return pairs({x = t.x, y = t.y})
end

function Vector2.__ipairs(t)
  return ipairs({t.x, t.y})
end

function Vector2.__concat(a, b)
  local t = {}
  local al = #a
  
  for i = 1, al do
    t[i] = a[i]
  end
  
  for i = 1, #b do
    t[al + i] = b[i]
  end
  
  return t
end

--Basic vector math
function Vector2.__add(t1, t2)
  local x1, y1 = unpack(t1)
  local x2, y2 = unpack(t2)
  return new(x1 + x2, y1 + y2)
end

function Vector2.__sub(t1, t2)
  local x1, y1 = unpack(t1)
  local x2, y2 = unpack(t2)
  return new(x1 - x2, y1 - y2)
end

function Vector2.__mul(t1, t2)
  local x1, y1 = factor(t1)
  local x2, y2 = factor(t2)
  return new(x1 * x2, y1 * y2)
end

function Vector2.__div(t1, t2)
  local x1, y1 = factor(t1)
  local x2, y2 = factor(t2)
  return new(x1 / x2, y1 / y2)
end

function Vector2.__mod(t1, t2)
  local x1, y1 = factor(t1)
  local x2, y2 = factor(t2)
  return new(x1 % x2, y1 % y2)
end

function Vector2.__pow(t1, t2)
  local x1, y1 = factor(t1)
  local x2, y2 = factor(t2)
  return new(x1 ^ x2, y1 ^ y2)
end

function Vector2.__eq(t1, t2)
  local x1, y1 = unpack(t1)
  local x2, y2 = unpack(t2)
  return x1 == x2 and y1 == y2
end

function Vector2.__lt(t1, t2)
  local x1, y1 = unpack(t1)
  local x2, y2 = unpack(t2)
  return x1 < x2 or y1 < y2
end

function Vector2.__le(t1, t2)
  local x1, y1 = unpack(t1)
  local x2, y2 = unpack(t2)
  return x1 <= x2 and y1 <= y2
end

function Vector2.__unm(t)
  return new(-t.x, -t.y)
end
--End of the basic math

--Constant vectors
Vector2.ZERO = new(0, 0)
Vector2.ONE = new(1, 1)
Vector2.HUGE = new(math.huge, math.huge)

Vector2.RIGHT = new(1, 0)
Vector2.DOWN = new(0, -1) * Vector2.yScale

Vector2.LEFT = -Vector2.RIGHT
Vector2.UP = -Vector2.DOWN
Vector2.NEG_ONE = -Vector2.ONE
Vector2.NEG_HUGE = -Vector2.HUGE

--Object & value management
function Vector2.copy(t)
  return new(t.x, t.y)
end

function Vector2.override(t, x, y) --Override one (2nd = nil) or both components
  t.x, t.y = x or t.x, y or t.y
end

function Vector2.compareValues(t)
  return sign(t.x - t.y) --1 if x > y, -1 if x < y, 0 if x = y
end

--Distance functions
function Vector2.sqDist(t, to)
  local x2, y2 = 0, 0
  if to then
    x2, y2 = unpack(to)
  end
  local dx, dy = x2 - t.x, y2 - t.y
  return dx*dx + dy*dy
end

function Vector2.dist(t, to)
  return math.sqrt(t:sqDist(to))
end

--Rounding functions
function Vector2.floor(t)
  return new(math.floor(t.x), math.floor(t.y))
end

function Vector2.ceil(t) --Say hello to Godot developers
  return new(math.ceil(t.x), math.ceil(t.y))
end

--Normalization & sign tricks
function Vector2.normalize(t, unit)
  unit = unit or 1
  local d = t:dist() / unit
  return new(t.x / d, t.y / d)
end

function Vector2.sign(t)
  return new(sign(t.x), sign(t.y))
end

function Vector2.abs(t)
  return new(math.abs(t.x), math.abs(t.y))
end

--Vector products
function Vector2.dotProduct(a, b)
  return a[1] * b[1] + a[2] * b[2]
end

function Vector2.crossProduct(a, b, z0)
  z0 = z0 or 0 --Z coordinate of the 2D vector plain
  local x, y, z --Product components
  x = z0 * (a[2] - b[2])
  y = z0 * (a[1] - b[1])
  z = Vector2.crossProductZ(a, b)
  return {x, y, z} --LuaVector2 does not operate 3D vectors, so it returns a table
end

function Vector2.crossProductZ(a, b) --Return the Z component of (a x b)
  return a[1]*b[2] - b[1]*a[2]
end

--Angle functions (Every angle is in radians)
function Vector2.fromAngle(a, d, rel) --a = angle, rel = relative vector (taken as 0 rad)
  d = d or 1 --Vector length
  a = rel and a + rel:toAngle() or a
  return new(math.cos(a) * d, math.sin(a) * Vector2.yScale * d)
end

function Vector2.toAngle(t, rel) --rel = relative vector (taken as 0 rad)
  local n = t:normalize()
  local a
  
  rel = rel and rel:normalize() or new(1, 0)
  n.y, rel.y = n.y * Vector2.yScale, rel.y * Vector2.yScale
  a = t:dotProduct(rel) / n:dist() / rel:dist()

  if a == 0 then --acos(0) has ambiguous result IRL but always returns 0 in Lua
    a = sign(n.x * rel.y) * sign(rel.x) * math.pi --asin(n.x) is always 1 or -1 when acos(t.y) = 0 
  else
    a = math.acos(a)
  end
  return a
end

function Vector2.bisectress(a, b, center) --Normalized bisectress vector between a & b vectors
  --Uses vector math algorithm, taken from my another project
  center = center or Vector2.ZERO
  a = a - center
  b = b - center
  local sum = a + b
  local correction = a:normalize() * (b:dist() - a:dist())
  return (sum + correction):normalize()
end

return Vector2