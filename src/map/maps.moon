--- Level loading
-- requires $cron, $audio, $draw, $scripting

cron = require "cron"
audio = require "audio"

objs = require "map.objs"
draw = require "map.draw"
camera = require "map.camera"
scripting = require "map.scripting"
is_transient_type = require "map.is_transient_type"

parse_map = require "map.parse_map"

g = love.graphics


-- TODO FEATURE save other levels to disk, dont keep them in memory
-- TODO FEATURE use classes?

--- globals
export avatar, transient, persistence
persistence = {}


get_level = ->
  persistence[persistence.mapname]


contains = (list, thing)->
  for i, o in ipairs(list)
    return true  if list[i] == thing

  return false


compress = ()->
  -- pull avatar, compress objs
  persistence.avatar = avatar

  local pool, o
  pool = persistence[persistence.mapname].pool
  for i = #pool, 1, -1
    o = pool[i]
    if o == avatar or o.type == "REMOVED"
      table.remove pool, i
    else
      objs.compress o

  return


decompress = ()->
  transient.byid = {}
  local pool
  pool = persistence[persistence.mapname].pool
  for i = #pool,1,-1
    local o
    o = pool[i]
    transient.byid[o.name] = o  if o.name ~= "" and o.name ~= nil
    objs.cacheType o
    objs.decompress o

  -- layers
  draw.clear_layers!
  for i,layer in ipairs(transient.layers)
    if layer.type == "tilelayer"
      draw.layer_init(layer)

  -- push avatar
  if persistence.avatar == nil
    error "ERR: no avatar to load"

--  avatar, persistence.avatar = persistence.avatar, nil
  avatar = persistence.avatar

  local pool
  pool = persistence[persistence.mapname].pool
  if contains pool, avatar
    print "WARN: loaded level already contains avatar?"
  else
    table.insert pool, avatar

  camera.resized!

  -- music
  local newmusic
  newmusic = transient.properties.landmusic or "Ruins"
  unless (audio.channels.default and audio.channels.default.name == newmusic)
    audio.music newmusic, "default"

  return


load_level = (to)->
  persistence.mapname = to

  local state, default_state
  transient, default_state = parse_map to
  state = persistence[to] or default_state -- first time or load?
  persistence[to] = state

  transient.levelclock = cron.new_clock()

  -- if loading, replace default objects with saved objects
  local layer
  if state ~= default_state
    for i=1, #transient.layers
      layer = transient.layers[i]
      if layer.name == "objs"
        layer.objects = state.pool
        break

  return


open_level = (to)->
  load_level to
  decompress!


-- TODO migrate following to game
delete_transient_objs = ->
  local prev, pool, o
  prev = persistence.mapname

  -- scripting.hook "unload"

  -- delete transients objs
  pool = persistence[prev].pool
  for i = #pool,1,-1
    o = pool[i]
    if is_transient_type[o.type]
      table.remove(pool, i)

  return


load_transient_objs = (to)->
  local pool, default_state
  _, default_state = parse_map(to)

  pool = persistence[persistence.mapname].pool

  local layer, o
  for i = 1, #transient.layers
    if transient.layers[i].name == "objs"
      for j = 1, #default_state.pool
        o = default_state.pool[j]
        if is_transient_type[o.type]
          transient.byid[o.name] = o  if o.name ~= "" and o.name ~= nil
          objs.cacheType o
          objs.decompress o
          table.insert pool, o

      break

  return

set_position_to_door = (prev)->
  for meta,_ in pairs transient.types.META
    if meta.properties.TO == prev
      avatar.x = meta.x + meta.width/2
      avatar.y = meta.y + meta.height-5
      camera.jump avatar
      return

  error("Warning: No Door from " .. prev .. " to " .. persistence.mapname)


use_door_to = (to)->
  local prev
  prev = persistence.mapname

  delete_transient_objs!
  compress!
  open_level to
  load_transient_objs to
  set_position_to_door prev

  scripting.hook "focus"  if topisgame


{:use_door_to, :get_level, :open_level, :compress, :decompress}
