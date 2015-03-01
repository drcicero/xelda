local cron = require "cron"
local audio = require "audio"

local objs = require "map.objs"
local scripting = require "map.scripting"

local dialog = scripting.dialog
local wander_by = scripting.wander_by

return {
  focus = function ()
    cutscene("intialize", function ()
      for i,o in pairs(scripting.byClass("carpet")) do
        o.gravity = 0
        o.vy = 0
      end

      scripting.byId("goleft").properties.onfirsttouch = "$scene"
    end)
  end,

  funcs = {
    scene = function ()
    cutscene("hello", function ()
      fairy = objs.spawn("FAIRY", 18.5*20, 10*20)
      fairy.properties.image = "Watson"
      fairy.gravity = 0

      wander_by(fairy, -5*20, -10)

      dialog(fairy, "Where is the king?")
      wander_by(fairy, -5*20, -10)

      dialog(" Well thats strange... But then again, there is no time.")
      wander_by(fairy, 1*20, -10)

      dialog(fairy, " Maybe he is already in the secret chamber of THE GREEN ONE.")
      function nth_call(times, func)
        return function(...)
          times = times - 1
          if times == 0 then func(...) end
        end
      end

      audio.play "tadadi"
      local continue = nth_call(4, resume)
      for i,o in pairs(scripting.byClass("carpet")) do
        sceneclock.add {dur=4, f=cron.by(o, "y", -50), ended=continue}
      end

      dialog(fairy, "Has anyone ever told you the saga of our land?")
      wander_by(fairy, -2*20, -20)
      wander_by(fairy, -3*20, 40)

--      dialog(" Follow me.")
--          wander_by(fairy, -3*20, 40)

      objs.del(fairy)

    end) end,
  },
}

