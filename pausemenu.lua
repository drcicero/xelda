require "menu"

local M = {}
local options = { fs="OFF", mvol=10, svol=10 }

--- options: fullscreen / volume
function M.options () return menu.column({
  menu.label("Options"):set("styles", menu.styles.header),
  menu.label(""),

  menu.label("Music Volume"),
  menu.range("mvol", {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10})
    :set("change", function (self)
      local value = self.range[self.sel]
      audio.setMVol(value/10)
    end),

  menu.label("Sound Volume"),
  menu.range("svol", {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10})
    :set("change", function (self)
      local value = self.range[self.sel]
      audio.setSVol(value/10)
      audio.play "hah"
    end),

  menu.label(""),
  menu.button("Return", menu.goto(M.pausemenu))
    :set("style", menu.styles.pop),
})
  :set("enter", function (self)
    local form = self:getForm()
--    form.fs.sel = options.fs == "ON" and 2 or 1
    form.mvol.sel = options.mvol+1
    form.svol.sel = options.svol+1
  end)
  :set("exit", function (self)
    local form = self:getForm()
--    options.fs = form.fs.range[form.fs.sel]
    options.mvol = form.mvol.range[form.mvol.sel]
    options.svol = form.svol.range[form.svol.sel]
  end)
end


--- credits: persons and tools
function M.credits () return menu.column ({
  menu.label("Credits"):set("style", menu.styles.header),
  menu.label("Dr Cicero\n- Idea and Implementation\n- Graphics\n- Sounds and some Music\n- using Löve, Tiled, Gimp, Rosegarden, beepbox.co"),
  menu.label("His Uncle\n- Music\n- using Ludwig, Cubase"),
  menu.label(""),
  menu.button("Return", menu.goto(M.pausemenu))
    :set("style", menu.styles.pop),
  w = 300
})
end

function M.pausemenu ()
  local result = menu.column {
    menu.label("Pause")
      :set("style", menu.styles.header),
    menu.label(""),
    menu.button("Continue", pop_app_state)
      :set("style", menu.styles.primary),
    menu.label(""),
    menu.button("Options", menu.goto(M.options)),
    menu.button("Credits", menu.goto(M.credits)),
    menu.label(""),
    menu.button("Save and Quit", function ()
      print("saving")
      save_slot(persistence)
      love.event.quit()
    end),
    bg = {0,0,0,100}, fill = {0,0,0,100}, pad = 10,
    x=50, w=200,
  }
  result:layout()
  result.y = h-result.h
  return result
end

return M
