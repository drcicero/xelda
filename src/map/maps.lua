local audio = require("audio")
local cron_new_clock = (require("cron")).new_clock
local pool = require("pool")
local entities = require("entities")
local persistence = require("state")
local draw = require("map.draw")
local camera = require("map.camera")
local scripting = require("map.scripting")
local is_transient_type = require("map.is_transient_type")
local parse_map = require("map.parse_map")
local g = love.graphics
local ensure_music
ensure_music = function(ch, newmusic)
  if not (audio.channels[ch] and audio.channels[ch].name == newmusic) then
    return audio.music(newmusic, ch)
  end
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
local compress_objs
compress_objs = function()
  print("compress_objs")
  local pool, o
  pool = persistence[persistence.mapname].pool
  for i = #pool, 1, -1 do
    o = pool[i]
    if o.type == "REMOVED" or is_transient_type[o.type] then
      table.remove(pool, i)
    else
      entities.compress(o)
    end
  end
end
local decompress_objs
decompress_objs = function()
  print("decompress_objs")
  local pool2
  pool2 = persistence[persistence.mapname].pool
  transient.byid = { }
  for i = #pool2, 1, -1 do
    local o
    o = pool2[i]
    pool.init(o)
    if o.properties.switch then
      o.disabled = scripting.getVar(o.properties.switch)
    end
  end
end
local show_objs
show_objs = function()
  print("insert_objs")
  local layer
  for _, layer in ipairs(transient.layers) do
    if layer.name == "objs" then
      layer.objects = persistence[persistence.mapname].pool
      return 
    end
  end
  return error("there must be a layer called 'objs'")
end
local partial_level_reset
partial_level_reset = function()
  print("partial_level_reset")
  local pool2, state, default_state
  local _
  _, default_state = parse_map(persistence.mapname)
  pool2 = persistence[persistence.mapname].pool
  for _, o in ipairs(default_state.pool) do
    if is_transient_type[o.type] then
      pool.init(o)
      table.insert(pool2, o)
    end
  end
end
local exclude_avatar
exclude_avatar = function()
  print("exclude_avatar")
  local pool, o
  persistence.avatar, avatar = avatar, nil
  pool = persistence[persistence.mapname].pool
  for i = #pool, 1, -1 do
    if pool[i] == persistence.avatar then
      table.remove(pool, i)
    end
  end
end
local include_avatar
include_avatar = function()
  print("include_avatar")
  if persistence.avatar == nil then
    error("ERR: no avatar to load")
  end
  avatar, persistence.avatar = persistence.avatar, nil
  local pool
  pool = persistence[persistence.mapname].pool
  if contains(pool, avatar) then
    print("WARN: loaded level already contains avatar?")
  else
    table.insert(pool, avatar)
  end
  camera.resized()
end
local come_from
come_from = function(prev)
  print("come_from")
  for meta, _ in pairs(transient.types.META) do
    if meta.properties.TO == prev then
      avatar.x = meta.x + meta.width / 2
      avatar.y = meta.y + meta.height - 5
      camera.jump(avatar)
      return 
    end
  end
  return error("ERR: No Door in [" .. persistence.mapname .. "] to [" .. prev .. "]")
end
local close_curtain
close_curtain = function()
  print("close_curtain")
  exclude_avatar()
  compress_objs()
end
local open_curtain
open_curtain = function()
  print("open_curtain")
  decompress_objs()
  include_avatar()
  ensure_music("default", transient.properties.landmusic or "Ruins")
  draw.clear_layers()
  for i, layer in ipairs(transient.layers) do
    if layer.type == "tilelayer" then
      draw.layer_init(layer)
    end
  end
end
local init_level
init_level = function()
  print("init_level")
  local state, default_state
  transient, default_state = parse_map(persistence.mapname)
  state = persistence[persistence.mapname] or default_state
  persistence[persistence.mapname] = state
  show_objs()
  transient.levelclock = cron_new_clock()
  open_curtain()
end
local use_door_to
use_door_to = function(to)
  print("use_door_to")
  local prev
  close_curtain()
  prev, persistence.mapname = persistence.mapname, to
  init_level()
  partial_level_reset()
  come_from(prev)
  if topisgame then
    return scripting.hook("focus")
  end
end
return {
  use_door_to = use_door_to,
  init_level = init_level,
  include_avatar = include_avatar,
  exclude_avatar = exclude_avatar
}
