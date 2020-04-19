DefenderManager = {}
local this = DefenderManager

this.DefenderList = {}

--[[ Definition of a Defender: ]]
Defender = {}
function Defender.Create(playerNumber)
  local this = {}
  this.playerNumber = playerNumber
  this.player = Player(this.playerNumber)
  this.killCount = 0

  return this
end
--[[ End Definition of a Defender ]]

function this.Init()
  --[[ Identify the Defenders: ]]
  for k,v in ipairs(PlayerManager.PlayerList) do
    if (v.number < 4) then
      local d = Defender.Create(v.number)
      table.insert(this.DefenderList, d)
    end
  end

  --[[ Load AI for the defenders that are AI controlled: ]]
  for k,v in ipairs(this.DefenderList) do
    if( GetPlayerController(v.player) == MAP_CONTROL_COMPUTER ) then
      if( GetPlayerRace(v.player) == RACE_HUMAN ) then
        StartMeleeAI(v.player, "human.ai")
      elseif( GetPlayerRace(v.player) == RACE_ORC ) then
        StartMeleeAI(v.player, "orc.ai")
      elseif( GetPlayerRace(v.player) == RACE_UNDEAD ) then
        StartMeleeAI(v.player, "undead.ai")
      elseif( GetPlayerRace(v.player) == RACE_NIGHTELF ) then
        StartMeleeAI(v.player, "elf.ai")
      end
      ShareEverythingWithTeamAI(v.player)
    end
  end

  --[[ Trigger for Counting Kills: ]]
  local function KillCountingHandler()
    local p = GetOwningPlayer(GetKillingUnit())

    for k,v in ipairs(this.DefenderList) do
      if(Player(v.playerNumber) == p) then
        v.killCount = v.killCount + 1
      end
    end
  end
  this.killCountingTrigger = CreateTrigger()
  TriggerAddAction(this.killCountingTrigger, KillCountingHandler)
  for k,v in ipairs(AbominationManager.AbominationList) do
    TriggerRegisterPlayerUnitEvent(this.killCountingTrigger, v.player, EVENT_PLAYER_UNIT_DEATH, nil)
  end

  --[[ Add Commands: ]]
  local function DefenderData()
    for k,v in ipairs(this.DefenderList) do
      print(GetPlayerName(v.player))
    end
  end
  CommandManager.AddCommand("defenders", DefenderData)
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

--[[ The Main Process: ]]
function this.Process()
  -- if a defender has lost all his units he is dead
  this.DetermineLivingDefenders()
end