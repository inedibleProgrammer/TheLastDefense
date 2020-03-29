AbominationManager = {}

local this = AbominationManager
this.spawnPeriod = 5 -- Seconds
this.upgradePeriod = 300 -- Seconds
this.AbominationList = {}

-- Definition of Abomination:
local Abomination = {}

function Abomination.Create(name, player, spawnPoint)
  local this = {}
  this.name = name
  this.player = player
  this.spawnPoint = spawnPoint
  this.objectivePoint = Utility.Point.Create(0.0, 0.0)
  this.active = false
  this.unit = nil

  function this.SpawnRandomUnit()
    -- Select a random unit that is not a hero
    local isHero = true

    while(isHero == true) do
      local r = GetRandomInt(1, #AllRacesUnitList)

      local u = CreateUnit(this.player, FourCC(AllRacesUnitList[r]), this.spawnPoint.x, this.spawnPoint.y, 0.0)
      IssuePointOrder(u, "attackground", this.objectivePoint.x, this.objectivePoint.y)

      if(IsHeroUnitId(GetUnitTypeId(u))) then
        RemoveUnit(u)
      else
        isHero = false
      end
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
  this.firstAbomination = Abomination.Create("FirstAbomination", Player(10), firstAbominationSpawnPoint)

  -- Second Abomination:
  local secondAbominationSpawnPoint = Utility.Point.Create(-5779.8, 5775.5)
  this.secondAbomination = Abomination.Create("SecondAbomination", Player(14), secondAbominationSpawnPoint)

  -- Third Abomination:
  local thirdAbominationSpawnPoint = Utility.Point.Create(-4099.6, 5800.0)
  this.thirdAbomination = Abomination.Create("ThirdAbomination", Player(18), thirdAbominationSpawnPoint)

  -- Fourth Abomination:
  local fourthAbominationSpawnPoint = Utility.Point.Create(-2716.0, 5304.5)
  this.fourthAbomination = Abomination.Create("FourthAbomination", Player(22), fourthAbominationSpawnPoint)

  -- Add Abominations to the list:
  table.insert(this.AbominationList, this.firstAbomination)
  table.insert(this.AbominationList, this.secondAbomination)
  table.insert(this.AbominationList, this.thirdAbomination)
  table.insert(this.AbominationList, this.fourthAbomination)
end

function this.AbominationHandler()
  local currentElapsedSeconds = GameClock.GetElapsedSeconds()

  this.AbominationSpawn()
end

  -- This function is useful for debugging.
function this.PrintAbominationNames()
  for k,v in ipairs(this.AbominationList) do 
    if(v.active) then
      print("Abomination: " .. v.name .. " " .. v.objectivePoint.x .. " " .. v.objectivePoint.y)
    end
  end
end

function this.AbominationSpawn()
  for k,v in ipairs(this.AbominationList) do
    if(v.active) then
      if(ModuloInteger(GameClock.GetElapsedSeconds(), 5) == 0) then
        v.SpawnRandomUnit()
      end
    end
  end
end