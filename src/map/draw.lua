--- Tiled Interface
-- requires $src.map.scripting

local camera = require "map.camera"
local scripting = require "map.scripting"

local persistence = require "state" -- TODO can be eliminated

local M = {}
local tw
local g = love.graphics
local floor = math.floor

local sps, canvas_cache

--- load tileset
function M.load (tw_)
  tw = tw_

  M.tileset = love.graphics.newImage "assets/tileset.png"
  sprites = require "assets/tileset"
  sprites_indexOf = {}
  for i,s in ipairs(sprites) do sprites_indexOf[s] = i end

  M.quads = {}
  local quads = M.quads
  local setw = M.tileset:getWidth()
  local seth = M.tileset:getHeight()
  local sw = setw / tw
  for i = 0, sw * seth/tw do
    local quad = g.newQuad((i%sw)*tw, floor(i/sw)*tw, tw, tw, setw, seth)
    table.insert(quads, quad)
  end
end

--- clear singleton
function M.clear_layers ()
  sps = {}
  canvas_cache = {}
end

--- 
function M.layer_init (layer)
  local tileset = M.tileset

  if not sps[layer] then
    sps[layer] = g.newSpriteBatch(tileset, #layer.data)

    local sp = sps[layer]
    local lw = layer.width
    local quads = M.quads

    sp:bind()
    for i,tile in ipairs(layer.data) do
      i = i-1
      if tile ~= 0 then
        local x = (i%lw)*tw
        local y = floor(i/lw)*tw
        sp:add(quads[tile], x, y)
      end
    end
    sp:unbind()
  end

  if CANVAS then
    canvas_cache[layer] = g.newCanvas(
      transient.width * transient.tilewidth,
      transient.height * transient.tileheight
    )

    local canvas = canvas_cache[layer]

    g.setCanvas(cache)
    g.setColor(255, 255, 255, 255*layer.opacity)
    g.draw(sps[layer], x, y, 0, parallax_x, parallax_y)
    g.setCanvas()
  end
end

--- 
function M.draw_layers (transient, pool)
  not_yet_pool_drawn = false

  for i,layer in ipairs(transient.layers) do
    if layer.type == "tilelayer" then
      local lprop = layer.properties
      local parallax_x = (i/#transient.layers - 0.5) * tonumber(lprop and lprop.parallax_x or 0) + 1
      local parallax_y = (i/#transient.layers - 0.5) * tonumber(lprop and lprop.parallax_y or 0) + 1
      M.draw_tilelayer(layer, parallax_x, parallax_y)

    elseif layer.type == "objectgroup" then
      if layer.name == "objs" then
        scripting.hook("draw")
        not_yet_pool_drawn = true
        for i,o in ipairs(layer.objects) do M.draw_obj(o) end
      end
    end
  end

  if not_yet_pool_drawn then
    scripting.hook("draw")
--    table.foreach(pool, objs.draw)
  end
end

---
function M.draw_tilelayer (layer, parallax_x, parallax_y)
  local x = floor(camera.x * (1-parallax_x))
  local y = floor(camera.y * (1-parallax_y))

  if layer.name == "Water" then
    x = x + math.sin(now)*tw/2
    y = y + math.sin(now/.5)*tw/4 - persistence[persistence.mapname].water_y
  end

  if CANVAS then
    -- TODO FIXME BUG cant see anything
    g.setColor(255, 255, 255, 255)
    g.setBlendMode("premultiplied")
    g.draw(canvas_cache[layer], x, y, 0, parallax_x, parallax_y)
    g.setBlendMode("alpha")

  else
    g.setColor(255, 255, 255, 255*layer.opacity)
    g.draw(sps[layer], x, y, 0, parallax_x, parallax_y)
  end
end

--- 
function M.draw_obj (o)
  -- valid type
  if o.type ~= "REMOVED" and not o.disabled and o.type ~= "META" then
    -- in camera
    if camera.x - camera.w/2 - tw/2 < o.x
    and o.x < camera.x + camera.w/2 + tw/2
    and camera.y - camera.h/2 < o.y
    and o.y < camera.y + camera.h/2 + tw then
      -- sprite
      local noturn = o.noturn
      local sx = noturn and 1 or o.facing
      local r  = (o.r==math.huge or o.r==nil) and 0 or o.r
      local oz = o.z or 1
      g.setColor(o.red or 255, o.green or 255, o.blue or 255, o.alpha or 255)
      g.draw(M.tileset, M.quads[sprites_indexOf[o.type]],
        o.x,o.y, r, sx*oz,oz, o.ix,o.iy)

      -- the eye of the eye ;)
      if o.type == "EYE" then
        g.setColor(0,0,0,255)
        local x, y = avatar.x-o.x, avatar.y-o.y
        local len = math.sqrt(x * x + y * y)/3
        g.rectangle("fill", floor(o.x+x/len)-1, floor(o.y+y/len-tw/2)-1, 4, 4)
      end

      if DEBUG then
        g.push()
        g.translate(o.x, o.y)

        g.setColor(255, 255, 255, 50)
        g.rectangle("line", -2, -2, 4, 4)

        g.rotate(r)
        g.rectangle("line", -o.ix, -o.iy, tw, tw)
        g.rectangle("line", -o.ox, -o.oy, o.width, o.height)

        g.pop()
      end
    end
  end
end

return M
