require "menu"

local M = {}

local slots

--- the slots overview
-- slots / trash
function M.slots () 
  local result = menu.column {
    menu.label("Select a slot"):set("style", menu.styles.header),
    menu.label(""),
    menu.button("Quit", love.event.quit),

    bg = {0,0,0,100}, fill = {0,0,0,100}, pad = 10,
    x=50, w=200
  }:set("enter", function (self)

    local first = true
    slots = search_slots(false)
    load_slot(slots[1])

    for i,slot in ipairs(slots) do
      table.insert(self, #self-1, menu.button(
        slot.slotname,
        menu.goto(M.slot(slot))
      ):set("style", menu.styles.push))
    end

    table.insert(self, #self-1, menu.button("New slot", function ()
      menu.goto(M.slot({slotname="Slot " .. (1+#slots)}))()
    end):set("style", menu.styles.push))

    self[2]:set("style", menu.styles.primary)

    local trash_slots = search_slots(true)
    if #trash_slots > 0 then
      table.insert(self, #self-1, menu.label(""))
      table.insert(self, #self-1,
        menu.button("Trash (" .. tostring(#trash_slots) .. " items)",
          menu.goto(M.trash_slots)
        ):set("style", menu.styles.push)
      )
    end

    self:layout()
    self.y = h-self.h
  end)

  result.update = function (self)
    local selector = self.selector - 1
    local slot = slots[selector]
    if persistence ~= slot and
    not (slot == nil and persistence.lastsaved == nil) then
      load_slot(slot)
    end

    return menu.app.update(self)
  end

  return result
end


--- slot: play / discard / display metadata
function M.slot (slot) return function ()
  local list = {
    menu.label("Slot > " .. slot.slotname):set("style", menu.styles.header),

    menu.label(""),
    menu.button(slot.lastsaved and "Continue game" or "Begin game", function ()
      pop_app_state()
      clean_trash_slots()
    end):set("style", menu.styles.primary),

    menu.button("Return", menu.goto(M.slots))
      :set("style", menu.styles.pop),

    menu.label(""),
    menu.label("Slotname:"),
    menu.input("slotname", slot.slotname)
      :set("change", function (self)
        print("slot_name_change", slot.slotname, self.title)
        self.parent[1].title = "Slot > " .. self.title
        if slot.lastsaved then
          move_slot(slot.slotname, self.title)
          slot.slotname = self.title
          save_slot(slot)
        end
        slot.slotname = self.title
      end),

    bg = {0,0,0,100}, fill = {0,0,0,100}, pad = 10,
    x=250, w=200
  }

  if slot.lastsaved then
    table.insert(list, menu.label(
      "Last played:\n" .. os.date("%X %a, %d %b %y", slot.lastsaved)
    ):set("style", menu.styles.light))
    table.insert(list, menu.button("Discard this slot", function ()
      trash_slot(slot)
      menu.goto(M.slots)()
    end))
  end

  list = menu.column(list)
  list:layout()
  list.y = h-list.h
  return list
end end


--- trashed slots
function M.trash_slots ()
  local list = {
    menu.label("Slots in the trashbin"):set("style", menu.styles.header),
    menu.label("These slots will be auto-deleted on starting to play."),
    menu.label(""),
  }

  local trash_slots = search_slots(true)
  for i,slot in ipairs(trash_slots) do
    table.insert(list, menu.button(slot.slotname,
      menu.goto(M.trash_slot(slot))))
  end

  table.insert(list, menu.label(""))
  table.insert(list, menu.button("Return", menu.goto(M.slots))
    :set("style", menu.styles.pop))

  list = menu.column(list)

  list.update = function (self)
    local selector = self.selector - 3
    local slot = trash_slots[selector]
    if persistence ~= slot and
    not (slot == nil and persistence.lastsaved == nil) then
      load_slot(slot)
    end

    return menu.app.update(self)
  end

  return list
end


--- trashed slot: undiscard
function M.trash_slot (slot) return function ()
  return menu.column {
    menu.label("Trash Slot > " .. slot.slotname),
    menu.label(""),
    menu.button("Return", menu.goto(M.trash_slots))
      :set("style", menu.styles.primary)
      :set("style", menu.styles.pop),
    menu.button("Undiscard this slot", function ()
      untrash_slot(slot)
      if #search_slots(true) == 0 then
        menu.goto(M.slots)()
      else
        menu.goto(M.trash_slots)()
      end
    end),

    menu.label(""),
    menu.label(
      "Last played:\n" .. (slot.lastsaved and os.date("%X %a, %d %b %y", slot.lastsaved) or " - ") 
    ):set("style", menu.styles.light),
  }
end end

return M
