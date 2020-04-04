native          CreateUnit              takes player id, integer unitid, real x, real y, real face returns unit -- 2842


native BlzGetUnitMaxHP                             takes unit whichUnit returns integer -- 3904
native BlzSetUnitMaxHP                             takes unit whichUnit, integer hp returns nothing
native BlzGetUnitMaxMana                           takes unit whichUnit returns integer
native BlzSetUnitMaxMana                           takes unit whichUnit, integer mana returns nothing

native BlzGetUnitArmor                             takes unit whichUnit returns real -- 3952
native BlzSetUnitArmor                             takes unit whichUnit, real armorAmount returns nothing

native BlzSetUnitRealField                         takes unit whichUnit, unitrealfield whichField, real value returns boolean -- 4142


native BlzChangeMinimapTerrainTex                  takes string texFile returns boolean