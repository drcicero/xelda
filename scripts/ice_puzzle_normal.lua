local scripting = require "map.scripting"
local byId = scripting.byId
require "switchs"

return {
  funcs = {
    change_water = function (self, bool)
      persistence[persistence.mapname].water_y = bool and 0 or -6*20
      setVar("lr", bool, self)
    end,
  },

  load = function ()
    persistence[persistence.mapname].water_y = -6*20
    setVar("lr", false)
  end,
}
