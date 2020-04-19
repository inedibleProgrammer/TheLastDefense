TheLastDefense = {}
local this = TheLastDefense

this.gameParameters = {}
this.gameParameters.nSpawnCount = 1 -- Number of units to spawn each spawn tick
this.gameParameters.spawnPeriod = 10 -- Seconds
this.gameParameters.nBurstCount = 4 -- Number of units to spawn each burst tick
this.gameParameters.burstPeriod = 30 -- Seconds
this.gameParameters.upgradePeriod = 300 -- Seconds
this.gameParameters.healthMultiplier = 100 -- HP, Are there units with less than this * level?
this.gameParameters.level = 0 -- Scale monster spawning
this.gameParameters.upgradesFinished = false
this.gameParameters.unitSteroidEnabled = false -- Start adding HP to units
this.gameParameters.unitSteroidCounter = 1 -- Add 100 * this counter HP to units
this.gameParameters.shopUpdatePeriod = 300 -- Seconds

function this.Init()
  ItemList_Init()

  UnitList_Init()

  UpgradeList_Init()

  xpcall(DefenderManager.Init, print)

  xpcall(AbominationManager.Init, print)

  --[[ Initialize Game Handler: ]]
  this.clockTrigger = CreateTrigger()
  TriggerAddAction(this.clockTrigger, this.GameHandler)
  TriggerRegisterTimerEvent(this.clockTrigger, 1.00, true)
  --[[ Add Commands: ]]
end


function this.GameHandler()
  local currentElapsedSeconds = GameClock.GetElapsedSeconds()

  if(ModuloInteger(currentElapsedSeconds, this.gameParameters.upgradePeriod) == 0) then
    this.gameParameters.level = this.gameParameters.level + 1

    if(this.gameParameters.unitSteroidEnabled) then
      this.gameParameters.unitSteroidCounter = this.gameParameters.unitSteroidCounter + 1
    end
  end

  if(ModuloInteger(currentElapsedSeconds, this.gameParameters.spawnPeriod) == 0) then
    for i=1, this.gameParameters.nSpawnCount do
      AbominationManager.AbominationSpawn(this.gameParameters)
    end
  end

  -- After a certain point, we should ramp up the difficulty:
  if( (this.gameParameters.level == 5) and not(this.gameParameters.upgradesFinished) ) then
    -- this.gameParameters.healthMultiplier = 200 Deprecated with new food system
    this.DoUpgrades()
  end

  -- Time to apply steroids?
  if( this.gameParameters.level == 7 and not(this.gameParameters.unitSteroidEnabled) ) then
    this.gameParameters.unitSteroidEnabled = true
  end
  
  -- if a defender has lost all his units he is dead
  this.DetermineLivingDefenders()

  -- give the respective abomination of a dead defender a new living target defender
  this.UpdateAbominationTargets()
end

function this.DoUpgrades()
  this.gameParameters.upgradesFinished = true

  for _,abom in ipairs(AbominationManager.AbominationList) do
    for _,upg in ipairs(AllRacesUpgradeList) do
      AddPlayerTechResearched(abom.player, FourCC(upg), 3)
    end
  end
end

function this.DetermineLivingDefenders()
  for k,v in ipairs(DefenderManager.DefenderList) do
    local unitsRemaining = GetPlayerUnitCount(v.player, true)
    if( v.alive and (unitsRemaining <= 0) ) then
      print("Player dead")
      v.alive = false
    end
  end
end

function this.UpdateAbominationTargets()
  for k,v in ipairs(AbominationManager.AbominationList) do
    local unitsRemaining = GetPlayerUnitCount(v.targetPlayer, true) -- Abominations don't have a reference to their defender. Only the player.
    if(unitsRemaining <= 0) then
      local randomInt = GetRandomInt(1, #DefenderManager.DefenderList)
      if(DefenderManager.DefenderList[randomInt].alive) then
        print("new target")
        v.targetPlayer = DefenderManager.DefenderList[randomInt].player
      end
    end
  end
end