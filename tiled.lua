local tiled = {}
local tw
local g = love.graphics

function tiled.load (tw_)
  tw = tw_
  tiled.tileset = love.graphics.newImage "assets/tileset.png"

  tiled.quads = {}
  local quads = tiled.quads
  local setw = tiled.tileset:getWidth()
  local seth = tiled.tileset:getHeight()
  local sw = setw / tw
  for i = 0, setw/tw * seth/tw do
    local quad = g.newQuad((i%sw)*tw, floor(i/sw)*tw, tw, tw, setw, seth)
    table.insert(quads, quad)
  end

  sprites = {
    "XELDA", "XELDA_WALK", "XELDA_SHIELD", "XELDA_HOLD", "XELDA_ATTACK", "XELDA_ATTACK2", "XELDA_BOW", "?",
    "RINK", "RINK_WALK", "RINK_SHIELD", "RINK_HOLD", "RINK_ATTACK2", "RINK_ATTACK", "RINK_BOW", "?",
    "SLIME", "ESLIME", "PIG", "SKELETON", "BAT1", "BAT2", "BAT_SIT", "GHOST",
    "HASH", "LAMP", "GLOVE", "BOW", "CONTAINER", "KEY", "?", "?",
    "BIGKEY", "BLOCK", "BOMB1", "BOMB2", "YELLOW", "CYAN", "MAGENTA", "?",
    "HEART_EMPTY", "HEART_HALF", "HEART", "RUBY1", "RUBY5", "RUBY10", "RUBY50", "RUBY100",
    "ARROWS", "?", "?", "?", "DUMMY", "BOMB", "ARROW", "NUT",
    "?", "?", "?", "?", "?", "?", "?", "LOCK",
    "?", "?", "?", "?", "?", "?", "?", "HOLE",
    "?", "?", "SWITCH", "SWITCH2", "?", "?", "?", "CHEST",
    "?", "?", "?", "TABLET", "SHIELD", "?", "GRASS", "GRID",
    "?", "?", "TRIGGER", "TRIGGER2", "?", "?", "?", "?",
    "?", "?", "EYE", "EYE2", "?", "?", "?", "?",
    "?", "?", "?", "?", "?", "?", "?", "?",
    "?", "?", "?", "LAMPPOST", "LAMPPOST_ON", "?", "?", "?",
  }
  sprites_indexOf = {}

  types = {}
  for i,s in ipairs(sprites) do
    types[s] = {}
    sprites_indexOf[s] = i
  end
end

function tiled.draw_layer (layer, x, y, r, sx, sy)
  local tileset = tiled.tileset

  local size = #layer.data
  if not layer.sp then
    layer.sp = g.newSpriteBatch(tileset, size)
  else
    layer.sp:clear()
  end
  local sp = layer.sp
  if sp:getBufferSize() ~= size then sp:setBufferSize(size) end
  sp:bind()

  local lw = layer.width
  local quads = tiled.quads
  for i,tile in ipairs(layer.data) do
    if tile ~= 0 then
      local x = (i%lw)*tw
      local y = floor(i/lw)*tw
      if SPRITEBATCH then
        sp:add(quads[tile], x, y)
      else
        g.draw(tileset, quads[tile], x, y)
      end
    end
  end

  if SPRITEBATCH then
    sp:unbind()
    g.draw(sp, x, y, r, sx, sy)
  end
end

function tiled.draw_layers()
  for i,layer in ipairs(stage.layers) do
    if layer.type == "tilelayer" then
      local lprop = layer.properties
      local parallax_x = (i/#stage.layers - 0.5) * tonumber(lprop and lprop.parallax_x or 0) + 1
      local parallax_y = (i/#stage.layers - 0.5) * tonumber(lprop and lprop.parallax_y or 0) + 1
      local x = camera.x * (1-parallax_x)
      local y = camera.y * (1-parallax_y)

      if layer.name == "Water" then
        x = x - (now%1000)/1000 * tw*1.25
        y = math.sin(now/500) * tw/4 + y
      end

      if CANVAS then
        g.setColor(255, 255, 255, 255)
        g.setBlendMode("premultiplied")
        g.draw(layer.cache, x, y, 0, parallax_x, parallax_y)
        g.setBlendMode("alpha")

      else
        g.setColor(255, 255, 255, 255*layer.opacity)
        tiled.draw_layer(layer, x, y, 0, parallax_x, parallax_y)
      end

    elseif layer.type == "objectgroup" then
      table.foreach(layer.objects, tiled.draw_obj)
    end
  end
end

function tiled.draw_obj (i, o)
  if not o.disabled then
    if camera.x - cam_min_x < o.x and o.x < camera.x + cam_min_x
    and camera.y - cam_min_y < o.y and o.y < camera.y + cam_min_y then

      if DEBUG then
        g.setColor(255, 255, 255, 50)
        g.rectangle("line", o.x-tw/2, o.y-tw, tw, tw)
        g.rectangle("fill", o.x-2, o.y-2, 4, 4)

      else
        local sx if o.vx < 0 then sx=-1 else sx=1 end
        g.setColor(255,255,255,255)
        g.draw(tiled.tileset, tiled.quads[sprites_indexOf[o.type]], o.x-tw/2-(sx-1)*tw/2, o.y-tw, 0, sx, 1)
      end
    end
  end
end

return tiled
