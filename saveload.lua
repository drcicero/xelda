serialize = require "serialize"

function save_game ()
  -- save
  assert(love.filesystem.write("save.lua", "return " .. serialize({
    player = player,
    persistence = persistence,
    mapname = map.name,
  })))

  print("saved to", love.filesystem.getSaveDirectory())

  local types = {}
  for k,state in pairs(states) do
    for i,o in ipairs(state.pool) do
      if not types[o.type] then types[o.type]=0 end
      types[o.type] = types[o.type]+1
    end
  end
  print(serialize(types))
end

function load_game ()
  quit = function ()
    -- clear
    map = nil
    state = nil

    -- load
    local save = assert(love.filesystem.load("save.lua"))()
    player = save.player
    persistence = save.persistence
    change_level(save.mapname)
  end
end

