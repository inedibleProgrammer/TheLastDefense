TestManager = {}

local this = TestManager


function this.Test_Init()
  -- Tests you want to run immediately:
  this.PrintRuler()
  
  this.Test_ItemDescription()
  
end

function this.PrintRuler()
  DisplayTimedTextToPlayer(Player(0), 0.0, 0.5, 500, "01234567890123456789012345678901234567890123456789012345678")
end


function this.Test_HumanUnits()
  for k,v in ipairs(AllRacesUnitList) do
    CreateNUnitsAtLoc(1, FourCC(v), Player(0), GetRectCenter(GetPlayableMapRect()), bj_UNIT_FACING)
  end
end

function this.Test_ItemDescription()
  local i = CreateItem(FourCC("afac"), 0.0, 0.0)
  print(BlzGetItemDescription(i))
  RemoveItem(i)
  i = nil
end

