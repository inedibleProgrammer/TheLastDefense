AbominationManager = {}

local this = AbominationManager
this.spawnPeriod = 5 -- Seconds
this.upgradePeriod = 300 -- Seconds
this.healthMultiplier = 400 -- HP
this.level = 1 -- Scale monster spawning
this.AbominationList = {}

-- Definition of Abomination:
local Abomination = {}

function Abomination.Create(name, player, targetPlayer, spawnPoint)
  local this = {}
  this.name = name
  this.player = player -- The actual Player() of the abomination
  this.spawnPoint = spawnPoint
  this.targetPlayer = targetPlayer -- The player to be targeted by the abomination.
  this.objectivePoint = Utility.Point.Create(0.0, 0.0)
  this.active = false
  this.unit = nil
  -- this.unitGroup = CreateGroup()
  this.upgradesFinished = false

  function this.SpawnRandomUnit(level)
    local function IsIdle()
      local idleUnit = GetEnumUnit()
      if(not(GetUnitCurrentOrder(idleUnit) == 851983)) then
        Utility.AttackRandomUnitOfPlayer(idleUnit, this.targetPlayer)
        -- local g = CreateGroup()
        -- GroupEnumUnitsOfPlayer(g, this.targetPlayer, nil)
        -- local u = GroupPickRandomUnit(g)
        -- IssueTargetOrder(idleUnit, "attack", u)
        -- DestroyGroup(g)
        -- g = nil
      end
      idleUnit = nil
    end

    
    local isHero = true
    local levelRestraint = true
    local attemptCounter = 25

    -- Select a random unit that is not a hero, and meets the level restraint:
    while( ((isHero == true) or (levelRestraint == true)) and (attemptCounter >= 0) ) do
      local r = GetRandomInt(1, #AllUnitList)

      local u = CreateUnit(this.player, FourCC(AllUnitList[r]), this.spawnPoint.x, this.spawnPoint.y, 0.0)
      -- IssuePointOrder(u, "attack", this.objectivePoint.x, this.objectivePoint.y)
      -- GroupAddUnit(this.unitGroup, u)

      -- Conditions for an undesirable unit:
      isHero = IsHeroUnitId(GetUnitTypeId(u))
      levelRestraint = (BlzGetUnitMaxHP(u) > (level * AbominationManager.healthMultiplier))

      -- if(IsHeroUnitId(GetUnitTypeId(u))) then
      --   --RemoveUnit(u)
      --   isHero = true
      -- else
      --   isHero = false
      -- end

      -- if(BlzGetUnitMaxHP(u) > (level * AbominationManager.healthMultiplier)) then
      --   --RemoveUnit(u)
      --   levelRestraint = true
      -- else
      --   levelRestraint = false
      -- end

      
      -- If the unit is desirable, then it hasn't been removed and we should tell it to attack:
      if(levelRestraint or isHero) then
        RemoveUnit(u)
      else
        xpcall(Utility.AttackRandomUnitOfPlayer(u, this.targetPlayer), print)
      end

      attemptCounter = attemptCounter - 1
      u = nil
    end

    if( (level == 5) and not(this.upgradesFinished) ) then
      AbominationManager.healthMultiplier = 600
      this.DoUpgrades()
    end

    -- Make all the lazy monsters attack!
    local g = CreateGroup()
    GroupEnumUnitsOfPlayer(g, this.player, nil)
    ForGroup(g, IsIdle)
    DestroyGroup(g)
    g = nil
  end

  function this.DoUpgrades()
    this.upgradesFinished = true

    for k,v in ipairs(AllRacesUpgradeList) do
      AddPlayerTechResearched(this.player, FourCC(v), 3)
    end
  end

  return this
end
-- End Abomination

function this.Init()
  --[[ Initialize Timer: ]]
  this.clockTrigger = CreateTrigger()
  TriggerAddAction(this.clockTrigger, this.AbominationHandler)
  TriggerRegisterTimerEvent(this.clockTrigger, 1.00, true)

  --[[ Initialize Abominations: ]]
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

-- Main processing should be done here.
function this.AbominationHandler()
  local currentElapsedSeconds = GameClock.GetElapsedSeconds()

  if(ModuloInteger(currentElapsedSeconds, this.upgradePeriod) == 0) then
    this.level = this.level + 1
  end

  this.AbominationSpawn(this.level)

  -- if a defender has lost all his units, give the respective abomination a new target defender
end

  -- This function is useful for debugging.
function this.PrintAbominationNames()
  for k,v in ipairs(this.AbominationList) do 
    if(v.active) then
      print("Abomination: " .. v.name .. " " .. v.objectivePoint.x .. " " .. v.objectivePoint.y)
    end
  end
end

function this.AbominationSpawn(level)
  for k,v in ipairs(this.AbominationList) do
    if(v.active) then
      if(ModuloInteger(GameClock.GetElapsedSeconds(), 10) == 0) then
        v.SpawnRandomUnit(level)
      end
      if(ModuloInteger(GameClock.GetElapsedSeconds(), 30) == 0) then
        v.SpawnRandomUnit(level)
        v.SpawnRandomUnit(level)
        v.SpawnRandomUnit(level)
      end
    end
  end
end