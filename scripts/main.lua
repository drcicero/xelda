local M = {}

local objs = require "map.objs"

function M.create_new_game()
  local avatar = {
    type = "SLEEPY_RINK_BLINK",
    x = 2*20,
    y = 3.5*20,
    r = -0.4*math.pi,
    gravity = 0,
  }
  objs.decompress(avatar)

  return {
    mapname = "rinks_room",

    vars = {
      health = 6, hearts = 3,
      keys = 0, rubies = 0,
      avatar_name = "SLEEPY_RINK",
      sword = false,
    },

    avatar = avatar
  }
end

return M