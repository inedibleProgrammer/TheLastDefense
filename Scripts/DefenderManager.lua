DefenderManager = {}

local this = DefenderManager
this.DefenderList = {}
this.defenderCount = 0

--[[ Definition of a Defender: ]]
local Defender = {}

function Defender.Create(player, name, startingPoint)
  local this = {}
  this.player = player
  this.name = name
  this.startingPoint = startingPoint
  this.alive = false
  this.killCount = 0

  return this
end

-- End Defender Definition

function this.Init()
    --[[ Get Defender starting locations: ]]
    -- for each player (red, blue, teal, purple)
    --   Find the Point for their main base and create a defender with that Point as their starting location
    --   if that player does not exist,
    --     Delete their goldmine

    this.InitializeDefenders()

  --[[ Load AI for the defenders that are AI controlled: ]]
  for k,v in ipairs(DefenderManager.DefenderList) do
    if( GetPlayerController(v.player) == MAP_CONTROL_COMPUTER ) then
      if( GetPlayerRace(v.player) == RACE_HUMAN ) then
        PickMeleeAI(v.player, "human.ai", nil, nil)
      elseif( GetPlayerRace(v.player) == RACE_ORC ) then
        PickMeleeAI(v.player, "orc.ai", nil, nil)
      elseif( GetPlayerRace(v.player) == RACE_UNDEAD ) then
        PickMeleeAI(v.player, "undead.ai", nil, nil)
      elseif( GetPlayerRace(v.player) == RACE_NIGHTELF ) then
        PickMeleeAI(v.player, "elf.ai", nil, nil)
      end
      ShareEverythingWithTeamAI(v.player)
    end
  end
end

function this.InitializeDefenders()
  -- This is the callback function to be called from ForGroup() (Reminder: this is just a definition)
  -- ForGroup() will call this function for every unit. At the start of the game, this will be about 6 units per player. (starting units)
  local function FindMainBase()
    local u        = GetEnumUnit()
    local unitID   = GetUnitTypeId(u)
    local unitName = GetUnitName(u)

    -- If the unitID matches any of the possible "town halls"
    if (unitID == FourCC("htow") or
        unitID == FourCC("ogre") or
        unitID == FourCC("unpl") or
        unitID == FourCC("etol")) 
    then
      local defenderStartingPoint = Utility.Point.Create(GetUnitX(u), GetUnitY(u))
      local player = GetOwningPlayer(u)
      local playerName = GetPlayerName(player)
      local defender = Defender.Create(player, playerName, defenderStartingPoint)
      defender.alive = true
      this.defenderCount = this.defenderCount + 1
      table.insert(this.DefenderList, defender)
    end
  end

  -- this.InitializeDefenders() starts here:
  local g
  for i=0,3 do -- For each possible human player
    g = CreateGroup()
    GroupEnumUnitsOfPlayer(g, Player(i), nil) -- What if the player isn't in the game? Will GroupEnumUnitsOfPlayer handle that?
    ForGroup(g, FindMainBase)
    DestroyGroup(g) -- Could recycle the group... how wasteful is this?
  end
  g = nil
end

-- This function is useful for debugging.
function this.PrintDefenderNames()
  for k,v in ipairs(this.DefenderList) do 
    print("Defender: " .. v.name .. ";" .. v.startingPoint.x .. ";" .. v.startingPoint.y .. ";" .. tostring(v.alive))
  end
end