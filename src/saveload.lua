--- Saving and Loading
-- require $serialize, $scripting

local serialize = require "serialize"
local change_level = require "map.maps"
local scripting = require "map.scripting"

local M = {}
local indent = false

local function save(slot, place)
  scripting.hooks.unload()

  local now = os.time()
  slot.playtime = slot.playtime + now - M.sessionstart
  slot.lastsaved = now
  slot.version = GAME_VERSION
  M.sessionstart = now

  -- pull avatar,
  -- remove REMOVED for real
  slot.avatar = avatar
  local pool = slot[slot.mapname].pool
  for i=#pool,1,-1 do
    local o = pool[i]
    if o == avatar then 
      table.remove(pool, i)

    elseif o.type == "REMOVED" then 
      table.remove(pool, i)

    end
  end

  assert(love.filesystem.write(place,
    "return " .. serialize(slot, nil, indent)
  ))

  print("SAVED")

  -- plug avatar
  slot.avatar = nil
  table.insert(pool, avatar)

  scripting.hooks.load()
end

--- 
function M.save_slot (slot)
  save(slot, slot.slotname .. ".save")
end

--- slot is either nil, a filename, or a table
function M.load_slot (slot)
  transient = nil

  if type(slot) == "nil" then
    local scripted = require "scripts.main"
    persistence = scripted.create_new_game()
    persistence.slotname = "Slot " .. (#M.get_slots() + 1)
    persistence.playtime = 0
    print("\nNEW GAME")

  elseif type(slot) == "string" then
--    persistence = assert(love.filesystem.load(slot .. ".save"))()
    error("\nLOADED " .. quote(persistence.slotname))

  else
    persistence = slot
    print("\nOPENED " .. quote(slot.slotname))

  end

  -- start session, pull avatar
  M.sessionstart = os.time()
  avatar = persistence.avatar

  -- open level
  change_level(persistence.mapname)
end

--- 
function M.autosave ()
  save(persistence, "save.auto")
end

--- 
function M.autoload ()
  transient = nil
  persistence = assert(love.filesystem.load("save.auto"))()

  -- start session, pull avatar
--  M.sessionstart = os.time()
  avatar = persistence.avatar
--  persistence.vars.kills = persistence.vars.kills + 1

  -- open level
  change_level(persistence.mapname)
end

--- 
function M.move_slot (slot, newname)
  love.filesystem.remove(slot.slotname .. ".save")
  print("MOVED", slot.slotname, "TO", newname)
  slot.slotname = newname

  assert(love.filesystem.write(slot.slotname .. ".save",
    "return " .. serialize(slot, nil, indent)
  ))
end

--- 
function M.clean_trash ()
  for i,slot in ipairs(M.get_trash()) do
    love.filesystem.remove(slot.slotname .. ".save")
  end
end


local function get_slots (filter)
  slots = {}
  love.filesystem.getDirectoryItems(".", function (file) 
    if file:sub(-5) == ".save" then
      local slot = assert(love.filesystem.load(file))()
      if slot.version == GAME_VERSION
      and filter(slot) then
        table.insert(slots, slot)
      end
    end
  end)
  table.sort(slots, function (a,b) return a.lastsaved > b.lastsaved end)
  return slots
end

--- returns slots
function M.get_slots () return get_slots(function (slot)
  return slot.trash == nil end) end

--- returns trashed slots
function M.get_trash () return get_slots(function (slot)
  return slot.trash end) end

return M
