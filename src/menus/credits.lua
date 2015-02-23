local menu = require "menu"

--- credits: persons and tools
return function () return menu.column {
  name = "credits",
  bg = {0,0,0,150}, fill = {0,0,0,100}, pad = 30,
  x=50, y=200, w=400,

--  menu.parse [[
--Credits ;header
--Dr Cicero
--- Idea and Implementation, Graphics, Sound and some Music
--- using Love2d, Tiled, Gimp, Rosegaden and beepbox.co
--His Uncle
--- most Music
--- usin Ludwig Cubase

--Return ;pop
--]]

  menu.label("Credits")
    :set("type", "header"),
  menu.label(""),
  menu.label("Dr Cicero"),
  menu.label("- Idea and Implementation, Graphics, Sounds and some Music"),
  menu.label("- using Love2d, Tiled, Gimp, Rosegarden, beepbox.co"),
  menu.label(""),
  menu.label("His Uncle"),
  menu.label("- most Music"),
  menu.label("- using Ludwig, Cubase"),
  menu.label(""),
  menu.button("Return", menu.pop)
    :set("type", "pop"),

} :set("resize", function (self)
    self.x = w/2 - self.w/2
    self.y = h/2 - self.h/2
  end)
end

