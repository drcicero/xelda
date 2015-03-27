local GAME_VERSION, love, pprint, w, h = GAME_VERSION, love, pprint, w, h
local maps = require("map.maps")
local scripting = require("map.scripting")
local serialize = (require("serialize")).serialize
local sessionstart
local indent = true
local get_slots_
get_slots_ = function(filter)
  local slots = { }
  love.filesystem.getDirectoryItems(".", function(file)
    if file:sub(-5) == ".save" then
      local slot = assert(love.filesystem.load(file))()
      if slot.version == GAME_VERSION and filter(slot) then
        return table.insert(slots, slot)
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
  return get_slots_(function(slot)
    return slot.trash == nil
  end)
end
local get_trash
get_trash = function()
  return get_slots_(function(slot)
    return slot.trash
  end)
end
local save
save = function(slot, place)
  local now
  now = os.time()
  slot.playtime = slot.playtime + now - sessionstart
  slot.lastsaved = now
  slot.version = GAME_VERSION
  sessionstart = now
  scripting.hook("before_save")
  print("return " .. (serialize(slot, nil, indent)))
  maps.compress()
  assert(love.filesystem.write(place, "return " .. (serialize(slot, nil, indent))))
  print("SAVED")
  maps.decompress()
  return scripting.hook("after_save")
end
local save_slot
save_slot = function(slot)
  return save(slot, slot.filename .. ".save")
end
local load_slot
load_slot = function(slot)
  if nil == slot then
    print("\nNEW GAME")
    persistence = (require("scripts.main")).create_new_game()
    local num_slots
    num_slots = #get_slots()
    persistence.filename = num_slots + 1
    persistence.slotname = "Slot " .. (num_slots + 1)
    persistence.playtime = 0
  else
    print("\nLOAD " .. (slot.slotname))
    persistence = slot
  end
  sessionstart = os.time()
  maps.open_level(persistence.mapname)
  if topisgame then
    return scripting.hook("focus")
  end
end
local autosave
autosave = function() end
local autoload
autoload = function()
  persistence = assert(love.filesystem.load("save.auto"))()
  persistence.vars.kills = (persistence.vars.kills or 0) + 1
  maps.open_level(persistence.mapname)
  if topisgame then
    return scripting.hook("focus")
  end
end
local move_slot
move_slot = function(slot, newname)
  slot.name = newname
end
local clean_trash
clean_trash = function()
  for i, slot in ipairs(get_trash()) do
    love.filesystem.remove(slot.filename .. ".save")
  end
end
return {
  autoload = autoload,
  autosave = autosave,
  load_slot = load_slot,
  save_slot = save_slot,
  get_slots = get_slots,
  get_trash = get_trash,
  move_slot = move_slot,
  clean_trash = clean_trash
}
