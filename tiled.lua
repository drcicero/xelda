local tiled = {}
local stage, tw
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

return tiled
