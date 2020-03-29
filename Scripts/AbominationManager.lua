AbominationManager = {}

local this = AbominationManager
this.spawnPeriod = 5 -- Seconds
this.upgradePeriod = 300 -- Seconds

-- Definition of Abomination:
local Abomination = {}

function Abomination.Create()
  local this = {}

  function this.DetermineUnit()
    -- Select a random unit
  end


  return this
end
-- End Abomination

function this.Init()
  this.clockTrigger = CreateTrigger()
  TriggerAddAction(this.clockTrigger, this.AbominationHandler)
  TriggerRegisterTimerEvent(this.clockTrigger, 1.00, true)
end

function this.AbominationHandler()
  local currentElapsedSeconds = GameClock.GetElapsedSeconds()
  print(currentElapsedSeconds)
end