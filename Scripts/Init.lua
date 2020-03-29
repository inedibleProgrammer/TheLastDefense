--[[
  The beginning of everything
]]

function Init()
  print("Init Start")

  print("GameClockInit Start")
  xpcall(GameClock.Init, print)
  print("GameClockInit End")

  print("CommandManagerInit Start")
  xpcall(CommandManager.Init, print)
  print("CommandManagerInit End")

  print("UnitList_Init start")
  xpcall(UnitList_Init, print)
  print("UnitList_Init end")

  -- print("TestManager TestHumanUnits start")
  -- xpcall(TestManager.Test_HumanUnits, print)
  -- print("TestManager TestHumanUnits end")

  print("AbominationManagerInit start")
  xpcall(AbominationManager.Init, print)
  print("AbominationManagerInit end")

  print("Init End")
end
