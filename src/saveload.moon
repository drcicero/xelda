--- Saving and Loading
-- require $serialize, $map

export persistence, transient, avatar
-- read only globals
GAME_VERSION, love, pprint, w, h = GAME_VERSION, love, pprint, w, h

maps = require "map.maps"
scripting = require "map.scripting"
serialize = (require "serialize").serialize


local sessionstart
indent = true

---
get_slots_ = (filter) ->
    slots = {}
    love.filesystem.getDirectoryItems ".", (file) ->
        if file\sub(-5) == ".save"
            slot = assert(love.filesystem.load file)!
            if slot.version == GAME_VERSION and filter slot
                table.insert slots, slot

    table.sort slots, (a, b)-> a.lastsaved > b.lastsaved
    slots


--- returns slots
get_slots = () -> get_slots_ (slot)-> slot.trash == nil
--- returns trashed slots
get_trash = () -> get_slots_ (slot)-> slot.trash


save = (slot, place) ->
    local now
    now = os.time!

    slot.playtime  = slot.playtime + now - sessionstart
    slot.lastsaved = now
    slot.version = GAME_VERSION
    sessionstart = now

    scripting.hook "before_save"
    print("return " .. (serialize slot, nil, indent))
    maps.compress!
    assert love.filesystem.write place,
        "return " .. (serialize slot, nil, indent)
    print "SAVED"
    maps.decompress!
    scripting.hook "after_save"


--- 
save_slot = (slot) ->
    save slot, slot.filename .. ".save"


--- slot is either nil, a filename, or a table
load_slot = (slot) ->
    if nil == slot
        print "\nNEW GAME"
        persistence = (require "scripts.main").create_new_game!

        local num_slots
        num_slots = #get_slots!

        persistence.filename = num_slots + 1
        persistence.slotname = "Slot " .. (num_slots + 1)
        persistence.playtime = 0

    else
        print "\nLOAD " .. (slot.slotname)
        persistence = slot

    sessionstart = os.time!
    maps.open_level persistence.mapname

    scripting.hook "focus"  if topisgame


--- 
autosave = ->
--    save persistence, "save.auto"

--- 
autoload = ->
    persistence = assert(love.filesystem.load "save.auto")!
    persistence.vars.kills = (persistence.vars.kills or 0) + 1
    maps.open_level persistence.mapname

    scripting.hook "focus"  if topisgame


--- 
move_slot = (slot, newname) ->
    slot.name = newname


--- 
clean_trash = () ->
    for i, slot in ipairs get_trash! do
        love.filesystem.remove slot.filename .. ".save"


{:autoload, :autosave, :load_slot, :save_slot,
:get_slots, :get_trash, :move_slot, :clean_trash}
