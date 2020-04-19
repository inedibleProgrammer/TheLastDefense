--[[ The beginning of everything ]]

function Init()
  xpcall(CommandManager.Init("-c"), print)

  xpcall(ColorManager.Init, print)

  xpcall(GameClock.Init, print)

  xpcall(PlayerManager.Init, print)

  xpcall(TheLastDefense.Init, print)
end