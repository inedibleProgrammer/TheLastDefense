TestManager = {}

local this = TestManager



function this.Test_HumanUnits()
  for k,v in ipairs(AllRacesUnitList) do
    CreateNUnitsAtLoc(1, FourCC(v), Player(0), GetRectCenter(GetPlayableMapRect()), bj_UNIT_FACING)
  end
end

-- CreateNUnitsAtLoc(1, FourCC(unit), Player(0), GetRectCenter(GetPlayableMapRect()), bj_UNIT_FACING)