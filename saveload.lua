serialize = require "serialize"

function save_slot (slot)
  -- save
  if transient and transient.name and level[transient.name] then
    level[transient.name].unload()
  end

  persistence.lastsaved = os.time()

  assert(love.filesystem.write(slot.slotname .. ".save",
    "return " .. serialize(persistence)
  ))

  print("saved")

  if transient and transient.name and level[transient.name] then level[transient.name].load() end
end

function load_slot (slot)
  -- clear & load
  transient = nil

  if type(slot) == "nil" then
    persistence = {
      slotname = "Slot #1",
      mapname = "mainmenu",
      vars = {health=6, hearts=3, keys=0, rubies=0},
    }

  elseif type(slot) == "string" then
    persistence = assert(love.filesystem.load(file))()

  else
    persistence = slot
  end

  change_level(persistence.mapname)
end

function move_slot (old, new)
  move_file(old .. ".save", new .. ".save")
end
function trash_slot (slot)
  slot.trash = true
  save_slot(slot)
end
function untrash_slot (slot)
  slot.trash = nil
  save_slot(slot)
end

function move_file (old, new)
  local content = love.filesystem.read(old)
  love.filesystem.remove(old)
  love.filesystem.write(new, content)
  print("removed", old)
  print("created", new)
end

function clean_trash_slots ()
  for i,name in ipairs(search_slots(true)) do
    love.filesystem.remove(slot.name)
  end
end

function search_slots (trash)
  slots = {}
  love.filesystem.getDirectoryItems(".", function (file) 
    if file:sub(-5) == ".save" then
      local slot = assert(love.filesystem.load(file))()
      if trash and slot.trash or not trash and slot.trash == nil then
        table.insert(slots, slot)
      end
    end
  end)
  table.sort(slots, function (a,b) return a.lastsaved > b.lastsaved end)
  return slots
end

