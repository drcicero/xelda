--- Collision Detection

require "game.tilemap_collision"

local floor = math.floor
local g = love.graphics
local tw = 20

--- are the rects 1 and 2 overlapping?
function box_col (o1, o2, w1,h1, w2,h2)
  if DEBUG then
    g.setColor(255, 0, 0, 100)
--     255-255*math.min(1, dist(o1.x, o1.y, o2.x, o2.y) / 300))

    g.rectangle("fill", o1.x-1, o1.y-h1/2-1, 2, 2)
    g.rectangle("fill", o2.x, o2.y, w2, h2)
  end

  if math.abs(o1.x - o2.x-w2/2) < w1/2+w2/2 and math.abs(o1.y-h1/2 - o2.y-h2/2) < h1/2+h2/2 then
    return true
  end
  return false
end

--- are the rects {x,y,ox,oy, z=1} a and b overlapping?
function rect_col (a, b)
  local az = a.z or 1
  local bz = b.z or 1

  if DEBUG then
    g.setColor(255, 255, 255,
     255-255*math.min(1, dist(a.x, a.y, b.x, b.y) / 300))

    g.line(a.x, a.y, b.x, b.y)
    g.rectangle("line", a.x, a.y, a.ox*az, a.oy*az)
    g.rectangle("line", b.x, b.y, b.ox*bz, b.oy*bz)
  end

  -- TODO FIXME Warning - Not working - Wrong
  if  a.x + a.ox*az + b.ox*bz < b.x and b.x < a.x + a.ox*az + b.ox*bz
  and a.y + a.oy*az + b.ox*bz < b.x and b.x < a.y + a.oy*az + b.oy*bz then
    return true
  end
  return false
end

--- are the circles overlapping?
function circ_col (x1, y1, x2, y2, r1, r2)
  local sq_d = sqr_dist(x1, y1, x2, y2)
  local r = r1+r2
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

function sqr_dist (x, y, x2, y2)
  local dx, dy = x-x2, y-y2
  return dx*dx + dy*dy
end

function dist (x, y, x2, y2)
  local dx, dy = x-x2, y-y2
  return math.sqrt( dx*dx + dy*dy )
end

-- does a line segment intersect a circle
function line_circ_col (lx1, ly1, lx2, lx2, cx, cy, r)
  local line_len = sqr_dist(lx2, ly2, lx1, ly1)
  local sqr_d1 = sqr_dist(lx1, ly1, cx, cy)
  local sqr_d2 = sqr_dist(lx2, ly2, cx, cy)

  local d = math.abs( (ly2-ly1)*cx - (lx2-lx1)*cy + lx2*ly1 - ly2*ly1 ) / line_len

  return math.min(d*d, sqr_d1, sqr_d2) <= r * r
end

--- is the circle and a circle around the avatars feet overlapping?
function pl_col (x, y, r)
  return circ_col(avatar.x, avatar.y-avatar.oy+5, x, y, tw/2.5, r)
end

--- is any grid-obj overlapping with the point {x,y} o
function grid (o, vx, vy)
  return get_first_overlap(transient.types.GRID, o, vx, vy) ~= nil end

--- is any-obj of the given type overlapping with the point {x,y} o
function get_first_overlap (type, o, vx, vy)
  local oleft, otop     = o.x + vx - o.ox, o.y + vy - o.oy
  local oright, obottom = oleft + o.width, otop + o.height
  for b,_ in pairs(type) do
    local bleft, btop     = b.x - b.ox,      b.y - b.oy
    local bright, bbottom = bleft + b.width, btop + b.height

    if DEBUG and not b.disabled then
      g.setColor(255, 0, 255, 100)
      g.rectangle("fill", oleft, otop, oright-oleft, obottom-otop)
      g.rectangle("fill", bleft, btop, bright-bleft, bbottom-btop)
    end

    if not b.disabled
    and oleft < bright  and bleft < oright
    and otop  < bbottom and btop  < obottom then
      return b
    end
  end
end

