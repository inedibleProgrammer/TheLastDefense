TestManager = {}

local this = TestManager


function this.Test_Points()
  local point1 = Utility.Point.Create(1, 2)

  BJDebugMsg("(" .. point1.x .. "," .. point1.y ..")")
end


local TestUnitList = 
{
  "hpea",
  "hfoo",
}

function this.Test_Units()
  BJDebugMsg(math.random(1, #TestUnitList))
end