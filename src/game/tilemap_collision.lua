--- Tilemap Collision

local floor = math.floor
local g = love.graphics
local tw = 20

--- are all tiles (x,y) for x in [x_from, x_to], y in [y_from, y_to] not solid
function unsolid_area (x_from, x_to, y_from, y_to)
  if DEBUG then
    g.setColor(255,0,0,150)
    g.rectangle("line",
      x_from*tw-1, y_from*tw-1,
      (x_to - x_from)*tw+2, (y_to - y_from)*tw+2 )
  end

  x_to, y_to = x_to - 1, y_to - 1

  -- is area in bounds?
  if x_from < 0 or x_to >= transient.width
  or y_from < 0 or y_to >= transient.height then
    return false
  end

  local tilemap = transient.solidmap
  for x = x_from, x_to do
    for y = y_from, y_to do
      if tilemap[1 + x + y * transient.width] ~= 0 then
        return false
      end
    end
  end
  return true
end

--- helper function for #solid and #water
function maptile_at_(tilemap, tx, ty, default)
  if DEBUG then
    g.setColor(255, 0, 0, 51)
    g.rectangle("fill", tx*tw, ty*tw, tw, tw)
  end

  -- is tile in bounds?
  if tx < 0 or tx >= transient.width
  or ty < 0 or ty >= transient.height then
    return default
  end

  return tilemap[1 + tx + ty * transient.width] ~= 0
end

--- is the maptile at (x,y) solid?
function maptile_at(tilemap, x, y, default) return
  maptile_at_(tilemap, floor(x/tw), floor(y/tw), default) end

--- is the maptile at (x,y) solid?
function solid(x, y) return transient.solidmap and
  maptile_at(transient.solidmap, x, y, true) end

--- is the maptile at (x,y) liquid?
function water(x, y) return transient.watermap and
  maptile_at(transient.watermap, x, y-15+persistence[persistence.mapname].water_y, false) end
