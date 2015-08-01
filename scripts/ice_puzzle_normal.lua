local state = require "state"
local scripting = require "map.scripting"
local byId = scripting.byId

local function change_water (self)
    local bool = scripting.getVar("lr")
    state[state.mapname].water_y = bool and -6*20 or 0
    scripting.setVar("lr", not bool)
end

return {
  funcs = {
    change_water = change_water,
  },

  focus = function ()
    change_water()
    change_water()
  end,
}
