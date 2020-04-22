SpiritManager = {}

local this = SpiritManager
this.upgradePeriod = 300

this.possibleSpiritList =
{
  4,
  5,
  6,
  7,
  8,
  9,
}

this.SpiritList = {}

--[[ Definition of a Spirit: ]]
local Spirit = {}

function Spirit.Create(player)
  local this = {}
  this.player = player
  this.unit = CreateUnit(this.player, FourCC("ewsp"), 0.0, 0.0, 0.0)
  this.nAbilityPoints = 1
  this.abilityList = {}

  return this
end

function this.Init()
  this.InitializeSpirits()

  --[[ Add Commands ]]
  -- Add ability:
  local function AddAbility(commandData)
    -- Which player typed the message?
    for _,s in ipairs(this.SpiritList) do
      if (commandData.commandingPlayer == s.player) then
        if (s.nAbilityPoints > 0) then
          local abilityID = commandData.tokens[3]
          local abilityFound = false
          local abilityAdded = false
          for _,a in ipairs(s.abilityList) do
            if (a == abilityID) then
              abilityFound = true
            end
          end
          if (abilityFound) then
            if ( IncUnitAbilityLevel(s.unit, FourCC(abilityID)) ) then
              s.nAbilityPoints = s.nAbilityPoints - 1
            end
          else
            if ( UnitAddAbility(s.unit, FourCC(abilityID)) ) then
              s.nAbilityPoints = s.nAbilityPoints - 1
              table.insert(s.abilityList, abilityID)
            end
          end
        end
      end
    end
  end
  CommandManager.AddCommand("add", AddAbility)
  -- Remove Ability:
  local function RemoveAbility(commandData)
    -- Which player typed the message?
    for _,s in ipairs(this.SpiritList) do
      if (commandData.commandingPlayer == s.player) then
        local abilityID = commandData.tokens[3]
        local abilityLevel = GetUnitAbilityLevel(s.unit, FourCC(abilityID)) -- If the unit does not have the ability, and the ability is valid, GetUnitAbilityLevel will return 0

        if (abilityLevel > 1) then
          if ( DecUnitAbilityLevel(s.unit, FourCC(abilityID)) ) then
            s.nAbilityPoints = s.nAbilityPoints + 1
          end
        elseif (abilityLevel == 1) then
          if ( UnitRemoveAbility(s.unit, FourCC(abilityID)) ) then
            s.nAbilityPoints = s.nAbilityPoints + 1
            for index = 1, #s.abilityList do
              if (s.abilityList[index] == abilityID) then
                table.remove(s.abilityList, index)
              end
            end
          end
        else
          -- Do nothing
        end
      end
    end
  end
  CommandManager.AddCommand("remove", RemoveAbility)
  -- SpiritData:
  local function SpiritData()
    for _,s in ipairs(this.SpiritList) do
      local spiritData = "S"
      spiritData = spiritData .. ";" .. GetPlayerName(s.player)
      spiritData = spiritData .. ";" .. s.nAbilityPoints
      for _,a in ipairs(s.abilityList) do
        spiritData = spiritData .. ";" .. a
      end
      print(spiritData)
    end
  end
  CommandManager.AddCommand("spirits", SpiritData)
end

function this.InitializeSpirits()
  for k,v in ipairs(this.possibleSpiritList) do
    if(GetPlayerSlotState(Player(v)) == PLAYER_SLOT_STATE_PLAYING) then
      local function RemoveAllUnits()
        local u = GetEnumUnit()
        RemoveUnit(u)
        u = nil
      end
      -- Destroy all of their units:
      local g = CreateGroup()
      GroupEnumUnitsOfPlayer(g, Player(v))
      ForGroup(g, RemoveAllUnits)
      DestroyGroup(g)
      g = nil
      -- Create their wisp:
      local s = Spirit.Create(Player(v))
      -- Make the wisp invulnerable:
      SetUnitInvulnerable(s.unit, true)

      -- Give the wisp mana and regen
      BlzSetUnitMaxMana(s.unit, 500)
      BlzSetUnitRealField(s.unit, UNIT_RF_MANA_REGENERATION, 1.00)

      -- Change the wisp name
      BlzSetUnitName(s.unit, "Spirit")

      -- Add the wisp to the list
      table.insert(this.SpiritList, s)

      -- Trigger to prevent building:
      local function BuildTriggerHandler()
        local u = GetConstructingStructure()
        TriggerSleepAction(0.1)
        IssueImmediateOrderById(u, 851976) -- "Cancel"
      end
      s.buildTrigger = CreateTrigger()
      TriggerAddAction(s.buildTrigger, BuildTriggerHandler)
      TriggerRegisterPlayerUnitEvent(s.buildTrigger, Player(v), EVENT_PLAYER_UNIT_CONSTRUCT_START, nil)


      -- Remove wisp abilities
      UnitRemoveAbility(s.unit, FourCC("Aren")) -- renew
      UnitRemoveAbility(s.unit, FourCC("Adtn")) -- detonate
      UnitRemoveAbility(s.unit, FourCC("Awha")) -- gather
      UnitRemoveAbility(s.unit, FourCC("Ault")) -- ultravision
    end
  end
end

function this.Process()
  local currentElapsedSeconds = GameClock.GetElapsedSeconds()

  -- Initialize the multiboard
  if ( (ModuloInteger(currentElapsedSeconds, this.upgradePeriod) == 0) ) then
    for k,v in ipairs(this.SpiritList) do
      v.nAbilityPoints = v.nAbilityPoints + 1
    end
  end
end