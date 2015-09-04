local M = {}

function M.create_new_game()
  return {
    mapname = "ice_entry",

    vars = {
      health = 6, hearts = 3,
      keys = 0, rubies = 0,
      avatar_name = "XELDA",
      sword = true,
    },

    avatar = {
      type = "XELDA",
      x = 24*20, y = 8.5*20,
    },
  }
end

return M

