serialize = require "serialize"

local slotname = nil
function set_slot (slotname_)
  slotname = slotname_
end

function save_slot ()
  -- save
  assert(love.filesystem.write(slotname .. ".save",
    "return " .. serialize(persistence)
  ))

  assert(love.filesystem.write(slotname .. ".metasave",
    "return " .. serialize({
      time = os.time(),
      mapname = map.name,
      vars = player,
    })
  ))

  print("saved to", love.filesystem.getSaveDirectory() .. "/" .. slotname .. ".save")
  print("saved to", love.filesystem.getSaveDirectory() .. "/" .. slotname .. ".metasave")

  local types = {}
  for k,state in pairs(persistence) do
    for i,o in ipairs(state.pool) do
      if not types[o.type] then types[o.type]=0 end
      types[o.type] = types[o.type]+1
    end
  end
  local type_count = {}
  for k,v in pairs(types) do
    table.insert(type_count, {v, k})
  end
  table.sort(type_count, function (a,b) return a[1] > b[1] end)
  print(serialize(type_count))
end

function load_slot ()
  -- clear
  map = nil
  state = nil

  -- load
  persistence = assert(love.filesystem.load(slotname .. ".save"))()
  local save = assert(love.filesystem.load(slotname .. ".metasave"))()

  print("loaded")

  player = save.vars
  player.health = 6
  change_level(save.mapname)
end

function remove_slot ()
  love.filesystem.remove(slotname .. ".save")
  love.filesystem.remove(slotname .. ".metasave")
end

function move_slot (newslotname)
  local save = love.filesystem.read(slotname .. ".save")
  local meta = love.filesystem.read(slotname .. ".metasave")

  love.filesystem.remove(slotname .. ".save")
  love.filesystem.remove(slotname .. ".metasave")

  slotname = newslotname

  love.filesystem.write(slotname .. ".save", save)
  love.filesystem.write(slotname .. ".metasave", meta)
end

function trash_slot ()
  local save = love.filesystem.read(slotname .. ".save")
  local meta = love.filesystem.read(slotname .. ".metasave")

  love.filesystem.remove(slotname .. ".save")
  love.filesystem.remove(slotname .. ".metasave")

  love.filesystem.write(slotname .. ".trashsave", save)
  love.filesystem.write(slotname .. ".trashmetasave", meta)
end

function untrash_slot ()
  local save = love.filesystem.read(slotname .. ".trashsave")
  local meta = love.filesystem.read(slotname .. ".trashmetasave")

  love.filesystem.remove(slotname .. ".trashsave")
  love.filesystem.remove(slotname .. ".trashmetasave")

  love.filesystem.write(slotname .. ".save", save)
  love.filesystem.write(slotname .. ".metasave", meta)
end

function clean_trash_slots ()
  for i, f in ipairs(search_slots(true)) do
    love.filesystem.remove(f .. ".trashsave")
    love.filesystem.remove(f .. ".trashmetasave")
  end
end

function search_slots (trash)
  slots = {}
  local dirname = "."--love.filesystem.getSaveDirectory():gsub("//", "/"):gsub(" ", "\\ ")
  love.filesystem.getDirectoryItems(dirname, function (file) 
    if not trash and file:sub(-9) == ".metasave"
    or trash and file:sub(-14) == ".trashmetasave" then
      local slot = assert(love.filesystem.load(file))()
      slot.title = file:sub(1, trash and -15 or -10)
      table.insert(slots, slot)
    end
  end)
  return slots
end

