local menu = require "menu"
local l, b = menu.label, menu.button

local state = require "state"
local saveload = require "saveload"

local slots = require "menus.slots"
local options = require "menus.options"
local credits = require "menus.credits"

return function ()
  return menu.column {
    name = "pausemenu",
    bg = {0,0,0,150}, fill = {0,0,0,100},
    x=50, y=200, w=300, pad=10,

    l("Pause")              :set("type", "header"),
    l(""),
    b("Continue", menu.pop) :set("type", "primary"),
    l(""),
    b("Options", function() menu.push(options()) end),
    b("Credits", function() menu.push(credits()) end),
    l(""),
--    b("Kill Progress and Quit", function ()
--      saveload.clear_auto()
--      menu.goto(slots.slots))
--    end,
    b("Save and Quit", function ()
      saveload.save(state, state.meta.filename..".save")
      saveload.clear_auto()
      menu.goto(slots.slots)()
    end),

  }:set("resize", function (self)
    self.y = h-self.h
  end)
end
