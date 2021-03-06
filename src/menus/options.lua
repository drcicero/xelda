local menu = require "menu"
local audio = require "audio"

--- options: fullscreen / volume
return function () return menu.column {
  name = "options",
  bg = {0,0,0,150}, fill = {0,0,0,100}, pad = 30,
  x=50, y=200, w=300,

--[=[
  menu.parse [[
Options ;header

Fullscreen
window|borderless|fullscreen
Music Volume
0|.2|.4|.6|.8|1 #mvol
Sound Volume
0|.2|.4|.6|.8|1 #svol

Return ;pop
]]

]=]

  menu.label("Options")
    :set("type", "header"),
  menu.label(""),

  menu.label("Fullscreen"),
  menu.range("fs", {"window", "borderless", "fullscreen"}, function (self)
    local fs = {false, true, true}
    local mode = {"normal", "desktop", "normal"}
    love.window.setFullscreen(fs[self.sel], mode[self.sel])
    fullscreentimer = 10
  end),

  menu.label("Music Volume"),
  menu.range("mvol", {0, .2, .4, .6, .8, 1}, function (self)
    local value = self.range[self.sel]
    audio.setMVol(value)
  end),

  menu.label("Sound Volume"),
  menu.range("svol", {0, .2, .4, .6, .8, 1}, function (self)
    local value = self.range[self.sel]
    audio.setSVol(value)
    audio.play "hah"
  end),

--  menu.label("Particles"),
--  menu.range("parts", {0, 1, 2, 5}, function (self)
--    local value = self.range[self.sel]
--    audio.setSVol(value)
--    audio.play "hah"
--  end),

--[[
  menu.label("If the game does not run at 60fps try this:"),
  menu.range("fixfps", {"default", "free_the_physics"})
    :set("change", function (self)
      timestep = self.sel==1
    end),
]]

  menu.label(""),
  menu.button("Return", menu.pop)
    :set("type", "pop"),

} :set("enter", function (self)
    local form = self:getForm()
    local fs, mode = love.window.getFullscreen()
    form.fs.sel = not fs and 1 or mode=="desktop" and 2 or 3
    form.mvol.sel = math.floor(audio.mvol*(#form.mvol.range-1)+1)
    form.svol.sel = math.floor(audio.svol*(#form.svol.range-1)+1)
--    form.fixfps.sel = timestep and 1 or 2
  end)
  :set("resize", function (self)
    self.x = w/2 - self.w/2
    self.y = h/2 - self.h/2
  end)
--  :set("exit", function (self)
--  end)
end

