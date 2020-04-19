TheLastDefense = {}
local this = TheLastDefense

function this.Init()
  xpcall(ItemList_Init, print)

  xpcall(UnitList_Init, print)

  xpcall(UpgradeList_Init, print)

  xpcall(DefenderManager.Init, print)

  xpcall(AbominationManager.Init, print)

  --[[ Initialize Game Handler: ]]
  this.clockTrigger = CreateTrigger()
  TriggerAddAction(this.clockTrigger, this.GameHandler)
  TriggerRegisterTimerEvent(this.clockTrigger, 1.00, true)
  --[[ Add Commands: ]]
end


function this.GameHandler()
  DefenderManager.Process()

  AbominationManager.Process()
end

