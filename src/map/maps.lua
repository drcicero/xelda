local cron = require("cron")
local audio = require("audio")
local objs = require("map.objs")
local draw = require("map.draw")
local camera = require("map.camera")
local scripting = require("map.scripting")
local is_transient_type = require("map.is_transient_type")
local parse_map = require("map.parse_map")
local g = love.graphics
persistence = { }
local get_level
get_level = function()
  return persistence[persistence.mapname]
end
local contains
contains = function(list, thing)
  for i, o in ipairs(list) do
    if list[i] == thing then
      return true
    end
  end
  return false
end
local compress
compress = function()
  persistence.avatar = avatar
  local pool, o
  pool = persistence[persistence.mapname].pool
  for i = #pool, 1, -1 do
    o = pool[i]
    if o == avatar or o.type == "REMOVED" then
      table.remove(pool, i)
    else
      objs.compress(o)
    end
  end
end
local decompress
decompress = function()
  transient.byid = { }
  local pool
  pool = persistence[persistence.mapname].pool
  for i = #pool, 1, -1 do
    local o
    o = pool[i]
    if o.name ~= "" and o.name ~= nil then
      transient.byid[o.name] = o
    end
    objs.cacheType(o)
    objs.decompress(o)
  end
  draw.clear_layers()
  for i, layer in ipairs(transient.layers) do
    if layer.type == "tilelayer" then
      draw.layer_init(layer)
    end
  end
  if persistence.avatar == nil then
    error("ERR: no avatar to load")
  end
  avatar = persistence.avatar
  local pool
  pool = persistence[persistence.mapname].pool
  if contains(pool, avatar) then
    print("WARN: loaded level already contains avatar?")
  else
    table.insert(pool, avatar)
  end
  camera.resized()
  local newmusic
  newmusic = transient.properties.landmusic or "Ruins"
  if not ((audio.channels.default and audio.channels.default.name == newmusic)) then
    audio.music(newmusic, "default")
  end
end
local load_level
load_level = function(to)
  persistence.mapname = to
  local state, default_state
  transient, default_state = parse_map(to)
  state = persistence[to] or default_state
  persistence[to] = state
  transient.levelclock = cron.new_clock()
  local layer
  if state ~= default_state then
    for i = 1, #transient.layers do
      layer = transient.layers[i]
      if layer.name == "objs" then
        layer.objects = state.pool
        break
      end
    end
  end
end
local open_level
open_level = function(to)
  load_level(to)
  return decompress()
end
local delete_transient_objs
delete_transient_objs = function()
  local prev, pool, o
  prev = persistence.mapname
  pool = persistence[prev].pool
  for i = #pool, 1, -1 do
    o = pool[i]
    if is_transient_type[o.type] then
      table.remove(pool, i)
    end
  end
end
local load_transient_objs
load_transient_objs = function(to)
  local pool, default_state
  local _
  _, default_state = parse_map(to)
  pool = persistence[persistence.mapname].pool
  local layer, o
  for i = 1, #transient.layers do
    if transient.layers[i].name == "objs" then
      for j = 1, #default_state.pool do
        o = default_state.pool[j]
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
local set_position_to_door
set_position_to_door = function(prev)
  for meta, _ in pairs(transient.types.META) do
    if meta.properties.TO == prev then
      avatar.x = meta.x + meta.width / 2
      avatar.y = meta.y + meta.height - 5
      camera.jump(avatar)
      return 
    end
  end
  return error("Warning: No Door from " .. prev .. " to " .. persistence.mapname)
end
local use_door_to
use_door_to = function(to)
  local prev
  prev = persistence.mapname
  delete_transient_objs()
  compress()
  open_level(to)
  load_transient_objs(to)
  set_position_to_door(prev)
  if topisgame then
    return scripting.hook("focus")
  end
end
return {
  use_door_to = use_door_to,
  get_level = get_level,
  open_level = open_level,
  compress = compress,
  decompress = decompress
}
