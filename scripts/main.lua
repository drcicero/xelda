local M = {}

function M.create_new_game()
  return {
    mapname = "rinks_room",

    vars = {
      health = 6, hearts = 3,
      keys = 0, rubies = 0,
      avatar_name = "SLEEPY_RINK",
      sword = false,
    },

    avatar = {
      type = "SLEEPY_RINK_BLINK",
      x = 2*20,
      y = 3.5*20,
      r = -0.4*math.pi,
      gravity = 0,
    },
  }
end

return M

