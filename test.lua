require "saveload"

--fresh = {1,2,3,4,x=1,y=2,type="meta",properites={text="Hallo, Welt!"}}
--changed = {1,2,9,8,7,6,x=3,y=2,properites={text="Hallo, Welt!"}}
--d = delta(fresh, changed)

--print( serialize(fresh), serialize(d), serialize(patch(fresh, d)), serialize(changed) )


print()

fresh = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20}
changed = {1,2,9,8,7,6,x=3,y=2,properites={text="Hallo, Welt!"}}
d = delta(fresh, changed)

print( "fresh", serialize(fresh), "d", serialize(d), "patched", serialize(patch(fresh, d)), "changed", serialize(changed) )

