local state = require "state"
local scripting = require "map.scripting"
local byId, byClass = scripting.byId, scripting.byClass

return {
  funcs = {
    onkillslime = function ()
      local vars = state[state.mapname].vars
      if vars.enemies > 0 then
        vars.enemies = vars.enemies - 1

      elseif vars.enemies == 0 then
        vars.enemies = vars.enemies - 1
        scripting.setVar("eye", true)
      end
    end
  },

  focus = function ()
    local enemies = byClass("enemy")
    state[state.mapname].vars.enemies = #enemies
    for i=1,#enemies do
      enemies[i].properties.onkill = "$onkillslime"
    end
  end,
}
