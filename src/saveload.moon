--- Saving and Loading
-- require $serialize, $map

persistence = require "state"
entities = require "entities"

-- read-write globals
export transient, avatar
-- read only globals
GAME_VERSION, love, pprint, w, h = GAME_VERSION, love, pprint, w, h

maps = require "map.maps"
scripting = require "map.scripting"
serialize = (require "serialize").serialize

--------------------------------------------------------------------------------

local sessionstart
INDENT = true

--------------------------------------------------------------------------------

_get_slots = (filter) ->
    local slots
    slots = {}
    love.filesystem.getDirectoryItems ".", (file) ->
        if file\sub(-5) == ".save"
            slot = assert(love.filesystem.load file)!
            if slot.meta.version == GAME_VERSION and filter slot
                table.insert slots, slot.meta

    table.sort slots, (a, b)-> a.lastsaved>b.lastsaved
    return slots

get_slots = -> _get_slots (slot) -> not slot.meta.trash
get_trash = -> _get_slots (slot) -> slot.meta.trash

clean_trash = ->
    for i, slot in ipairs get_trash!
        love.filesystem.remove slot.filename .. ".save"

--------------------------------------------------------------------------------

save = (slot, path) ->
    local now
    now = os.time!

    slot.meta.playtime = slot.meta.playtime + now - sessionstart
    slot.meta.lastsaved = now
    slot.meta.version = GAME_VERSION
    sessionstart = now

    scripting.hook "before_save"
    maps.exclude_avatar!
    assert love.filesystem.write path,
      "return " .. (serialize slot, nil, INDENT)
--    print "SAVED"
    maps.include_avatar!
    scripting.hook "after_save"


load = (slot) ->
    for k,v in pairs persistence
        persistence[k] = nil
    for k,v in pairs slot
        persistence[k] = v

    sessionstart = os.time!
    maps.init_level!
    scripting.hook "focus"  if topisgame

--------------------------------------------------------------------------------

make_slot = ->
    local n
    n = (#get_slots! + 1)
    return {
        filename: n
        slotname: "Slot " .. n
        playtime: 0
    }

--move_slot = (slot, newname) -> slot.meta.name = newname

save_slot = (slot) ->
    local realslot
    realslot = assert(love.filesystem.load slot.filename..".save")!
    realslot.meta = slot

    save realslot, slot.filename .. ".save"


load_slot = (slot) ->
    local realslot

    if slot.playtime == 0
      realslot = (require "scripts.main").create_new_game!
      realslot.meta = slot
      entities.decompress realslot.avatar

    else
      realslot = assert(love.filesystem.load slot.filename..".save")!

    load realslot
    return

--------------------------------------------------------------------------------

exists_auto = -> love.filesystem.exists "save.auto"
clear_auto  = -> love.filesystem.remove "save.auto"
autosave    = -> save persistence, "save.auto"

autoload    = ->
    load assert(love.filesystem.load "save.auto")!
    persistence.vars.kills = (persistence.vars.kills or 0) + 1
    autosave!

--------------------------------------------------------------------------------

{:exists_auto, :clear_auto, :autoload, :autosave,
:load_slot, :save_slot, :get_slots, :make_slot,
:get_trash, :clean_trash, :save}
