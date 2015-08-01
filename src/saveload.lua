local persistence = require("state")
local entities = require("entities")
local GAME_VERSION, love, pprint, w, h = GAME_VERSION, love, pprint, w, h
local maps = require("map.maps")
local scripting = require("map.scripting")
local serialize = (require("serialize")).serialize
local sessionstart
local INDENT = true
local _get_slots
_get_slots = function(filter)
  local slots
  slots = { }
  love.filesystem.getDirectoryItems(".", function(file)
    if file:sub(-5) == ".save" then
      local slot = assert(love.filesystem.load(file))()
      if slot.meta.version == GAME_VERSION and filter(slot) then
        return table.insert(slots, slot.meta)
      end
    end
  end)
  table.sort(slots, function(a, b)
    return a.lastsaved > b.lastsaved
  end)
  return slots
end
local get_slots
get_slots = function()
  return _get_slots(function(slot)
    return not slot.meta.trash
  end)
end
local get_trash
get_trash = function()
  return _get_slots(function(slot)
    return slot.meta.trash
  end)
end
local clean_trash
clean_trash = function()
  for i, slot in ipairs(get_trash()) do
    love.filesystem.remove(slot.filename .. ".save")
  end
end
local save
save = function(slot, path)
  local now
  now = os.time()
  slot.meta.playtime = slot.meta.playtime + now - sessionstart
  slot.meta.lastsaved = now
  slot.meta.version = GAME_VERSION
  sessionstart = now
  scripting.hook("before_save")
  maps.exclude_avatar()
  assert(love.filesystem.write(path, "return " .. (serialize(slot, nil, INDENT))))
  maps.include_avatar()
  return scripting.hook("after_save")
end
local load
load = function(slot)
  for k, v in pairs(persistence) do
    persistence[k] = nil
  end
  for k, v in pairs(slot) do
    persistence[k] = v
  end
  sessionstart = os.time()
  maps.init_level()
  if topisgame then
    return scripting.hook("focus")
  end
end
local make_slot
make_slot = function()
  local n
  n = (#get_slots() + 1)
  return {
    filename = n,
    slotname = "Slot " .. n,
    playtime = 0
  }
end
local save_slot
save_slot = function(slot)
  local realslot
  realslot = assert(love.filesystem.load(slot.filename .. ".save"))()
  realslot.meta = slot
  return save(realslot, slot.filename .. ".save")
end
local load_slot
load_slot = function(slot)
  local realslot
  if slot.playtime == 0 then
    realslot = (require("scripts.main")).create_new_game()
    realslot.meta = slot
    entities.decompress(realslot.avatar)
  else
    realslot = assert(love.filesystem.load(slot.filename .. ".save"))()
  end
  load(realslot)
end
local exists_auto
exists_auto = function()
  return love.filesystem.exists("save.auto")
end
local clear_auto
clear_auto = function()
  return love.filesystem.remove("save.auto")
end
local autosave
autosave = function()
  return save(persistence, "save.auto")
end
local autoload
autoload = function()
  load(assert(love.filesystem.load("save.auto"))())
  persistence.vars.kills = (persistence.vars.kills or 0) + 1
  return autosave()
end
return {
  exists_auto = exists_auto,
  clear_auto = clear_auto,
  autoload = autoload,
  autosave = autosave,
  load_slot = load_slot,
  save_slot = save_slot,
  get_slots = get_slots,
  make_slot = make_slot,
  get_trash = get_trash,
  clean_trash = clean_trash,
  save = save
}
