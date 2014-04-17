local g = love.graphics
local tw = 20
function collision (x1, y1, x2, y2, r1, r2)
  collisions = collisions+1

  local dx = x1-x2
  local dy = y1-y2
  local sq_d = dx*dx + dy*dy

  local r = r1 + r2
  local sq_r = r * r

  if DEBUG then
    if sq_r/sq_d > 0.01 then
      g.setColor(255,255,255, 55+200*math.min(sq_r/sq_d, 1))
      g.line(x1, y1, x2, y2)
      g.circle("fill", x1, y1, r1)
      g.circle("fill", x2, y2, r2)
    end
  end

  return sq_d < sq_r
end
function pl_col (x, y, r)
  return collision (player_obj.x, player_obj.y-tw/2, x, y, tw/2, r)
end

function map(map, x, y)
  local result = map[floor(x/tw) + floor(y/tw)*stage.width] ~= 0
  if DEBUG then
    if result then g.setColor(255,255,255,51)
    else           g.setColor(0,0,0,51)       end
    g.rectangle("fill", floor(x/tw)*tw, floor(y/tw)*tw, tw, tw)
  end
  return result
end
function solid(x, y) return solidmap and map(solidmap, x, y) end
function water(x, y) return watermap and map(watermap, x, y-15) end
function grid(x, y)
  for i,b in ipairs(types.GRID) do
    if DEBUG then
      g.setColor(255, 255, 255,
       255-255*math.min(1, math.sqrt((x-b.x)*(x-b.x)+(y-b.x)*(y-b.x))/300))
      g.line(x, y-tw/2, b.x, b.y-tw/2)
    end

    if not b.disabled
    and b.x-tw/2 < x+tw/2 and x-tw/2 < b.x + tw/2
    and b.y-tw   < y+tw   and y      < b.y then
      return true
    end
  end
  return false
end

