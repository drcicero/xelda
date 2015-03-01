--- read tiled maps
local scripting = require "map.scripting"

--- returns a tuple (level, persistent part of the level).
--
-- level := {layers=[{type="objectlayer"}, {"tilelayer"}]}
--
-- persistent := {vars={*}, pool=[{class=*, x,y,width,height, ...}], water_y=0}
local function parse_map (src)
  local default_state = { 
    vars = {}, -- game logic variables
    water_y = 0,
  }

  local transient = assert(love.filesystem.load("maps/" .. src .. ".lua"))()
  transient.types = {META={}, REMOVED={}}
  for i, s in ipairs(sprites) do transient.types[s] = {} end

  -- build default vars
  for k,v in pairs(transient.properties) do
    default_state.vars[k] = assert(loadstring("return " .. v))()
  end

  -- adapt objs and extract the persistent objs into default_pool
  for i,layer in ipairs(transient.layers) do
    if layer.name == "Zones" then
      transient.zones = layer.objects
      layer.objects = {}

    elseif layer.type == "objectgroup" then
      for j, o in ipairs(layer.objects) do
        -- rename
        o.class, o.type = o.type, nil
        o.r, o.rotation = o.rotation and math.rad(o.rotation) or nil, nil
        if o.r == 0 then o.r = math.huge end

        -- convert gid (number) to type (string)
        o.type, o.gid = o.gid and (sprites[o.gid] or "DUMMY") or "META", nil

        -- offset objects
        if o.width == 0 then -- TODO why this condition?
          o.width, o.height = nil, nil

          o.x = o.x + tw/2
          o.y = o.y - 1

          if o.type=="GRID" then
            o.width = 20
            o.height = 20
          end
        end

        -- remove tiled-specific attrs
        o.shape = nil
        o.visible = nil
      end

      if layer.name == "objs" then
        default_state.pool = layer.objects
      end

    elseif layer.name == "Ground" then
      transient.solidmap = layer.data

    elseif layer.name == "Water" then
      transient.watermap = layer.data
      layer.properties.parallax_x = 0.4
      layer.properties.parallax_y = 0.2
      layer.opacity = 0.5

    elseif layer.name == "background" then
      layer.properties.parallax_x = 0.3
      layer.properties.parallax_y = 0.3

    end
  end

  scripting.hooks.load(src)

--  print()
  return transient, default_state
end

return parse_map
