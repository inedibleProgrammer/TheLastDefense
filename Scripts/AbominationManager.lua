AbominationManager = {}

local this = AbominationManager

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
  this.upgradesFinished = false

  function this.SpawnRandomUnit(gameParameters)    
    local isHero = true
    local levelRestraint = true
    local badUnit = false
    local attemptCounter = 10

    -- if(gameParameters.level < 3) then -- Trying to help with lag
    --   attemptCounter = 0
    -- end

    -- Select a random unit that is not a hero, and meets the level restraint:
    while( ((isHero == true) or (levelRestraint == true) or (badUnit == true)) and (attemptCounter >= 0) ) do
      local r = GetRandomInt(1, #AllUnitList)
      local uID = AllUnitList[r]

      isHero = IsHeroUnitId(FourCC(AllUnitList[r]))
      levelRestraint = (GetFoodUsed(FourCC(uID)) > gameParameters.level)

      if(gameParameters.level < 1) then
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
          this.ApplyUnitModifications(u, gameParameters)
        end
      end

      attemptCounter = attemptCounter - 1
      u = nil
    end

    -- Make all the lazy monsters attack!
    local function IsIdle()
      local idleUnit = GetEnumUnit()
      if( not(GetUnitCurrentOrder(idleUnit) == 851983) and (idleUnit ~= gameParameters.finalBoss) ) then
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

  function this.ApplyUnitModifications(relevantUnit, gameParameters)
    SetUnitCreepGuard(relevantUnit, false)
    RemoveGuardPosition(relevantUnit)

    if(gameParameters.unitSteroidEnabled) then
      local currentHP = BlzGetUnitMaxHP(relevantUnit)
      currentHP = currentHP + (100 * gameParameters.unitSteroidCounter)
      BlzSetUnitMaxHP(relevantUnit, currentHP)
      SetUnitLifePercentBJ(relevantUnit, 100.0)
    end
  end

  return this
end
-- End Abomination

function this.Init()
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

  -- This function is useful for debugging.
function this.PrintAbominationNames()
  for k,v in ipairs(this.AbominationList) do 
    if(v.active) then
      print("Abomination: " .. v.name .. ";" .. v.objectivePoint.x .. ";" .. v.objectivePoint.y .. ";" .. GetPlayerId(v.targetPlayer))
    end
  end
end

function this.AbominationSpawn(gameParameters)
  for k,v in ipairs(this.AbominationList) do
    if(v.active) then
      v.SpawnRandomUnit(gameParameters)
    end
  end
end




