--- Level loading
-- requires $cron, $audio, $draw, $scripting

audio = require "audio"
cron_new_clock = (require "cron").new_clock

pool = require "pool" -- former transient
entities = require "entities"
persistence = require "state" -- former persistence

draw = require "map.draw"
camera = require "map.camera"
scripting = require "map.scripting"
is_transient_type = require "map.is_transient_type"
parse_map = require "map.parse_map"

g = love.graphics

--- globals
export avatar, transient

--------------------------------------------------------------------------------

ensure_music = (ch, newmusic)->
  unless audio.channels[ch] and audio.channels[ch].name == newmusic
    audio.music newmusic, ch

contains = (list, thing)->
  for i, o in ipairs(list)
    return true  if list[i] == thing
  return false

--------------------------------------------------------------------------------

compress_objs = ->
  print "compress_objs"
  local pool, o
  pool = persistence[persistence.mapname].pool
  for i = #pool, 1, -1
    o = pool[i]
    if o.type=="REMOVED" or is_transient_type[o.type]
      table.remove pool, i
    else
      entities.compress o


decompress_objs = ->
  print "decompress_objs"
  local pool2
  pool2 = persistence[persistence.mapname].pool
  transient.byid = {}
  for i = #pool2,1,-1
    local o
    o = pool2[i]
    pool.init o
    if o.properties.switch
      o.disabled = scripting.getVar o.properties.switch

  return


show_objs = ->
  print "insert_objs"
  local layer
  for _,layer in ipairs(transient.layers)
    if layer.name == "objs"
      layer.objects = persistence[persistence.mapname].pool
      return

  error "there must be a layer called 'objs'"


partial_level_reset = ->
  print "partial_level_reset"
  local pool2, state, default_state
  _, default_state = parse_map persistence.mapname

  pool2 = persistence[persistence.mapname].pool
  for _,o in ipairs(default_state.pool)
    if is_transient_type[o.type]
      pool.init o
      table.insert pool2, o

  return

--------------------------------------------------------------------------------

exclude_avatar = ->
  print "exclude_avatar"
  local pool, o
  persistence.avatar, avatar = avatar, nil

  pool = persistence[persistence.mapname].pool
  for i = #pool, 1, -1
    if pool[i] == persistence.avatar
      table.remove pool, i


include_avatar = ->
  print "include_avatar"
  if persistence.avatar == nil
    error "ERR: no avatar to load"

  avatar, persistence.avatar = persistence.avatar, nil

  local pool
  pool = persistence[persistence.mapname].pool
  if contains pool, avatar
    print "WARN: loaded level already contains avatar?"
  else
    table.insert pool, avatar

  camera.resized!
  return


come_from = (prev)->
  print "come_from"
  for meta,_ in pairs transient.types.META
    if meta.properties.TO == prev
      avatar.x = meta.x + meta.width/2
      avatar.y = meta.y + meta.height-5
      camera.jump avatar
      return

  error "ERR: No Door in [" .. persistence.mapname .. "] to [" .. prev .. "]"

--------------------------------------------------------------------------------

close_curtain = ->
  print "close_curtain"
  exclude_avatar!
  compress_objs!
  return


open_curtain = ->
  print "open_curtain"
  decompress_objs!
  include_avatar!
  ensure_music "default", transient.properties.landmusic or "Ruins"

  -- layers
  draw.clear_layers!
  for i,layer in ipairs transient.layers
    if layer.type == "tilelayer"
      draw.layer_init layer

  return

--------------------------------------------------------------------------------

init_level = ->
  print "init_level"
  local state, default_state
  transient, default_state = parse_map persistence.mapname
  state = persistence[persistence.mapname] or default_state -- first time or load?
  persistence[persistence.mapname] = state
  show_objs!

  transient.levelclock = cron_new_clock!
  open_curtain!
  return


use_door_to = (to)->
  print "use_door_to"
  local prev

  close_curtain!
  prev, persistence.mapname = persistence.mapname, to
  init_level!
  partial_level_reset!
  come_from prev

  scripting.hook "focus"  if topisgame


{:use_door_to, :init_level, :include_avatar, :exclude_avatar}
