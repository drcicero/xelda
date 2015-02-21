--- Level loading
-- requires $cron, $audio, $draw, $scripting

local cron = require "cron"
local audio = require "audio"

local objs = require "map.objs"
local draw = require "map.draw"
local camera = require "map.camera"
local scripting = require "map.scripting"

local g = love.graphics

-- TODO
-- state
-- transient
-- state.const
-- transient.const
-- TODO or maybe not

--- globals
-- transient, types, avatar, persistence
transient = nil
types = nil
avatar = nil

persistence = {}

local is_transient_type = {
  TABLET=1, SHIELD=1, GRID=1, META=1,
  GRASS=1, RUBY1=1, HEART=1, ARROWS=1,
  SLIME=1, ESLIME=1, FISH=1, FISH2=1,
  ELECTRO=1, ARROW=1, SWORD=1, PUFF=1,
  REMOVED=1,
}


--- private
local function clean_map_manager (from)
  -- clear transient data of old level
  if from then
    scripting.hooks.unload()

    -- pull avatar,
    -- remove type == "REMOVED" for real,
    -- remove transient types,
    -- and clean rest
    local stage = persistence[from]
    for i=#stage.pool,1,-1 do
      local o = stage.pool[i]
      if o == avatar or is_transient_type[o.type] then
        table.remove(stage.pool, i)

      else
        objs.clean(o)
      end
    end
  end

  -- layer cache
  draw.clear_layers()

  -- type cache
  types = {META={}, REMOVED={}}
  for i,s in ipairs(sprites) do types[s] = {} end
end


--- private.
-- returns (the constant state of the map, dynamic state of the map)
local function load_map (src)
  local default_state = { 
    vars = {}, -- game logic variables
    pool = {}, -- obj pool
    water_y = 0,
  }

  local transient = assert(love.filesystem.load("maps/" .. src .. ".lua"))()

  -- build default vars
  for k,v in pairs(transient.properties) do
    default_state.vars[k] = assert(loadstring("return " .. v))()
  end

  -- adapt objs and extract the persistent objs into default_pool
  for i,layer in ipairs(transient.layers) do
    if layer.name == "Zones" then
      -- extract
      transient.zones = layer.objects
      layer.objects = {}

    elseif layer.type == "objectgroup" then
      local objs = {}

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

        -- clean draw-specific attrs
        o.shape = nil
        o.visible = nil

--        -- transient or persistent?
--        local is_transient = layer.name ~= "objs" or is_transient_type[o.type]
--        if is_transient then o.is_transient = true end
        table.insert(default_state.pool, o)
      end

      transient.layers[i] = {
        type="objectgroup",
        opacity=1,
        objects={},
        name=layer.name
      }
--      if layer.name=="objs" then transient.pool = objs end

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

  return transient, default_state
end


--- private
local function unclean_map_manager (from, to)
  levelclock = cron.new_clock()

  -- create transient data and default state of new level 
  local default_state
  transient, default_state = load_map(to)

  -- try loading or use default
  local state = persistence[to] or default_state
  persistence[to] = state
  persistence.mapname = to

  -- change music
  local newmusic = transient.properties.landmusic or "Ruins"
  if not (audio.channels.default and audio.channels.default.name == newmusic) then
    audio.music(newmusic, "default")
  end

  -- unclean objs
  table.foreachi(state.pool, objs.unclean)
  for i,layer in ipairs(transient.layers) do
    if layer.type == "objectgroup" then
      table.foreachi(layer.objects, objs.unclean)

    elseif layer.type == "tilelayer" then
      -- layer cache
      draw.layer_init(layer)
    end
  end

  -- plug avatar, only if not already plugged
  local found = false
  for i,o in ipairs(state.pool) do
    if state.pool[i] == avatar then
      found = true break
    end
  end
  if not found then
    table.insert(state.pool, avatar)
  end


  if from then
    --print("from", from)

    if state ~= default_state then
      for i = 1, #default_state.pool do
        local o = default_state.pool[i]
        if is_transient_type[o.type] then
          table.insert(state.pool, o)
          objs.unclean(nil, o)
        end
      end
    end

    local found = false
    for meta,_ in pairs(types.META) do
      if meta.properties.TO == from then
        avatar.x = meta.x + meta.width/2
        avatar.y = meta.y + meta.height-5
        found = true
        break
      end
    end

    if not found then
      error("Warning: No Door from " .. from ..
            " to " .. persistence.mapname)
    end
  end

  -- focus camera
  camera.resized()

  scripting.hooks.load()
  if topisgame then scripting.hooks.focus() end
end


--- go to map with name 'name'
local function change_level (to)
  change_level_timer = 100
  local from = transient and persistence.mapname

  clean_map_manager(from)
  unclean_map_manager(from, to)
end


return change_level
