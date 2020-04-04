--[[
  The beginning of everything
]]

function Init()
  print("Init Start")

  --print("loading minimap")
  xpcall(BlzChangeMinimapTerrainTex("war3mapImported\\castle.blp"), print)
  --print("end loading minimap")

  --print("GameClockInit Start")
  xpcall(GameClock.Init, print)
  --print("GameClockInit End")

  --print("CommandManagerInit Start")
  xpcall(CommandManager.Init, print)
  --print("CommandManagerInit End")

  --print("UnitList_Init start")
  xpcall(UnitList_Init, print)
  --print("UnitList_Init end")

  --print("UpgradeList_Init start")
  xpcall(UpgradeList_Init, print)
  --print("UpgradeList_Init end")

  --print("ItemList_Init start")
  xpcall(ItemList_Init, print)
  --print("ItemList_Init end")

  print("TestManager_Init start")
  xpcall(TestManager.Test_Init, print)
  print("TestManager_Init end")

  --print("AbominationManagerInit start")
  xpcall(AbominationManager.Init, print)
  --print("AbominationManagerInit end")

  --print("DefenderManagerInit start")
  xpcall(DefenderManager.Init, print)
  --print("DefenderManagerInit end")

  --print("MultiboardManagerInit start")
  xpcall(MultiboardManager.Init, print)
  --print("MultiboardManagerInit end")

  --print("TheLastDefenseInit start")
  xpcall(TheLastDefense.Init, print)
  --print("TheLastDefenseInit end")

  print("Init End")
end
