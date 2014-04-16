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

