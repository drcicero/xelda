local scripting = require "map.scripting"
local byId = scripting.byId
local state = require "state"

return {
  funcs = {
    chest = function (o, bool)
      local vars = state[state.mapname].vars
      if bool then
        vars.chest = vars.chest - 1
      end
      return vars.chest == 0
    end,
  },
}

