--- Saving and Loading
-- require $serialize, $map

export persistence, transient, avatar, now

serialize = require "serialize"
change_level = require "map.maps"
scripting = require "map.scripting"
quote = (require "serialize").quote
serialize = (require "serialize").serialize

-- globals
GAME_VERSION, love, pprint, w, h = GAME_VERSION, love, pprint, w, h

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
    scripting.hooks.unload!

    now = os.time!
    slot.playtime  = slot.playtime + now - sessionstart
    slot.lastsaved = now
    slot.version = GAME_VERSION
    sessionstart = now

    -- TODO move this to map.maps
    -- pull avatar,
    -- remove REMOVED for real
    slot.avatar = avatar
    pool = slot[slot.mapname].pool
    for i=#pool,1,-1 do
        o = pool[i]
        if o == avatar
            table.remove pool, i

        elseif o.type == "REMOVED"
            table.remove pool, i


    assert love.filesystem.write place,
        "return " .. (serialize slot, nil, indent)
    print "SAVED"


    -- TODO move this to map.maps
    -- plug avatar
    slot.avatar = nil
    table.insert pool, avatar
    scripting.hooks.load!


--- 
save_slot = (slot) ->
    save slot, slot.filename .. ".save"


--- slot is either nil, a filename, or a table
load_slot = (slot) ->
    transient = nil

    if "nil" == type slot
        scripted = require "scripts.main"
        persistence = scripted.create_new_game!
        local slots
        slots = get_slots!
        persistence.filename = #slots + 1
        persistence.slotname = "Slot " .. (#slots + 1)
        persistence.playtime = 0
        print "\nNEW GAME"

    elseif "string" == type slot
    --    persistence = assert(love.filesystem.load(slot .. ".save"))!
        error "\nLOADED " .. (persistence.slotname)

    else
        persistence = slot
        print "\nOPENED " .. (slot.slotname)

    -- start session, pull avatar
    sessionstart = os.time!
    avatar = persistence.avatar

    -- open level
    change_level persistence.mapname


--- 
autosave = () ->
    save persistence, "save.auto"


--- 
autoload = () ->
    transient = nil
    persistence = assert(love.filesystem.load "save.auto")!

    -- start session, pull avatar
  --  sessionstart = os.time()
    avatar = persistence.avatar
  --  persistence.vars.kills = persistence.vars.kills + 1

    -- open level
    change_level persistence.mapname


--- 
move_slot = (slot, newname) ->
    slot.name = newname


--- 
clean_trash = () ->
    for i, slot in ipairs get_trash! do
        love.filesystem.remove slot.filename .. ".save"


{:autoload, :autosave, :load_slot, :save_slot,
:get_slots, :get_trash, :move_slot, :clean_trash}
