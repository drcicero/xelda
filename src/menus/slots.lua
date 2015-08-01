local cron = require "cron"
local menu = require "menu"
local audio = require "audio"

local saveload = require "saveload"
local persistence = require "state"

local maps = require "map.maps"

local options = require "menus.options"
local credits = require "menus.credits"

local M = {}

local slots

--- the slots overview
-- slots / trash
function M.slots () 
  local result = menu.column {
    name="menu/slots",
    bg = {0,0,0,255},
    fill = {0,0,0,150}, pad = 30,
    x=50, y=200, w=200,
    noanim=true,

    title_oy = 0,
    title_a = 0,
  }
  result:layout()

  local introstep = 0
  local title = "Xelda"
  local introclock = cron.new_clock()
  audio.music("Xelda", "default")
  introclock.add { dur=2, f=cron.to(result.bg, 4, 150)}
  introclock.add { dur=1, f=cron.by(result, "title_oy", -1)}
  introclock.add { dur=1, f=cron.to(result, "title_a", 255)}


  result.focus = function (self)
    for i = #self,1,-1 do
      self[i].parent = nil
      self[i] = nil
    end

    slots = saveload.get_slots()
    if saveload.exists_auto() then
      table.insert(self, menu.label("Oops, i found a autosave."))
      table.insert(self, menu.label("This probably means the game crashed the last time, sorry."))
      table.insert(self, menu.label("Do you want to try to load it?"))
      table.insert(self, menu.label(""))
      table.insert(self, menu.button("Load autosave", menu.pop):set("type", "primary"))
      table.insert(self, menu.button("Discard autosave", function ()
        saveload.clear_auto()
        self:focus()
      end):set("type", "pop"))

      saveload.autoload()
      self:layout()
      self:resize()

      self.update = function (self)
        return menu.column.update(self)
      end

      return
    end

    self.update = function (self)
      introclock.update()

      local slot = slots[self.selector]
      if slot ~= nil
      and persistence.meta.slotname ~= slot.slotname then
        saveload.load_slot(slot)
      elseif slot == nil
      and persistence.meta.playtime ~= 0 then
        saveload.load_slot(saveload.make_slot())
      end

      return menu.column.update(self)
    end

    saveload.load_slot(slots[1] or saveload.make_slot())
    for i,slot in ipairs(slots) do
      table.insert(self, menu.button(slot.slotname,
        menu.push(M.slot(slot)) ):set("type", "push"))
    end
    table.insert(self, menu.button("New slot",
      menu.push(M.slot(persistence.meta)) ):set("type", "push"))
    if #self >= 1 then
      self[1]:set("type", "primary")
    end

    local trash_slots = saveload.get_trash()
    if #trash_slots > 0 then
      table.insert(self, menu.label(""))
      table.insert(self,
        menu.button("Trash (" .. tostring(#trash_slots) .. " items)",
          menu.push(M.trash_slots) ):set("type", "push")
      )
    end

    table.insert(self, menu.label(""))
    table.insert(self,
      menu.button("Options", menu.push(options) ))
    table.insert(self,
      menu.button("Credits", menu.push(credits) ))
    table.insert(self, menu.button("Quit",
      love.event.quit))

    self:layout()
  end
  result:focus()

  result.load = function (self)
    menu.column.load(self)
    self.noanim = nil
  end

  the_title_png = love.graphics.newImage("assets/title.png")
  result.draw = function (self)
    menu.column.draw(self)

    love.graphics.setColor(255,255,255, self.title_a * self.alpha)
    local wz = math.min(w/1024, h/700)
    love.graphics.draw(the_title_png, w/2, 10 - self.title_oy*h/20,
      0, wz, wz, the_title_png:getWidth()/2)

    love.graphics.setColor(255,255,255,127)
    love.graphics.setFont(font)
    love.graphics.print("Version " .. GAME_VERSION, w-120, h-20)
  end

  result.resize = function (self)
    self.y = h-self.h
  end

  print ("were here")
  return result
end


--- slot: play / discard / display metadata
function M.slot (slot) return function ()
  local list = menu.column {
    name="mainmenu/slot",
    bg = {0,0,0,150}, fill = {0,0,0,150}, pad = 30,
    x=50, y=200, w=300,

    menu.input("slotname", slot.slotname)
      :set("type", "header")
      :set("change", function (self)
--        if love.filesystem.exists(self.title .. ".save") then
--          print("This name already exists.")
--          self.title = slot.slotname
--          self.parent:layout()

--        else
        if self.title == "" then
          self.title = slot.slotname
          self.parent:layout()

          menu.push(menu.column(
            menu.label("Empty name is not valid."),
            menu.button("Ok", menu.pop):set("type", "pop")))()

        else
          slot.slotname = self.title
          if slot.playtime ~= 0 then
            saveload.save_slot(slot)
          else
            persistence.meta.slotname = self.title
          end
        end
      end),

    menu.label(""),
    menu.label(""),
    menu.button("Return", function (a,b) menu.pop(a,b) end)
      :set("type", "pop"),
  }

  list.enter = function (self) self.selector=2 end

  local trash = slot.trash
  if not trash then
    table.insert(list, 3, menu.button(slot.playtime == 0 and "Begin" or "Continue", function ()
      saveload.autosave()
      saveload.clean_trash()
      menu.pop(nil, nil, function () menu.pop(nil, nil, nil, 1) end)
    end):set("type", "primary"))
  end

  if slot.playtime ~= 0 then
    if not trash then
      table.insert(list, 4, menu.button("Discard", function ()
        slot.trash = true
        saveload.save_slot(slot)
        menu.pop()
      end))

    else
      table.insert(list, 4, menu.button("Undiscard", function ()
        slot.trash = nil
        saveload.save_slot(slot)
        menu.pop(nil, nil, #saveload.get_trash() == 0 and menu.pop or nil)
      end))
    end

    table.insert(list, menu.label(
      "Last save:\n" .. os.date("%X %a, %d %b %y", slot.lastsaved))
      :set("type", "light"))
    table.insert(list, menu.label(
      "Playtime: " .. time(slot.playtime or 0))
      :set("type", "light"))
  end

  list.resize = function (self)
    self.x = w/2 - self.w/2
    self.y = h/2 - self.h/2
  end

  return list
end end

function time (time)
  local h = math.floor(time / (60*60))
  local m = math.floor((time-h*60*60) / 60) 
  local s = math.floor(time-h*60*60-m*60)
  return (h~=0 and h.."h " or "")
       ..(m~=0 and m.."m " or "")
       ..(s~=0 and s.."s" or "0s")
end


--- trashed slots
function M.trash_slots ()
  local list = {
    name = "mainmenu/trashslots",
    bg = {0,0,0,150}, fill = {0,0,0,150}, pad = 30,
    x=150, y=200, w=200,

    menu.label("Slottrash"):set("type", "header"),
    menu.label("These slots will be auto-deleted on starting to play."),
    menu.label(""),
    name="mainmenu/trash",
  }

  local trash_slots = saveload.get_trash(true)
  for i,slot in ipairs(trash_slots) do
    table.insert(list, menu.button(slot.slotname,
      menu.push(M.slot(slot))))
  end

  table.insert(list, menu.label(""))
  table.insert(list, menu.button("Return", menu.pop)
    :set("type", "pop"))

  list = menu.column(list)

  list.update = function (self)
    local slot = trash_slots[self.selector - 3]
    if slot ~= nil and persistence.meta.slotname ~= slot.slotname
    or slot == nil and persistence.meta.playtime ~= 0 then
      saveload.load_slot(slot)
    end

    return menu.column.update(self)
  end

  list.resize = function (self)
    self.y = h-self.h
  end

  return list
end

return M
