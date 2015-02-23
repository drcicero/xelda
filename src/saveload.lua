local serialize = require("serialize")
local change_level = require("map.maps")
local scripting = require("map.scripting")
local quote = (require("serialize")).quote
serialize = (require("serialize")).serialize
local GAME_VERSION, love, pprint, w, h = GAME_VERSION, love, pprint, w, h
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
  scripting.hooks.unload()
  now = os.time()
  slot.playtime = slot.playtime + now - sessionstart
  slot.lastsaved = now
  slot.version = GAME_VERSION
  sessionstart = now
  slot.avatar = avatar
  local pool = slot[slot.mapname].pool
  for i = #pool, 1, -1 do
    local o = pool[i]
    if o == avatar then
      table.remove(pool, i)
    elseif o.type == "REMOVED" then
      table.remove(pool, i)
    end
  end
  assert(love.filesystem.write(place, "return " .. (serialize(slot, nil, indent))))
  print("SAVED")
  slot.avatar = nil
  table.insert(pool, avatar)
  return scripting.hooks.load()
end
local save_slot
save_slot = function(slot)
  return save(slot, slot.filename .. ".save")
end
local load_slot
load_slot = function(slot)
  transient = nil
  if "nil" == type(slot) then
    local scripted = require("scripts.main")
    persistence = scripted.create_new_game()
    local slots
    slots = get_slots()
    persistence.filename = #slots + 1
    persistence.slotname = "Slot " .. (#slots + 1)
    persistence.playtime = 0
    print("\nNEW GAME")
  elseif "string" == type(slot) then
    error("\nLOADED " .. (persistence.slotname))
  else
    persistence = slot
    print("\nOPENED " .. (slot.slotname))
  end
  sessionstart = os.time()
  avatar = persistence.avatar
  return change_level(persistence.mapname)
end
local autosave
autosave = function()
  return save(persistence, "save.auto")
end
local autoload
autoload = function()
  transient = nil
  persistence = assert(love.filesystem.load("save.auto"))()
  avatar = persistence.avatar
  return change_level(persistence.mapname)
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
