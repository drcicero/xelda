local objs = require "map.objs"
local scripting = require "map.scripting"

return {
  focus = function ()
    cutscene("hello", function ()
      local fairy = objs.spawn("FAIRY", 30, 120)
      fairy.properties.image = "Watson"
      fairy.gravity = 0
      scripting.wander_by(fairy, 240, 90)
      scripting.dialog(fairy, "It is only a question of time                     and we do not have much left.")
      objs.del(fairy)
    end)
  end
}

