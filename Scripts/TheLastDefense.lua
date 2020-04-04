--[[ This module handles game specific logic ]]

TheLastDefense = {}

local this = TheLastDefense

this.gameParameters = {}
this.gameParameters.spawnPeriod = 10 -- Seconds
this.gameParameters.burstPeriod = 30 -- Seconds
this.gameParameters.upgradePeriod = 180 -- Seconds
this.gameParameters.healthMultiplier = 100 -- HP, Are there units with less than this * level?
this.gameParameters.level = 1 -- Scale monster spawning
this.gameParameters.upgradesFinished = false
this.gameParameters.unitSteroidEnabled = false -- Start adding HP to units
this.gameParameters.unitSteroidCounter = 1 -- Add 100 * this counter HP to units

this.multiboard = nil

function this.Init()
  --[[ Initialize Timer: ]]
  this.clockTrigger = CreateTrigger()
  TriggerAddAction(this.clockTrigger, this.TheLastDefenseHandler)
  TriggerRegisterTimerEvent(this.clockTrigger, 1.00, true)

  -- Assign abominations their targets
  this.InitializeAbominations()

  -- Get a multiboard:
  this.multiboard = MultiboardManager.GetBoard("MyFirstBoard", 1, 1) 
end

-- This should be turned into a state machine.
function this.TheLastDefenseHandler()
  local currentElapsedSeconds = GameClock.GetElapsedSeconds()

  -- Initialize the multiboard:
  if( (ModuloInteger(currentElapsedSeconds, 5) == 0) and not(this.multiboard.initialized) ) then
    print("Creating Board")
    
    this.multiboard.Initialize()
    this.multiboard.Display(true)

    this.multiboard.SetItem(0, 0, "Test")

    
  end

  if(ModuloInteger(currentElapsedSeconds, this.gameParameters.upgradePeriod) == 0) then
    this.gameParameters.level = this.gameParameters.level + 1

    if(this.gameParameters.unitSteroidEnabled) then
      this.gameParameters.unitSteroidCounter = this.gameParameters.unitSteroidCounter + 1
    end
  end

  if(ModuloInteger(currentElapsedSeconds, this.gameParameters.spawnPeriod) == 0) then
    AbominationManager.AbominationSpawn(this.gameParameters)
  end

  if(ModuloInteger(currentElapsedSeconds, this.gameParameters.burstPeriod) == 0) then
    AbominationManager.AbominationSpawn(this.gameParameters)
    AbominationManager.AbominationSpawn(this.gameParameters)
    AbominationManager.AbominationSpawn(this.gameParameters)
  end

  -- After a certain point, we should ramp up the difficulty:
  if( (this.gameParameters.level == 5) and not(this.gameParameters.upgradesFinished) ) then
    this.gameParameters.healthMultiplier = 200
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


function this.InitializeAbominations()
  --[[ For every player in the game, there needs to be an abomination targeting that player ]]
  for k,v in ipairs(DefenderManager.DefenderList) do
    AbominationManager.AbominationList[k].active = true
    AbominationManager.AbominationList[k].objectivePoint = v.startingPoint
    AbominationManager.AbominationList[k].targetPlayer = v.player
  end
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

function this.PrintGameParameters()
  print("P: " .. this.gameParameters.level .. ";" .. tostring(this.gameParameters.upgradesFinished) .. ";" .. tostring(this.gameParameters.unitSteroidEnabled) .. ";" .. this.gameParameters.unitSteroidCounter)
end

function this.InitializeMultiboard()
end