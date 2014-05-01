--- Main 
-- This is the module
love.graphics.setDefaultFilter("linear", "nearest")

w = love.graphics.getWidth()
h = love.graphics.getHeight()

require "saveload"
require "menu"
require "game"

function love.load ()
  -- options
  DEBUG = false
--  -- FIXME canvas are invisible?
--   CANVAS = love.graphics.isSupported("canvas", "npot")

  -- load libs
  audio.load()

  --- menu frames
  -- This is so
  local frames = {}

  --- a slot
  -- how to draw a slot
  function frames.slot (slot) return function ()
    set_slot(slot.title)

    local list = {
      menu.label("Slot > " .. slot.title):set("style", menu.styles.header),

      menu.label(""),
      menu.button(slot.time and "Continue game" or "Begin game", function ()
        change_app_state(game)
        set_slot(slot.title)
        if slot.time then load_slot() else change_level "mainmenu" end

        clean_trash_slots()
      end):set("style", menu.styles.primary),

      menu.button("Return", menu.goto(frames.slots)),

      menu.label(" "),
      menu.label("Change Slotname:"),
      menu.input("slotname", slot.title)
        :set("change", function (self)
          self.parent[1].title = "Slot > " .. self.title
          if slot.time then
            set_slot(slot.title)
            move_slot(self.title)
          end
          slot.title = self.title
        end),
    }

    if slot.time then
      table.insert(list, #list-2, menu.label(""))
      table.insert(list, #list-2, menu.button("Discard this slot", function ()
        set_slot(slot.title)
        trash_slot()
        menu.goto(frames.slots)()
      end))
      table.insert(list, #list-1, menu.label(
        "Last played:\n" .. os.date("%X %a, %d %b %y", slot.time)
      ):set("style", menu.styles.light))
    end

    return menu.column(list)
  end end

  --- a slot in the trash
  function frames.trash_slot (slot) return function ()
    return menu.column {
      menu.label("Trash Slot > " .. slot.title),
      menu.label(""),
      menu.button("Return", menu.goto(frames.trash_slots)):set("style", menu.styles.primary),
      menu.button("Undiscard this slot", function ()
        set_slot(slot.title)
        untrash_slot()
        if #search_slots(true) == 0 then
          menu.goto(frames.slots)()
        else
          menu.goto(frames.trash_slots)()
        end
      end),

      menu.label(""),
      menu.label(
        "Last played:\n" .. (slot.time and os.date("%X %a, %d %b %y", slot.time) or " - ") 
      ):set("style", menu.styles.light),
    }
  end end

  --- the trash folder
  function frames.trash_slots ()
    local list = {
      menu.label("Slots in the trashbin"):set("style", menu.styles.header),
      menu.label("These slots will be auto-deleted on starting to play."),
      menu.label(""),
    }

    local trash_slots = search_slots(true)
    for i,slot in ipairs(trash_slots) do
      table.insert(list, menu.button(slot.title,
        menu.goto(frames.trash_slot(slot))))
    end

    table.insert(list, menu.label(""))
    table.insert(list, menu.button("Return", menu.goto(frames.slots)))

    return menu.column(list)
  end

  -- the slots overview
  function frames.slots () return menu.column {
      menu.label("Select a slot"):set("style", menu.styles.header),
      menu.label(""),
      menu.button("Return", menu.goto(frames.mainmenu))
    }:set("enter", function (self)

      local first = true
      local slots = search_slots(false)
      table.sort(slots, function (a,b) return a.time < b.time end)

      for i,slot in ipairs(slots) do
        table.insert(self, #self-1, menu.button(
          slot.title .. "\n" .. os.date("%X %a, %d %b %y", slot.time),
          menu.goto(frames.slot(slot))
        ):set("style", menu.styles.push))
      end

      table.insert(self, #self-1, menu.button("New slot", function ()
        menu.goto(frames.slot({title="Slot " .. (1+#slots)}))()
      end):set("style", menu.styles.push))

      self[2]:set("style", menu.styles.primary)

      local trash_slots = search_slots(true)
      if #trash_slots > 0 then
        table.insert(self, #self-1, menu.label(""))
        table.insert(self, #self-1,
          menu.button("Trash (" .. tostring(#trash_slots) .. " items)",
            menu.goto(frames.trash_slots)
          ):set("style", menu.styles.push)
        )
      end
    end)
  end

  local options = { fs="OFF", mvol=10, svol=10 }

  --- credits screen
  function frames.credits () return menu.column ({
    menu.label("Credits"):set("style", menu.styles.header),
    menu.label("Idea, some Music, Sounds, Graphics and Implementation"),
    menu.label("- David Richter"),
    menu.label("Tools"),
    menu.label("- Rosegarden, beepbox.co, Gimp, Tiled, Löve"),
    menu.label(""),
    menu.label("Musik"),
    menu.label("- Johannes Kühr"),
    menu.label("Tools"),
    menu.label("- Ludwig, Cubase"),
    menu.label(""),
    menu.button("Return", menu.goto(frames.mainmenu)),
    w = 400
  })
  end

  --- options menu
  function frames.options () return menu.column({
    menu.label("Options"):set("styles", menu.styles.header),
    menu.label(""),

    menu.label("Fullscreen"),
    menu.range("fs", {"OFF", "ON"})
      :set("change", function (self)
        local value = self.range[self.sel]

        love.window.setFullscreen(value=="ON", "desktop")

        w = value~="ON" and 800 or love.graphics.getWidth()
        h = value~="ON" and 400 or love.graphics.getHeight()

        self.parent.x = w/2 - self.parent.w/2

        menu.layout(self.parent)
      end),

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
    menu.button("Return", menu.goto(frames.mainmenu)),
  })
    :set("enter", function (self)
      local form = self:getForm()
      form.fs.sel = options.fs == "ON" and 2 or 1
      form.mvol.sel = options.mvol+1
      form.svol.sel = options.svol+1
    end)
    :set("exit", function (self)
      local form = self:getForm()
      options.fs = form.fs.range[form.fs.sel]
      options.mvol = form.mvol.range[form.mvol.sel]
      options.svol = form.svol.range[form.svol.sel]
    end)
  end

  --- main menu
  function frames.mainmenu () return menu.column {
    menu.label("Menu"):set("style", menu.styles.header),
    menu.label(""),
    menu.button("Play", menu.goto(frames.slots)):set("style", menu.styles.push):set("style", menu.styles.primary),
    menu.label(""),
    menu.button("Options", menu.goto(frames.options)):set("style", menu.styles.push),
    menu.button("Credits", menu.goto(frames.credits)):set("style", menu.styles.push),
    menu.label(""),
    menu.button("Quit", love.event.quit),
  } end

  audio.music "Xelda"
  change_app_state(frames.mainmenu())
end

app_state = {}
--- how to change the app_state
function change_app_state (new_state)
  if app_state and app_state.quit then app_state:quit() end
  app_state = new_state:load()

  for i,name in ipairs({
    "update", "keypressed", "keyreleased",
    "mousepressed", "mousereleased", "draw", "quit"
  }) do
    if app_state[name] then
      love[name] = function (...) app_state[name](app_state, ...) end
    else
      love[name] = nil
    end
  end
end


