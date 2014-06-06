local g = love.graphics
local tw = 20

function box_col (o1, o2, w1,h1, w2,h2)
  if DEBUG then
    g.setColor(255, 0, 0, 100)
--     255-255*math.min(1, math.sqrt((o1.x-o2.x)*(o1.x-o2.x)+(o1.y-o2.y)*(o1.y-o2.y))/300))

    g.rectangle("fill", o1.x-1, o1.y-h1/2-1, 2, 2)
    g.rectangle("fill", o2.x, o2.y, w2, h2)
  end

  if math.abs(o1.x - o2.x-w2/2) < w1/2+w2/2 and math.abs(o1.y-h1/2 - o2.y-h2/2) < h1/2+h2/2 then
    return true
  end
  return false
end

function rect_col (a, b)
  if DEBUG then
    g.setColor(255, 255, 255,
     255-255*math.min(1, math.sqrt((a.x-b.x)*(a.x-b.x)+(a.y-b.y)*(a.y-b.y))/300))

    g.line(a.x, a.y, b.x, b.y)
  end

  if  a.x + a.ox + b.ox < b.x and b.x < a.x + a.ox + b.ox
  and a.y + a.oy + b.ox < b.x and b.x < a.y + a.oy + b.oy then
    return true
  end
  return false
end

function circ_col (x1, y1, x2, y2, r1, r2)
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

-- TODO remove
collision = circ_col

function pl_col(x, y, r)
  return circ_col(avatar.x, avatar.y-10, x, y, tw/2.5, r)
end

function maptile_at(tilemap, x, y, default)
  -- is map in bounds?
  local tx, ty = floor(x/tw), floor(y/tw)
  if tx < 0 or tx > transient.width - 1
  or ty < 0 or ty > transient.height - 1 then
    return default
  end

  local result = tilemap[1 + tx + ty * transient.width] ~= 0

  if DEBUG then
    local col = result and 255 or 0
    g.setColor(col, col, col, 51)
    g.rectangle("fill", floor(x/tw)*tw, floor(y/tw)*tw, tw, tw)
  end

  return result
end

function solid(x, y) return transient.solidmap and
  maptile_at(transient.solidmap, x, y, true) end
function water(x, y) return transient.watermap and
  maptile_at(transient.watermap, x, y-15+persistence[transient.name].water_y, false) end

function grid(o, vx, vy)
  for b,_ in pairs(types.GRID) do
    local left, top = b.x-b.ox-o.ox, b.y-b.oy
    local right, bottom = left+b.width+o.width, top+b.height+o.oy

    if DEBUG and not b.disabled then
      g.setColor(255, 0, 255, 50)
      g.rectangle("fill", o.x-2, o.y-2, 4, 4)
      g.rectangle("fill", b.x-b.ox, b.y-b.oy, b.width, b.height)
--      g.setColor(255, 255, 0, 50)
--      g.rectangle("fill", left, top, right-left, bottom-top)
    end

    if not b.disabled
    and left < o.x+vx and o.x+vx < right
    and top-2 < o.y+vy and o.y+vy < bottom-1 then
      return true
    end
  end
  return false
end
 
