local tiled = {}
local tw
local g = love.graphics

local sps, canvas_cache

function tiled.load (tw_)
  tw = tw_
  tiled.tileset = love.graphics.newImage "assets/tileset.png"

  tiled.quads = {}
  local quads = tiled.quads
  local setw = tiled.tileset:getWidth()
  local seth = tiled.tileset:getHeight()
  local sw = setw / tw
  for i = 0, sw * seth/tw do
    local quad = g.newQuad((i%sw)*tw, floor(i/sw)*tw, tw, tw, setw, seth)
    table.insert(quads, quad)
  end

  sprites = {
    "XELDA", "XELDA_WALK", "XELDA_SHIELD", "XELDA_HOLD", "XELDA_ATTACK", "XELDA_ATTACK2", "XELDA_BOW", "?",
    "RINK", "RINK_WALK", "RINK_SHIELD", "RINK_HOLD", "RINK_ATTACK2", "RINK_ATTACK", "RINK_BOW", "?",
    "SLIME", "ESLIME", "PIG", "SKELETON", "BAT1", "BAT2", "BAT_SIT", "GHOST",
    "HASH", "LAMP", "GLOVE", "BOW", "CONTAINER", "KEY", "FISH", "FISH2",
    "BIGKEY", "BLOCK", "BOMB1", "BOMB2", "YELLOW", "CYAN", "MAGENTA", "?",
    "HEART_EMPTY", "HEART_HALF", "HEART", "RUBY1", "RUBY5", "RUBY10", "RUBY50", "RUBY100",
    "ARROWS", "SWORD", "ELECTRO", "?", "DUMMY", "BOMB", "ARROW", "NUT",
    "?", "?", "?", "?", "?", "?", "?", "LOCK",
    "?", "?", "?", "?", "?", "?", "?", "HOLE",
    "?", "?", "SWITCH", "SWITCH2", "?", "?", "?", "CHEST",
    "?", "?", "?", "TABLET", "SHIELD", "?", "GRASS", "GRID",
    "?", "?", "TRIGGER", "TRIGGER2", "?", "?", "BIG_LOCK", "BIG_LOCK_OPEN",
    "?", "?", "EYE", "EYE2", "?", "?", "?", "?",
    "?", "?", "?", "?", "?", "?", "?", "?",
    "?", "?", "?", "LAMPPOST", "LAMPPOST_ON", "?", "?", "?",
  }
  sprites_indexOf = {}
  for i,s in ipairs(sprites) do
    sprites_indexOf[s] = i
  end
end

function tiled.clear_layers ()
  sps = {}
  canvas_cache = {}
end

function tiled.layer_init (layer)
  local tileset = tiled.tileset

  if not sps[layer] then
    sps[layer] = g.newSpriteBatch(tileset, #layer.data)

    local sp = sps[layer]
    local lw = layer.width
    local quads = tiled.quads

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
      map.width * map.tilewidth,
      map.height * map.tileheight
    )

    local canvas = canvas_cache[layer]

    g.setCanvas(cache)
    g.setColor(255, 255, 255, 255*layer.opacity)
    g.draw(sps[layer], x, y, 0, parallax_x, parallax_y)

    g.setCanvas()
  end
end

function tiled.draw_layers (map, pool)
  local not_yet_pool_drawn = true

  for i,layer in ipairs(map.layers) do
    if layer.type == "tilelayer" then
      local lprop = layer.properties
      local parallax_x = (i/#map.layers - 0.5) * tonumber(lprop and lprop.parallax_x or 0) + 1
      local parallax_y = (i/#map.layers - 0.5) * tonumber(lprop and lprop.parallax_y or 0) + 1
      local x = floor(camera.x * (1-parallax_x))
      local y = floor(camera.y * (1-parallax_y))

      if layer.name == "Water" then
        x = x + math.sin(now/1000)*tw/2
        y = y + math.sin(now/500)*tw/4
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

    elseif layer.type == "objectgroup" then
      table.foreach(layer.objects, tiled.draw_obj)

      if not_yet_pool_drawn then
        not_yet_pool_drawn = true
        table.foreach(pool, tiled.draw_obj)
      end
    end
  end

  if not_yet_pool_drawn then
    table.foreach(pool, tiled.draw_obj)
  end
end

function tiled.draw_obj (i, o)
  if o.type ~= "REMOVED" and not o.disabled and o.type ~= "META" then
    if camera.x - cam_min_x - tw/2 < o.x and o.x < camera.x + cam_min_x + tw/2
    and camera.y - cam_min_y < o.y and o.y < camera.y + cam_min_y + tw then
      local sx = o.r==math.huge and o.facing or 1
      local r = o.r==math.huge and 0 or o.r
      g.setColor(255, 255, 255, o.alpha or 255)
      g.draw(tiled.tileset, tiled.quads[sprites_indexOf[o.type]],
        o.x,o.y, r, sx,1, o.ix,o.iy)

      if o.type == "EYE" then
        g.setColor(0,0,0,255)
        local x, y = avatar.x-o.x, avatar.y-o.y
        local len = math.sqrt(x * x + y * y)/4
        g.rectangle("fill", floor(o.x+x/len-2), floor(o.y-tw/2+y/len-2), 4, 4)
      end

      if DEBUG then
        g.push()
        g.translate(o.x, o.y)

        g.setColor(255, 255, 255, 50)
        g.rectangle("fill", -2, -2, 4, 4)

        g.rotate(r)
        g.rectangle("fill", -o.ix, -o.iy, tw, tw)
        g.rectangle("line", -o.ox, -o.oy, o.width, o.height)

        g.pop()
      end
    end
  end
end

return tiled
