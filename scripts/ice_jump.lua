local scripting = require "map.scripting"
local byId = scripting.byId
require "switchs"

return {
  funcs = {
    start = function ()
      setVar("time", true)
    end,
    stop = function ()
      local yel = byId ""
      setVar("time", false)
      yel.y = 258
    end,
  },
  
  load = function ()
    local yel = byId ""
    setVar("time", false)
    yel.y = 258
  end,
}
