local sfx = require "sfx"
local coll = require "game.tilemap_collision"

local tileOf = coll.tileOf
local maptile_at = coll.maptile_at
local unsolid_area = coll.unsolid_area

local scripting = require "map.scripting"

local function move_obj (o)
  if o.type == "REMOVED" then error("wtf") end
  local w = "ARROW" == o.type and 2 or tw/2

  if not o.noturn and not o.noface then
    if     o.vx < -.1 then o.facing = -1
    elseif o.vx >  .1 then o.facing =  1 end
  end

  local floor = math.floor

  if o.ghost or o.properties.ghost then
    o.x = o.x + o.vx
    o.y = o.y + o.vy

  else
--  o.wall = false
--  if not o.ghost and not o.properties.ghost then
--    if o.vx ~= 0 then
--      if solid(o.x + o.vx + o.facing*w, o.y)
--      or grid(o, o.vx, 0) then
--        o.vx = 0
--        o.wall = true

--      else
--        if o.ground and math.abs(o.vx) > 0.1
--        and (o.type:find("RINK")~=nil or o.type:find("XELDA")~=nil
--        or o.type:find("SLIME")~=nil  or o.type:find("FISH")~=nil) then
--          o.properties.schwupptimer = (o.properties.schwupptimer or 0)-math.random()
--          if o.properties.schwupptimer < 0 then
--            audio.play("hah3", o.x, o.y, 0.9)
--            o.properties.schwupptimer = 10
--          end
--        end
--      end
--    end

--    o.ground = o.vy >= 0 and (
--      solid(o.x, o.y+o.vy+1) or
--      (not grid(o, 0, 0) and grid(o, 0, o.vy+1)) or
--      (not o.type=="BLOCK" and grid(o, 0, 0) and block(o.x, o.y+o.vy+1))
--    )

    if o.y == nil then pprint {o} end -- TODO find error after winnig against ice_boss
    o.water = water(o.x, o.y+tw/2+2)
    o.wall = false
    o.ground = false
    o.ladder = o.type~="LADDER" and get_first_overlap(transient.types.LADDER, o, 0, 0) ~= nil

    local LADDERHEIGHT = 20
    if o.properties.fixedon~=nil and math.abs(scripting.byId(o.properties.fixedon).y - o.y) > LADDERHEIGHT then
      o.y = scripting.byId(o.properties.fixedon).y + LADDERHEIGHT
      o.vy = 0
    elseif not o.ladder then
      o.vy = o.vy + (o.gravity or .5) / (o.water and 15 or 1)
    end

--    if o.ground or (o.vy < 0
--    and (solid(o.x, o.y+o.vy-w*2+1) or grid(o, 0, o.vy+1))) then
--      if o.vy > 2 then audio.play("hit", o.x, o.y-200) end
--      o.vy = 0
--    end
--  end

    -- horizontal
    if o.vx ~= 0 then
      local vx, y = o.vx, o.y
      local right = vx > 0 and 1 or 0
      local front = o.x - o.ox + right * o.width

      -- is the area of tiles, we want to enter, nonsolid
      if unsolid_area (
        right + tileOf(front + (1-right) * vx), -- x_from
        right + tileOf(front + right * vx), -- x_to
        tileOf(y - o.oy - 1), -- y_from
        tileOf(y - o.oy - 1 + o.height) + 1 -- y_to
      ) and not grid(o, vx, -1) then
        o.x = o.x + vx
      else

        o.wall = true
        o.vx = 0
        if math.abs(vx) > 2.5 then
          sfx.hitground(o.x, o.y-o.height+o.oy, math.abs(vx) > 11 and 2 or 1)
        end
      end
    end

    -- vertical
    if o.vy ~= 0 then
      local vy, x = o.vy, o.x
      local up = vy > 0 and 1 or 0
      local front = o.y - o.oy + up * o.height - 1

      -- is the area of tiles, we want to enter, nonsolid
      if unsolid_area (
        tileOf(x - o.ox), -- x_from
        tileOf(x - o.ox + o.width) + 1, -- x_to
        up + tileOf(front + (1-up) * vy), -- y_from
        up + tileOf(front + up * vy) -- y_to
      ) and not grid(o, 0, vy) then
        o.y = o.y + vy

      else
        o.vy = 0
        if vy > 0 then
--          o.y = ?
          o.ground = true
        end

        if math.abs(vy) > 2.5 then
          sfx.hitground(o.x, o.y-o.height+o.oy, math.abs(vy) > 11 and 2 or 1)
        end
      end
    end

    if o.water then
      o.vx = .9 * o.vx
      o.vy = .9 * o.vy
    elseif o.ground then
      o.vx = o.vx * (o.friction or .8)
    else
      o.vx = o.vx * (o.airfriction or .8)
    end
  end
end

return move_obj
