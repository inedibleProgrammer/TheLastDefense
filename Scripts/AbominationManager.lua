AbominationManager = {}
local this = AbominationManager

-- this.gameParameters = {} -- No longer necessary
this.nSpawnCount = 1 -- Number of units to spawn each spawn tick
this.spawnPeriod = 10 -- Seconds
this.burstPeriod = 30 -- Seconds
this.upgradePeriod = 300 -- Seconds
this.level = 0 -- Scale monster spawning
this.upgradesFinished = false
this.unitSteroidEnabled = false -- Start adding HP to units
this.unitSteroidCounter = 1 -- Add 100 * this counter HP to units

this.finalBoss = {}

-- List of abominations:
this.AbominationList = {}

--[[ Definition of an Abomination: ]]
Abomination = {}
function Abomination.Create(name, player, targetPlayer, spawnPoint)
  local this = {}
  this.name = name
  this.player = player -- The actual Player() of the abomination
  this.spawnPoint = spawnPoint
  this.targetPlayer = targetPlayer -- The player to be targeted by the abomination.
  this.objectivePoint = Utility.Point.Create(0.0, 0.0)
  this.active = false

  function this.SpawnRandomUnit()
    local isHero = true
    local levelRestraint = true
    local badUnit = false
    local attemptCounter = 100

    -- Select a random unit that is not a hero, and meets the level restraint:
    while( ((isHero == true) or (levelRestraint == true) or (badUnit == true)) and (attemptCounter >= 0) ) do
      local r = GetRandomInt(1, #AllUnitList)
      local uID = AllUnitList[r]

      isHero = IsHeroUnitId(FourCC(AllUnitList[r]))
      levelRestraint = (GetFoodUsed(FourCC(uID)) > AbominationManager.level)

      if(AbominationManager.level < 1) then
        if(uID == "obai" -- Baine
        or uID == "nmed" -- Medivh
        or uID == "hcth" -- Captain
        or uID == "uktn") -- Kel'Thuzad
        then
          badUnit = true
        end
      end

      if(uID == "nspc") then -- Support column
        badUnit = true
      end

      if(isHero or levelRestraint) then
        -- Do nothing
      else
        if(badUnit) then
          -- Do nothing
        else
          local u = CreateUnit(this.player, FourCC(AllUnitList[r]), this.spawnPoint.x, this.spawnPoint.y, 0.0)
          this.ApplyUnitModifications(u)
        end
      end

      attemptCounter = attemptCounter - 1
      u = nil
    end

    -- Make all the lazy monsters attack!
    local function IsIdle()
      local idleUnit = GetEnumUnit()
      if( (GetUnitCurrentOrder(idleUnit) ~= 851983) and (idleUnit ~= AbominationManager.finalBoss.u) ) then -- TODO: can this be a condition?
        Utility.AttackRandomUnitOfPlayer(idleUnit, this.targetPlayer)
      end
      idleUnit = nil
    end

    local g = CreateGroup()
    GroupEnumUnitsOfPlayer(g, this.player, nil)
    ForGroup(g, IsIdle)
    DestroyGroup(g)
    g = nil
  end

  function this.ApplyUnitModifications(relevantUnit)
    SetUnitCreepGuard(relevantUnit, false)
    RemoveGuardPosition(relevantUnit)
    SetUnitColor(relevantUnit, PLAYER_COLOR_COAL) -- Or should I change the colors of the AI players?

    if(AbominationManager.unitSteroidEnabled) then
      local currentHP = BlzGetUnitMaxHP(relevantUnit)
      currentHP = currentHP + (100 * AbominationManager.unitSteroidCounter)
      BlzSetUnitMaxHP(relevantUnit, currentHP)
      SetUnitLifePercentBJ(relevantUnit, 100.0)
    end
  end

  return this
end

--[[ End Definition of an Abomination ]]

function this.Init()
  --[[ Create the Abominations: ]]
  this.InitializeAbominations()

  --[[ For every player in the game, there needs to be an abomination targeting that player ]]
  for k,v in ipairs(DefenderManager.DefenderList) do
    AbominationManager.AbominationList[k].active = true
    AbominationManager.AbominationList[k].objectivePoint = v.startingPoint
    AbominationManager.AbominationList[k].targetPlayer = v.player
  end

  -- Wormwood
  this.InitializeFinalBoss()

  --[[ Add Commands: ]]
  local function GameParameters()
    local parameters = "P"
    parameters = parameters .. ";" .. this.level
    parameters = parameters .. ";" .. tostring(this.upgradesFinished)
    parameters = parameters .. ";" .. tostring(this.unitSteroidEnabled)
    parameters = parameters .. ";" .. this.unitSteroidCounter
    parameters = parameters .. ";"
    print(parameters)
  end
  CommandManager.AddCommand("parameters", GameParameters)
end

function this.InitializeAbominations()
  -- Abominations have fixed starting locations, so hard-code their spawn points.

  -- First Abomination:
  local firstAbominationSpawnPoint = Utility.Point.Create(-4972.4, 4902.7)
  this.firstAbomination = Abomination.Create("FirstAbomination", Player(10), Player(0), firstAbominationSpawnPoint) -- Player(0) is temporary and will be overwritten.

  -- Second Abomination:
  local secondAbominationSpawnPoint = Utility.Point.Create(-5779.8, 5775.5)
  this.secondAbomination = Abomination.Create("SecondAbomination", Player(14), Player(0), secondAbominationSpawnPoint)

  -- Third Abomination:
  local thirdAbominationSpawnPoint = Utility.Point.Create(-4099.6, 5800.0)
  this.thirdAbomination = Abomination.Create("ThirdAbomination", Player(18), Player(0), thirdAbominationSpawnPoint)

  -- Fourth Abomination:
  local fourthAbominationSpawnPoint = Utility.Point.Create(-2716.0, 5304.5)
  this.fourthAbomination = Abomination.Create("FourthAbomination", Player(22), Player(0), fourthAbominationSpawnPoint)

  -- Add Abominations to the list:
  table.insert(this.AbominationList, this.firstAbomination)
  table.insert(this.AbominationList, this.secondAbomination)
  table.insert(this.AbominationList, this.thirdAbomination)
  table.insert(this.AbominationList, this.fourthAbomination)

  --[[ For every player in the game, there needs to be an abomination targeting that player ]]
  for k,v in ipairs(DefenderManager.DefenderList) do
    this.AbominationList[k].active = true
    this.AbominationList[k].objectivePoint = v.startingPoint
    this.AbominationList[k].targetPlayer = v.player
  end

  -- Remove Abomination Starting Units:
  for k,v in ipairs(this.AbominationList) do
    local function RemoveAbominableUnit()
      local u = GetEnumUnit()
      RemoveUnit(u)
      u = nil
    end

    local g = CreateGroup()
    GroupEnumUnitsOfPlayer(g, v.player, nil)
    ForGroup(g, RemoveAbominableUnit)
    DestroyGroup(g)
    g = nil
  end
end

function this.InitializeFinalBoss()
  this.finalBoss.point = Utility.Point.Create(-4592.5, 5275.7)
  this.finalBoss.u = CreateUnit(Player(10), FourCC("nbal"), this.finalBoss.point.x, this.finalBoss.point.y, 270.0)

  --[[ Add some legit modifications ]]
  -- Name:
  BlzSetUnitName(this.finalBoss.u, "Wormwood")

  -- Health:
  BlzSetUnitMaxHP(this.finalBoss.u, 100000)
  SetUnitLifePercentBJ(this.finalBoss.u, 100.0)

  -- HP Regen
  BlzSetUnitRealField(this.finalBoss.u, UNIT_RF_HIT_POINTS_REGENERATION_RATE, 100)

  -- Damage
  BlzSetUnitBaseDamage(this.finalBoss.u, 500, 0) -- Ground
  BlzSetUnitBaseDamage(this.finalBoss.u, 500, 1) -- Air

  -- Armor
  BlzSetUnitArmor(this.finalBoss.u, 150)

  -- Size, color, tint
  SetUnitScale(this.finalBoss.u, 2.0, 0.0, 0.0)
  SetUnitColor(this.finalBoss.u, PLAYER_COLOR_COAL)
  SetUnitVertexColor(this.finalBoss.u, 100, 100, 100, 255)
end

function this.AbominationSpawn()
  for k,v in ipairs(this.AbominationList) do
    if(v.active) then
      v.SpawnRandomUnit()
    end
  end
end

function this.DoUpgrades()
  this.upgradesFinished = true

  for _,abom in ipairs(this.AbominationList) do
    for _,upg in ipairs(AllRacesUpgradeList) do
      AddPlayerTechResearched(abom.player, FourCC(upg), 3)
    end
  end
end

function this.UpdateAbominationTargets()
  for k,v in ipairs(this.AbominationList) do
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

--[[ The Main Process: ]]
function this.Process()
  local currentElapsedSeconds = GameClock.GetElapsedSeconds()

  if(ModuloInteger(currentElapsedSeconds, this.upgradePeriod) == 0) then
    this.level = this.level + 1

    if(this.unitSteroidEnabled) then
      this.unitSteroidCounter = this.unitSteroidCounter + 1
    end
  end

  if(ModuloInteger(currentElapsedSeconds, this.burstPeriod) == 0) then
    this.nSpawnCount = 5
  else
    this.nSpawnCount = 1
  end

  if(ModuloInteger(currentElapsedSeconds, this.spawnPeriod) == 0) then
    for i=1, this.nSpawnCount do
      this.AbominationSpawn()
    end
  end

  -- After a certain point, we should ramp up the difficulty:
  if( (this.level == 5) and not(this.upgradesFinished) ) then
    this.DoUpgrades()
  end

  -- Time to apply steroids?
  if( this.level == 7 and not(this.unitSteroidEnabled) ) then
    this.unitSteroidEnabled = true
  end

  -- give the respective abomination of a dead defender a new living target defender
  this.UpdateAbominationTargets()
end