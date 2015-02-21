local scripting = require "map.scripting"
local byId = scripting.byId
require "switchs"

return {
  funcs = {
    start = function ()
      setVar("time", true)
    end,

    stop = function (self, bool)
      if bool then
        local yel = byId "yel"
        setVar("time", false)
        yel.y = 240
      end
    end,
  },
  
--[[  load = function ()
    local yel = byId "yel"
    setVar("time", false)
    yel.y = 0
  end,
--]]
}
