--[[
  The beginning of everything
]]

function Init()
  BJDebugMsg("Init Start")
  GameClock.Init()
  CommandManager.Init()
  TestManager.Test_Points()
  TestManager.Test_Units()
  BJDebugMsg("Init End")
end