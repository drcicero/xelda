local app = require "frames"
local menu = require "menu"

local slots = require "menus.slots"
local options = require "menus.options"
local credits = require "menus.credits"
local saveload = require "saveload"

return function () return menu.column {
    name = "pausemenu",
    bg = {0,0,0,150}, fill = {0,0,0,100}, pad = 10,
    x=50, y=200, w=300,

    menu.label("Pause")
      :set("type", "header"),
    menu.label(""),
    menu.button("Continue", menu.pop)
      :set("type", "primary"),
    menu.label(""),
    menu.button("Options", function() app.push(options()) end),
    menu.button("Credits", function() app.push(credits()) end),
    menu.label(""),
    menu.button("Dont Save and Quit", menu.goto(slots.slots)),
    menu.button("Save and Quit", function ()
      saveload.save_slot(persistence)
      menu.goto(slots.slots)()
    end),

}:set("resize", function (self)
  self.y = h-self.h
end)
end