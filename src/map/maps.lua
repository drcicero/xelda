--- Level loading
-- requires $cron, $audio, $draw, $scripting

local cron = require "cron"
local audio = require "audio"

local objs = require "map.objs"
local draw = require "map.draw"
local camera = require "map.camera"
local scripting = require "map.scripting"
local is_transient_type = require "map.is_transient_type"

local parse_map = require "map.parse_map"

local g = love.graphics

-- TODO FEATURE save other levels to disk, dont keep them in memory
-- TODO FEATURE use classes?

--- globals
-- level, avatar, persistence
levelclock = nil
transient = nil
avatar = nil
persistence = {}

local function get_level()
  return persistence[persistence.mapname]
end


local function contains (list, thing)
  for i,o in ipairs(list) do
    if list[i] == thing then
      return true
    end
  end
  return false
end


local function compress () -- prepare_saving
  print("compress")

--  scripting.hook("unload")

  -- pull avatar, compress objs
  persistence.avatar = avatar
  local pool = persistence[persistence.mapname].pool
  for i=#pool,1,-1 do local o = pool[i]
    if o == avatar then
      table.remove(pool, i)
    else
      objs.compress(o)
    end
  end
end


local function decompress () -- complete_loading
  print("decompress")
  transient.byid = {}
  local pool = persistence[persistence.mapname].pool
  for i=#pool,1,-1 do local o = pool[i]
    if o.name ~= "" and o.name ~= nil then
      transient.byid[o.name] = o
    end
    objs.cacheType(o)
    objs.decompress(o)
  end

  -- layers
  draw.clear_layers()
  for i,layer in ipairs(transient.layers) do
    if layer.type == "tilelayer" then
      draw.layer_init(layer)
    end
  end

  -- push avatar
  avatar, persistence.avatar = persistence.avatar, nil
  local pool = persistence[persistence.mapname].pool
  if not contains(pool, avatar) then
    table.insert(pool, avatar)
  else
    print("WARN: loaded level already contains avatar?")
  end
  camera.resized()

  -- music
  local newmusic = transient.properties.landmusic or "Ruins"
  if not (audio.channels.default and audio.channels.default.name == newmusic) then
    audio.music(newmusic, "default")
  end
end


local function load_level (to)
  print("load_level")
  levelclock = cron.new_clock()

  local default_state
  transient, default_state = parse_map(to)

  -- first time or load?
  local state = persistence[to] or default_state
  persistence[to] = state
  persistence.mapname = to

  -- if this level was open before, then replace default objects
  -- with saved objects
  if state ~= default_state then
    for i=1, #transient.layers do
      local layer = transient.layers[i]
      if layer.name == "objs" then
        layer.objects = state.pool
        break
      end
    end
  end
end


local function close_level ()
  print("close_level")
  compress()
end

local function open_level (to)
  print("open_level")
  load_level(to)
  decompress()
end


-- TODO migrate following to game

local function delete_transient_objs ()
  print("delete_transient_objs")
  local from = persistence.mapname

  scripting.hook("unload")

  -- delete transients objs
  local pool = persistence[from].pool
  for i=#pool,1,-1 do local o = pool[i]
    if is_transient_type[o.type] then
      table.remove(pool, i)
    end
  end
end


local function load_transient_objs(to)
  print("load_transient_objs")
  local default_state
  _, default_state = parse_map(to)

  local pool = persistence[persistence.mapname].pool

  for i=1, #transient.layers do
    local layer = transient.layers[i]
    if layer.name == "objs" then
      for i = 1, #default_state.pool do
        local o = default_state.pool[i]
        if is_transient_type[o.type] then
          if o.name ~= "" and o.name ~= nil then
            transient.byid[o.name] = o
          end
          objs.cacheType(o)
          objs.decompress(o)
          table.insert(pool, o)
        end
      end
      break
    end
  end
end


local function set_position_to_door (from)
  print("set_position_to_door")
  for meta,_ in pairs(transient.types.META) do
    if meta.properties.TO == from then
      avatar.x = meta.x + meta.width/2
      avatar.y = meta.y + meta.height-5
      camera.jump(avatar)
      return
    end
  end

  error("Warning: No Door from " .. from ..
        " to " .. persistence.mapname)
end


local function use_door_to (to)
  print("use_door_to")
  local from = persistence.mapname

  delete_transient_objs()
  compress()
  open_level(to)
  load_transient_objs(to)
  set_position_to_door(from)

  if topisgame then scripting.hook("focus") end
end


return {
  use_door_to = use_door_to,
  get_level = get_level,
  open_level = open_level,
  compress = compress,
  decompress = decompress,
  is_transient_type=is_transient_type,
}
