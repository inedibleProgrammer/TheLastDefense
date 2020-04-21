SpiritManager = {}

local this = SpiritManager

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
  this.nAbilityPoints = 0
  this.abilityList = {}

  return this
end

-- End Definition of a Spirit

function this.Init()
  this.InitializeSpirits()
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