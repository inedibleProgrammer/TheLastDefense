gg_trg_Untitled_Trigger_001 = nil
gg_trg_AddItemToStock = nil
gg_trg_ItemTesting = nil
gg_trg_AUnitDies = nil
gg_trg_camera = nil
gg_trg_HealUnit = nil
gg_trg_Upgrades = nil
gg_trg_KillRandomUnitInGroup = nil
gg_trg_CreateUnitAndAttackGround = nil
gg_trg_Melee_Initialization = nil
gg_trg_CallInit = nil
gg_unit_nten_0015 = nil
gg_trg_ManaRegen = nil
gg_unit_ngol_0030 = nil
function InitGlobals()
end

ColorManager = {}
local this = ColorManager

this.ColorList = {}

--[[ Definition of a Color: ]]
Color = {}
function Color.Create(text, number, hexCode)
  local this = {}
  this.text = text
  this.number = number
  this.hexCode = hexCode

  return this
end
--[[ End Definition of a Color ]]

function this.Init()
  this.AddColor("red", 1, "00FF0303")
  this.AddColor("blue", 2, "000042FF")
  this.AddColor("teal", 3, "001CE6B9")
  this.AddColor("purple", 4, "00540081")
  this.AddColor("yellow", 5, "00FFFC00")
  this.AddColor("orange", 6, "00FE8A0E")
  this.AddColor("green", 7, "0020C000")
  this.AddColor("pink", 8, "00E55BB0")
  this.AddColor("gray", 9, "00959697")
  this.AddColor("light_blue", 10, "007EBFF1")
  this.AddColor("dark_green", 11, "00106246")
  this.AddColor("brown", 12, "004E2A04")
  this.AddColor("maroon", 13, "009B0000")
  this.AddColor("navy", 14, "000000C3")
  this.AddColor("turquoise", 15, "0000EAFF")
  this.AddColor("violet", 16, "00BE00FE")
  this.AddColor("wheat", 17, "00EBCD87")
  this.AddColor("peach", 18, "00F8A48B")
  this.AddColor("mint", 19, "00BFFF80")
  this.AddColor("lavender", 20, "00DCB9EB")
  this.AddColor("coal", 21, "00282828")
  this.AddColor("snow", 22, "00EBF0FF")
  this.AddColor("emerald", 23, "0000781E")
  this.AddColor("peanut", 24, "00A46F33")
  this.AddColor("some_weird_green", 25, "0022744F")
  this.AddColor("gold", 26, "00FFD700")
  this.AddColor("bright_blue", 27, "0019CAF6")

  --[[ Commands: ]]
  local function PrintColors(commandData)
    local initialColor = 1
    local finalColor = 13

    if (commandData.tokens[3] == "2") then
      initialColor = 14
      finalColor = 24
    end

    for i = initialColor, finalColor do
      local c = this.GetColor_N(i)
      DisplayTimedTextToPlayer(commandData.commandingPlayer, 0, 0, 15.0, "|c" .. c.hexCode .. c.text .. "|r" .. "(" .. c.number .. ")")
    end
  end

  CommandManager.AddCommand("colors", PrintColors)
end

function this.AddColor(text, number, hexCode)
  local color = Color.Create(text, number, hexCode)
  table.insert(this.ColorList, color)
end

function this.GetColor_T(t)
  for k,v in ipairs(this.ColorList) do
    if t == v.text then
      return v
    end
  end
end

function this.GetColor_N(n)
  for k,v in ipairs(this.ColorList) do
    if n == v.number then
      return v
    end
  end
end

function this.GetColorCode(text)
  for k,v in ipairs(this.ColorList) do
    if text == v.text then
      return v.hexCode
    end
  end
end
CommandManager = {}
local this = CommandManager

this.CommandList = {}

--[[ Definition of a Command: ]]
Command = {}

function Command.Create(text, handler)
  local this = {}
  this.text = text
  this.handler = handler

  return this
end

--[[ End Definition of a Command ]]

function this.Init(activatorString)
  --[[ Register every players' chat with a an activator string ]]
  this.commandTrigger = CreateTrigger()
  TriggerAddAction(this.commandTrigger, this.CommandHandler)
  Utility.TriggerRegisterAllPlayersChat(this.commandTrigger, activatorString)
end

function this.CommandHandler()
  local commandData = {}
  commandData.message = GetEventPlayerChatString()
  commandData.commandingPlayer = GetTriggerPlayer()
  commandData.commandingPlayerName = GetPlayerName(commandData.commandingPlayer)
  commandData.tokens = Utility.MySplit(commandData.message, " ")
  commandData.credentialsVerified = false

  if(commandData.commandingPlayerName == "The_Master_Lich"
    or commandData.commandingPlayerName == "WorldEdit"
    or commandData.commandingPlayerName == "MasterLich"
    or commandData.commandingPlayerName == "MasterLich#11192")
  then
    commandData.credentialsVerified = true
  end

  for k,v in ipairs(this.CommandList) do
    if (commandData.tokens[2] == v.text) then
      v.handler(commandData)
    end
  end

end

function this.AddCommand(text, handler)
  local command = Command.Create(text, handler)
  table.insert(this.CommandList, command)
end
GameClock = {}

local this = GameClock

this.hours   = 0
this.minutes = 0
this.seconds = 0
this.elapsedSeconds = 0

function this.Init()
  this.clockTrigger = CreateTrigger()
  TriggerAddAction(this.clockTrigger, this.ClockHandler)
  TriggerRegisterTimerEvent(this.clockTrigger, 1.00, true)

  --[[ Add Commands: ]]
  local function PrintTime(commandData)
    local currentTimeString = "|c" .. ColorManager.GetColorCode("gold") .. "Time Elapsed: |r" .. this.hours .. ":" .. this.minutes .. ":" .. this.seconds
    DisplayTimedTextToPlayer(commandData.commandingPlayer, 0.00, 0.00, 10, currentTimeString)
  end
  CommandManager.AddCommand("time", PrintTime)
end

function this.ClockHandler()
  this.seconds = this.seconds + 1

  if(this.seconds > 59) then
    this.minutes = this.minutes + 1
    this.seconds = 0
  end

  if(this.minutes > 59) then
    this.hours = this.hours + 1
    this.minutes = 0
  end

  this.elapsedSeconds = this.elapsedSeconds + 1
end

function this.GetTime()
  local t = {}
  t.hours = this.hours
  t.minutes = this.minutes
  t.seconds = this.seconds
  return t
end

function this.GetElapsedSeconds()
  return this.elapsedSeconds
end
PlayerManager = {}
local this = PlayerManager

this.PlayerList = {}

--[[ Definition of a GamePlayer: ]]
GamePlayer = {}

function GamePlayer.Create(name, number)
  local this = {}
  this.name = name
  this.number = number
  this.color = ColorManager.GetColor_N(this.number + 1) -- ColorManager 1-indexes colors
  this.coloredName = "|c" .. this.color.hexCode .. this.name .. "|r"
  this.bInGame = true

  return this
end
--[[ End Definition of a GamePlayer ]]


function this.Init()
  --[[ Add players to the list: ]]
  for i = 0, 23 do
    local p = Player(i)
    if (GetPlayerSlotState(p) == PLAYER_SLOT_STATE_PLAYING) then
      this.AddPlayer(GetPlayerName(p), i)
    end
  end

  --[[ Initialize trigger that handles players leaving the game: ]]
  local function PlayerLeavingHandler()
    local p = GetTriggerPlayer()
    local gp = {}

    for k,v in ipairs(this.PlayerList) do
      if (v.name == GetPlayerName(p)) then
        gp = v
      end
    end

    print(v.coloredName .. " has left the game")
  end

  this.playerLeavingTrigger = CreateTrigger()
  TriggerAddAction(this.playerLeavingTrigger, PlayerLeavingHandler)
  for k,v in ipairs(PlayerManager.PlayerList) do
    TriggerRegisterPlayerEvent(this.playerLeavingTrigger, Player(v.number), EVENT_PLAYER_LEAVE)
  end

  --[[ Add Commands: ]]
  -- Clear
  local function Clear()
    ClearTextMessages()
  end
  CommandManager.AddCommand("clear", Clear)
  -- Visible -- This should go in TestManager or DebugManager or something
  local function Visible(commandData)
    if(commandData.credentialsVerified) then
      FogModifierStart(CreateFogModifierRect(commandData.commandingPlayer, FOG_OF_WAR_VISIBLE, GetWorldBounds(), true, true))
    end
  end
  CommandManager.AddCommand("visible", Visible)
  -- AllianceFilter (not a command)
  local function AllianceFilter(commandData)
    local doPlayersPass = false

    local otherPlayerColor = ColorManager.GetColor_T(commandData.tokens[3])

    if (otherPlayerColor ~= nil) then
      commandData.otherPlayer = Player(otherPlayerColor.number - 1)
      doPlayersPass = true
    end

    return doPlayersPass
  end
  -- Ally
  local function Ally(commandData)
    if(AllianceFilter(commandData)) then
      SetPlayerAlliance(commandData.commandingPlayer, commandData.otherPlayer, ALLIANCE_PASSIVE, true)
    end
  end
  CommandManager.AddCommand("ally", Ally)
  -- Unally
  local function Unally(commandData)
    if(AllianceFilter(commandData)) then
      SetPlayerAlliance(commandData.commandingPlayer, commandData.otherPlayer, ALLIANCE_PASSIVE, false)
    end
  end
  CommandManager.AddCommand("unally", Unally)
  -- Vision
  local function Vision(commandData)
    if(AllianceFilter(commandData)) then
      SetPlayerAlliance(commandData.commandingPlayer, commandData.otherPlayer, ALLIANCE_SHARED_VISION, true)
    end
  end
  CommandManager.AddCommand("vision", Vision)
  -- Unvision
  function Unvision(commandData)
    if(AllianceFilter(commandData)) then
      SetPlayerAlliance(commandData.commandingPlayer, commandData.otherPlayer, ALLIANCE_SHARED_VISION, false)
    end
  end
  CommandManager.AddCommand("unvision", Unvision)
  -- Camera
  local function Camera(commandData)
    local distance = tonumber(commandData.tokens[3])
    if(distance ~= nil) then
      if( (distance >= 500) and (distance <= 3000) ) then
        SetCameraFieldForPlayer(commandData.commandingPlayer, CAMERA_FIELD_TARGET_DISTANCE, distance, 1.00)
      end
    end
  end
  CommandManager.AddCommand("camera", Camera)
  -- Names
  local function Names(commandData)
    local function PrintName(commandData, gamePlayer)
      DisplayTimedTextToPlayer(commandData.commandingPlayer, 0, 0, 15.0, "(" .. gamePlayer.number + 1 .. ")" .. gamePlayer.coloredName .. "-" .. gamePlayer.color.text)
    end
    if (#this.PlayerList > 13) then
      if (commandData.tokens[3] == "2") then
        for i = 14, #this.PlayerList do
          PrintName(commandData, this.PlayerList[i])
        end
      else
        for i = 1, 13 do
          PrintName(commandData, this.PlayerList[i])
        end
      end
    else
      for k,v in ipairs(this.PlayerList) do
        PrintName(commandData, v)
      end
    end
  end
  CommandManager.AddCommand("names", Names)
  --[[ End Commands ]]
end

function this.AddPlayer(name, number)
  local p = GamePlayer.Create(name, number)
  table.insert(this.PlayerList, p)
end
Utility = {}


--[[ Definition of Point ]]
Utility.Point = {}

function Utility.Point.Create(x, y)
  local this = {}
  this.x = x
  this.y = y

  function this.IsInRange(xMin, xMax, yMin, yMax)
    local isInRange = true
    if( not((xMin <= this.x) and (this.x <= xMax)) ) then
      isInRange = false
    end
    if( not((yMin <= this.y) and (this.y <= yMax)) ) then
      isInRange = false
    end
    return isInRange
  end

  return this
end

-- End Definition of Point


function Utility.TriggerRegisterAllPlayersChat(which_trigger, message)
  local all_players = (bj_MAX_PLAYER_SLOTS + 1 )
  for i = 0, all_players do
    TriggerRegisterPlayerChatEvent(which_trigger, Player(i), message, false)
  end
end

function Utility.MySplit(input_str, sep)
  if sep == nil then
    sep = " "
  end
  local t={}
  for str in string.gmatch(input_str, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

function Utility.TableMerge(t1, t2)
  for k,v in ipairs(t2) do
      table.insert(t1, v)
  end
end


-- Unit Group Functions:
function Utility.RemoveDeadUnitsFromGroup(unitGroup)
  local function RemoveDeadUnits()
    local u = GetEnumUnit()
    if(IsUnitType(u, UNIT_TYPE_DEAD)) then
      GroupRemoveUnit(unitGroup, u)
    end
    u = nil
  end

  ForGroup(unitGroup, RemoveDeadUnits)
end

function Utility.AttackRandomUnitOfPlayer(commandedUnit, targetPlayer)
  local g = CreateGroup()
  GroupEnumUnitsOfPlayer(g, targetPlayer, nil)
  
  local u = GroupPickRandomUnit(g)
  IssuePointOrder(commandedUnit, "attack", GetUnitX(u), GetUnitY(u))
  
  DestroyGroup(g)
  g = nil
  u = nil
end

-- End Unit Group Functions
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
    local attemptCounter = 10

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
  -- Game Parameters
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
  -- AbominationData
  local function AbominationData()
    for k,v in ipairs(this.AbominationList) do
      local abominationData = "A"
      abominationData = abominationData .. ";" .. tostring(v.targetPlayer)
      print(abominationData)
    end
  end
  CommandManager.AddCommand("abominations", AbominationData)
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
  this.alive = false

  return this
end
--[[ End Definition of a Defender ]]

function this.Init()
  --[[ Identify the Defenders: ]]
  for k,v in ipairs(PlayerManager.PlayerList) do
    if (v.number < 4) then
      local d = Defender.Create(v.number)
      d.alive = true
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
      local defenderData = "D"
      defenderData = defenderData .. ";" .. GetPlayerName(v.player)
      defenderData = defenderData .. ";" .. v.killCount
      defenderData = defenderData .. ";" .. v.alive
      print(defenderData)
    end
  end
  CommandManager.AddCommand("defenders", DefenderData)
end

function this.DetermineLivingDefenders()
  for k,v in ipairs(this.DefenderList) do
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
--[[ The beginning of everything ]]

function Init()
  xpcall(CommandManager.Init("-c"), print)

  xpcall(ColorManager.Init, print)

  xpcall(GameClock.Init, print)

  xpcall(PlayerManager.Init, print)

  xpcall(TheLastDefense.Init, print)
end
PermanentItemList = 
{
  "afac",
  "spsh",
  "ajen",
  "bgst",
  "belv",
  "bspd",
  "cnob",
  "ratc",
  "rat6",
  "rat9",
  "clfm",
  "clsd",
  "crys",
  "dsum",
  "rst1",
  "gcel",
  "hval",
  "hcun",
  "rhth",
  "kpin",
  "lgdh",
  "rin1",
  "mcou",
  "odef",
  "penr",
  "pmna",
  "prvt",
  "rde2",
  "rde3",
  "rde4",
  "rlif",
  "ciri",
  "brac",
  "sbch",
  "rag1",
  "rwiz",
  "ssil",
  "stel",
  "evtl",
  "lhst",
  "war2",
}

ChargedItemList =
{
  "wild",
  "ankh",
  "fgsk",
  "fgdg",
  "whwd",
  "hlst",
  "shar",
  "infs",
  "mnst",
  "pdi2",
  "pdiv",
  "pghe",
  "pgma",
  "pnvu",
  "pomn",
  "pres",
  "fgrd",
  "rej3",
  "sand",
  "sres",
  "srrc",
  "sror",
  "wswd",
  "fgfh",
  "fgrg",
  "totw",
  "will",
  "wlsd",
  "woms",
  "wshs",
  "wcyc",
}

PowerUpItemList =
{
  "lmbr",
  "gfor",
  "gomn",
  "guvi",
  "gold",
  "manh",
  "rdis",
  "rhe3",
  "rma2",
  "rre2",
  "rhe2",
  "rhe1",
  "rre1",
  "rman",
  "rreb",
  "rres",
  "rsps",
  "rspd",
  "rspl",
  "rwat",
  "tdex",
  "rdx2",
  "texp",
  "tint",
  "tin2",
  "tpow",
  "tstr",
  "tst2",
}

ArtifactItemList =
{
  "ratf",
  "ckng",
  "desc",
  "modt",
  "ofro",
  "tkno",
}

PurchasableItemList = 
{
  "pclr",
  "hslv",
  "tsct",
  "plcl",
  "mcri",
  "moon",
  "phea",
  "pinv",
  "pnvl",
  "pman",
  "ritd",
  "rnec",
  "skul",
  "shea",
  "sman",
  "spro",
  "sreg",
  "shas",
  "stwp",
  "silk",
  "sneg",
  "ssan",
  "tcas",
  "tgrh",
  "tret",
  "vamp",
  "wneg",
  "wneu",
}

CampaignItemList =
{
  "kybl",
  "ches",
  "bzbe",
  "engs",
  "bzbf",
  "gmfr",
  "ledg",
  "kygh",
  "gopr",
  "azhr",
  "cnhn",
  "dkfw",
  "k3m3",
  "mgtk",
  "mort",
  "kymn",
  "k3m1",
  "jpnt",
  "k3m2",
  "phlt",
  "sclp",
  "sxpl",
  "sorf",
  "shwd",
  "skrt",
  "glsk",
  "kysn",
  "sehr",
  "thle",
  "dphe",
  "dthb",
  "ktrm",
  "vpur",
  "wtlg",
  "wolg",
}

MiscellaneousItemList =
{
  "amrc",
  "axas",
  "anfg",
  "pams",
  "arsc",
  "arsh",
  "asbl",
  "btst",
  "blba",
  "bfhr",
  "brag",
  "cosl",
  "rat3",
  "stpg",
  "crdt",
  "dtsb",
  "drph",
  "dust",
  "shen",
  "envl",
  "esaz",
  "frhg",
  "fgun",
  "fwss",
  "frgd",
  "gemt",
  "gvsm",
  "gobm",
  "tels",
  "rej4",
  "rej6",
  "grsl",
  "hbth",
  "sfog",
  "flag",
  "iwbr",
  "jdrn",
  "kgal",
  "klmm",
  "rej2",
  "rej5",
  "lnrn",
  "mlst",
  "mnsf",
  "rej1",
  "lure",
  "nspi",
  "nflg",
  "ocor",
  "ofr2",
  "ofir",
  "gldo",
  "oli2",
  "olig",
  "oslo",
  "oven",
  "oflg",
  "pgin",
  "pspd",
  "rde0",
  "rde1",
  "rnsp",
  "ram2",
  "ram4",
  "ram3",
  "ram1",
  "rugt",
  "rump",
  "horl",
  "schl",
  "ccmd",
  "rots",
  "scul",
  "srbd",
  "srtl",
  "sor1",
  "sora",
  "sor2",
  "sor3",
  "sor4",
  "sor5",
  "sor6",
  "sor7",
  "sor8",
  "sor9",
  "shcw",
  "shtm",
  "shhn",
  "shdt",
  "shrs",
  "sksh",
  "soul",
  "gsou",
  "sbok",
  "sprn",
  "spre",
  "stre",
  "stwa",
  "thdm",
  "tbak",
  "tbar",
  "tbsm",
  "tfar",
  "tlum",
  "tgxp",
  "tmsc",
  "tmmt",
  "uflg",
  "vddl",
  "ward",
}

AllItemList = {}


function ItemList_Init()
  -- Merge every table into one table:
  Utility.TableMerge(AllItemList, PermanentItemList)
  Utility.TableMerge(AllItemList, ChargedItemList)
  Utility.TableMerge(AllItemList, PowerUpItemList)
  Utility.TableMerge(AllItemList, ArtifactItemList)
  Utility.TableMerge(AllItemList, PurchasableItemList)
  Utility.TableMerge(AllItemList, CampaignItemList)
  Utility.TableMerge(AllItemList, MiscellaneousItemList)
end
ItemManager = {}
local this = ItemManager

this.ShopItemList = {}

--[[ Definition of a Shop Item: ]]
ShopItem = {}
function ShopItem.Create(iID, price)
  local this = {}
  this.iID = iID
  this.price = price

  return this
end
--[[ End Definition of a Shop Item ]]

function this.Init()
  print("Initializing Items: ")

  --[[ Get all the item prices and save them ]]
  -- This process takes no more than one minute to finish
  for k,v in ipairs(AllItemList) do
    local price = this.GetItemPrice(v)

    if (price > 0) then
      local si = ShopItem.Create(v, price)
      table.insert(this.ShopItemList, si)
    end
  end

  --[[ Add Commands: ]]
end

--   This function determines the price of an item
-- by selling the item to a shop and comparing the
-- user's gold before and after.
-- relevantItem should be the 4 character string.
function this.GetItemPrice(relevantItem)
  local point = Utility.Point.Create(6687.8, 6359.3)
  local shop = CreateUnit(Player(10), FourCC("ngme"), point.x, point.y, 0.0)
  local hero = CreateUnit(Player(10), FourCC("Hpal"), point.x, point.y, 0.0)
  local i = UnitAddItemById(hero, FourCC(relevantItem), 0)
  local initialGold = GetPlayerState(Player(10),PLAYER_STATE_RESOURCE_GOLD)
  local finalGold = 0
  UnitDropItemTarget(hero, i, shop)
  TriggerSleepAction(0.1)
  finalGold = (GetPlayerState(Player(10),PLAYER_STATE_RESOURCE_GOLD) - initialGold) * 2
  RemoveUnit(shop)
  RemoveUnit(hero)
  RemoveItem(i)
  shop = nil
  hero = nil
  i = nil
  return finalGold
end

function this.GetRandomShopItem()
  local r = GetRandomInt(1, #this.ShopItemList)
  local si = {}

  si = this.ShopItemList[r]
  return si
end
MultiboardManager = {}
local this = MultiboardManager


this.delay = 5
this.initialized = false
this.multiboard = nil
this.multiboardRows = 0

function this.Init()
end

function this.Process()
  local currentElapsedSeconds = GameClock.GetElapsedSeconds()

  -- Initialize the multiboard
  if ( (ModuloInteger(currentElapsedSeconds, this.delay) == 0) and not(this.initialized) ) then
    this.initialized = true

    this.multiboard = CreateMultiboardBJ(2, #(DefenderManager.DefenderList) + 1, "ScoreBoard")
    MultiboardMinimizeBJ(true, this.multiboard)
    MultiboardSetItemStyleBJ(this.multiboard, 0, 0, true, false)
    MultiboardSetItemWidthBJ(this.multiboard, 0, 0, 10)

    for k,v in ipairs(DefenderManager.DefenderList) do
      MultiboardSetItemValueBJ(this.multiboard, 1, k, "|c" .. ColorManager.GetColor_N(GetPlayerId(v.player) + 1).hexCode ..GetPlayerName(v.player) .. "|r")
      this.multiboardRows = this.multiboardRows + 1
    end

    MultiboardSetItemValueBJ(this.multiboard, 1, this.multiboardRows + 1, "|c" .. ColorManager.GetColor_T("gold").hexCode .. "GameTime:" .. "|r")
  end

  if (this.initialized) then
    for k,v in ipairs(DefenderManager.DefenderList) do
      MultiboardSetItemValueBJ(this.multiboard, 2, k, tostring(v.killCount))
    end
    MultiboardSetItemValueBJ(this.multiboard, 2, this.multiboardRows + 1, tostring(GameClock.hours) .. ":" .. tostring(GameClock.minutes) .. ":" .. tostring(GameClock.seconds))
  end
end
ShopManager = {}
local this = ShopManager

this.updatePeriod = 60 -- Seconds
this.nItems = 8

this.ItemsForSale = {}

function this.Init()
  local marketPlacePoint = Utility.Point.Create(895.6, -1609.6)
  this.marketPlace = CreateUnit(Player(27), FourCC("nmrk"), marketPlacePoint.x, marketPlacePoint.y, 0.0)

  --[[ Add Commands: ]]
  local function ViewShopItems()
    for k,v in ipairs(this.ItemsForSale) do
      print(v.iID)
    end
  end
  CommandManager.AddCommand("shop", ViewShopItems)
end


function this.Process()
  local currentElapsedSeconds = GameClock.GetElapsedSeconds()
  
  --[[ Update Shop Items: ]]
  if (ModuloInteger(currentElapsedSeconds, this.updatePeriod) == 0) then
    -- First, empty the market
    if (#this.ItemsForSale >= 1) then
      for k,v in ipairs(this.ItemsForSale) do
        RemoveItemFromStock(this.marketPlace, FourCC(v.iID))
        this.ItemsForSale[k] = nil
      end
    end

    -- Now, add items to the shop
    for i = 1, this.nItems do
      local si = ItemManager.GetRandomShopItem()
      table.insert(this.ItemsForSale, si)
      AddItemToStock(this.marketPlace, FourCC(si.iID), 1, 1)
    end
  end
end
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
  this.nAbilityPoints = 10
  this.abilityList = {}

  return this
end

-- End Definition of a Spirit

-- local abilityFound = false
-- local abilityAdded = false
-- for _,a in ipairs(s.abilityList) do
--   if (a == abilityID) then
--     abilityFound = true
--   end
-- end
-- if (abilityFound) then
--   if ( IncUnitAbilityLevel(s.unit, FourCC(abilityID)) ) then
--     s.nAbilityPoints = s.nAbilityPoints - 1
--   end
-- else
--   if ( UnitAddAbility(s.unit, FourCC(abilityID)) ) then
--     s.nAbilityPoints = s.nAbilityPoints - 1
--     table.insert(s.abilityList, abilityID)
--   end
-- end


-- print("test")
-- local abilityLevel = BlzGetUnitAbility(s.unit, abilityID)
-- print("abilityLevel: " .. tostring(abilityLevel))
-- -- if (abilityLevel > 0) then
-- --   if ( IncUnitAbilityLevel(s.unit, FourCC(abilityID)) ) then
-- --     s.nAbilityPoints = s.nAbilityPoints - 1
-- --   end
-- -- else
-- --   if ( UnitAddAbility(s.unit, FourCC(abilityID)) ) then
-- --     s.nAbilityPoints = s.nAbilityPoints - 1
-- --   end
-- -- end

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
        local abilityLevel = GetUnitAbilityLevel(s.unit, FourCC(abilityID))
        print("abilitylevel: " .. abilityLevel)

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
TestManager = {}
local this = TestManager

this.RedTable = {}


function this.Init()
  local function RedAdd(commandData)
    local input = commandData.tokens[3]
    table.insert(this.RedTable, input)
  end
  CommandManager.AddCommand("red_add", RedAdd)

  local function RedRemove(commandData)
    local input = commandData.tokens[3]
    for index = 1, #this.RedTable do
      if (this.RedTable[index] == input) then
        table.remove(this.RedTable, index)
      end
    end
  end
  CommandManager.AddCommand("red_remove", RedRemove)

  local function RedPrint()
    local redData = "R"
    for k,v in ipairs(this.RedTable) do
      redData = redData .. ";" .. v
    end
    print(redData)
  end
  CommandManager.AddCommand("red_print", RedPrint)
end

function this.Process()
end
TheLastDefense = {}
local this = TheLastDefense

function this.Init()
  xpcall(AbilityList_Init, print)

  xpcall(ItemList_Init, print)

  xpcall(UnitList_Init, print)

  xpcall(UpgradeList_Init, print)

  xpcall(ShopManager.Init, print)

  xpcall(DefenderManager.Init, print)

  xpcall(AbominationManager.Init, print)

  xpcall(SpiritManager.Init, print)

  xpcall(TestManager.Init, print)

  xpcall(ItemManager.Init, print)

  --[[ Initialize Game Handler: ]]
  this.clockTrigger = CreateTrigger()
  TriggerAddAction(this.clockTrigger, this.GameHandler)
  TriggerRegisterTimerEvent(this.clockTrigger, 1.00, true)
  --[[ Add Commands: ]]
end


function this.GameHandler()
  DefenderManager.Process()

  AbominationManager.Process()

  MultiboardManager.Process()

  SpiritManager.Process()

  ShopManager.Process()
end


HumanUnitList = 
{
  "hpea",
  "hfoo",
  "hkni",
  "hrif",
  "hmtm",
  "hgyr",
  "hgry",
  "hmpr",
  "hsor",
  "hmtt",
  "hspt",
  "hdhw",
  "Hpal",
  "Hamg",
  "Hmkg",
  "Hblm",
}

HumanCampaignUnitList =
{
  "hhes",
  "hcth",
  "hrrh",
  "nccd",
  "nccr",
  "ncco",
  "nccu",
  "nwar",
  "nemi",
  "nhef",
  "nhem",
  "nhea",
  "nmed",
  "nser",
  "hbot",
  "hdes",
  "hbsh",
  "nchp",
  "nhym",
  "nws1",
  "nbee",
  "njks",
  "hrdh",
  "hhdl",
  "hbew",
  "nhew",
  "nbel",
  "Hssa",
  "hddt",
  "Haah",
  "Hapm",
  "Hgam",
  "Hant",
  "Hart",
  "Harf",
  "Hdgo",
  "Hhkl",
  "Hjai",
  "Hjnd",
  "Hkal",
  "Hlgr",
  "Hpb1",
  "Hmgd",
  "Hmbr",
  "Hpb2",
  "Hvwd",
  "Huth",
}

OrcUnitList =
{
  "opeo",
  "ogru",
  "orai",
  "otau",
  "ohun",
  "ocat",
  "okod",
  "owyv",
  "otbr",
  "odoc",
  "oshm",
  "ospw",
  "Obla",
  "Ofar",
  "Otch",
  "Oshd",
}

OrcCampaignUnitList =
{
  "owad",
  "nw2w",
  "nchw",
  "nchg",
  "nchr",
  "nckb",
  "ncpn",
  "obai",
  "obot",
  "odes",
  "ojgn",
  "nspc",
  "oosc",
  "owar",
  "ogrk",
  "oswy",
  "ownr",
  "odkt",
  "Nbbc",
  "Ocbh",
  "Ocb2",
  "Nsjs",
  "Odrt",
  "Ogrh",
  "Opgh",
  "Ogld",
  "Orex",
  "Orkn",
  "Osam",
  "Othr",
  "Oths",
}

UndeadUnitList =
{
  "uaco",
  "ushd",
  "ugho",
  "uabo",
  "umtw",
  "ucry",
  "ugar",
  "uban",
  "unec",
  "uobs",
  "ufro",
  "Udea",
  "Ulic",
  "Udre",
  "Ucrl",
}

UndeadCampaignUnitList =
{
  "nzom",
  "nzof",
  "ubot",
  "udes",
  "uubs",
  "uarb",
  "uktg",
  "uktn",
  "uswb",
  "ubdd",
  "ubdr",
  "Nman",
  "Uwar",
  "Npld",
  "Nklj",
  "Nmag",
  "Uanb",
  "Uear",
  "Ubal",
  "Uvng",
  "Udth",
  "Uktl",
  "Umal",
  "Usyl",
  "Utic",
  "Uvar",
}

NightElfUnitList =
{
  "ewsp",
  "earc",
  "esen",
  "edry",
  "ebal",
  "ehip",
  "ehpr",
  "echm",
  "edot",
  "edoc",
  "emtg",
  "efdr",
  "Ekee",
  "Emoo",
  "Edem",
  "Ewar",
}

NightElfCampaignUnitList = 
{
  "nthr",
  "etrs",
  "edes",
  "ebsh",
  "enec",
  "eilw",
  "nwat",
  "ensh",
  "nssn",
  "eshd",
  "Ecen",
  "Ekgg",
  "Eill",
  "Eevi",
  "Ewrd",
  "Emns",
  "Emfr",
  "Efur",
  "Etyr",
}

NagaUnitList =
{
  "nwgs",
  "nnmg",
  "nnsw",
  "nsnp",
  "nmyr",
  "nnrg",
  "nhyc",
  "nmpe",
  "Hvsh",
}

NeutralHostileUnitList =
{
  "nanm",
  "nanb",
  "nanc",
  "nanw",
  "nane",
  "nano",
  "nban",
  "nbrg",
  "nrog",
  "nass",
  "nenf",
  "nbld",
  "nbdm",
  "nbda",
  "nbdw",
  "nbds",
  "nbdo",
  "ncea",
  "ncer",
  "ncim",
  "ncen",
  "ncks",
  "ncnk",
  "nscb",
  "nsc2",
  "nsc3",
  "ndtr",
  "ndtp",
  "ndtt",
  "ndtb",
  "ndth",
  "ndtw",
  "ndrf",
  "ndrm",
  "ndrp",
  "ndrw",
  "ndrh",
  "ndrd",
  "ndrs",
  "nrdk",
  "nrdr",
  "nrmw",
  "nbdr",
  "nbdk",
  "nbwm",
  "nbzw",
  "nbzk",
  "nbzd",
  "ngrw",
  "ngdk",
  "ngrd",
  "nadw",
  "nadk",
  "nadr",
  "nnht",
  "nndk",
  "nndr",
  "nrel",
  "nele",
  "nsel",
  "nelb",
  "nenc",
  "nenp",
  "nepl",
  "ners",
  "nerd",
  "nerw",
  "nfor",
  "nfot",
  "nfod",
  "nfgu",
  "nfgb",
  "nfov",
  "npfl",
  "nfel",
  "npfm",
  "nftr",
  "nfsp",
  "nftt",
  "nftb",
  "nfsh",
  "nftk",
  "nfrl",
  "nfrs",
  "nfrp",
  "nfrb",
  "nfrg",
  "nfre",
  "nfra",
  "ngh1",
  "ngh2",
  "nsgn",
  "nsgh",
  "nsgb",
  "nspb",
  "nspg",
  "nspr",
  "nssp",
  "nsgt",
  "nsbm",
  "ngna",
  "ngns",
  "ngno",
  "ngnb",
  "ngnw",
  "ngnv",
  "ngrk",
  "ngst",
  "nggr",
  "narg",
  "nwrg",
  "nsgg",
  "nhar",
  "ngrr",
  "nhrw",
  "nhrh",
  "nhrq",
  "nhfp",
  "nhdc",
  "nhhr",
  "nhyh",
  "nhyd",
  "nehy",
  "nahy",
  "nitr",
  "nitp",
  "nitt",
  "nits",
  "nith",
  "nitw",
  "ninc",
  "ninm",
  "nina",
  "nkob",
  "nkog",
  "nkot",
  "nkol",
  "nltl",
  "nthl",
  "nstw",
  "nlpr",
  "nlpd",
  "nltc",
  "nlds",
  "nlsn",
  "nlkl",
  "nwiz",
  "nwzr",
  "nwzg",
  "nwzd",
  "nmgw",
  "nmgr",
  "nmgd",
  "nmam",
  "nmit",
  "nmdr",
  "nmcf",
  "nmbg",
  "nmtw",
  "nmsn",
  "nmrv",
  "nmsc",
  "nmrl",
  "nmrr",
  "nmpg",
  "nmfs",
  "nmrm",
  "nmmu",
  "nspd",
  "nnwa",
  "nnwl",
  "nnwr",
  "nnws",
  "nnwq",
  "nogr",
  "nomg",
  "nogm",
  "nogl",
  "nowb",
  "nowe",
  "nowk",
  "nplb",
  "nplg",
  "nfpl",
  "nfps",
  "nfpt",
  "nfpc",
  "nfpe",
  "nfpu",
  "nrzt",
  "nrzs",
  "nqbh",
  "nrzb",
  "nrzm",
  "nrzg",
  "nrvf",
  "nrev",
  "nrvs",
  "nsrv",
  "nrvl",
  "nrvi",
  "ndrv",
  "nrvd",
  "nlrv",
  "nslh",
  "nslr",
  "nslv",
  "nsll",
  "nsqt",
  "nsqe",
  "nsqo",
  "nsqa",
  "nsty",
  "nsat",
  "nsts",
  "nstl",
  "nsth",
  "nsko",
  "nsog",
  "nsoc",
  "nslm",
  "nslf",
  "nsln",
  "nsra",
  "nsrh",
  "nsrn",
  "nsrw",
  "ndqn",
  "ndwv",
  "ndqt",
  "ndqp",
  "ndqs",
  "ntrh",
  "ntrs",
  "ntrt",
  "ntrg",
  "ntrd",
  "ntkf",
  "ntka",
  "ntkh",
  "ntkt",
  "ntkw",
  "ntks",
  "ntkc",
  "nubk",
  "nubr",
  "nubw",
  "nvdl",
  "nvdw",
  "nvdg",
  "nvde",
  "nwen",
  "nwnr",
  "nwns",
  "nwna",
  "nwwf",
  "nwlt",
  "nwwg",
  "nwlg",
  "nwwd",
  "nwld",
  "nska",
  "nskf",
  "nskm",
  "nbal",
  "ninf",
  "ndrj",
  "ndmu",
  "nskg",
  "njg1",
  "njga",
  "njgb",
  "Nmsr", -- There's a murloc hero??
  "ndrl",
  "ndrt",
  "ndrn",
  "ngow",
  "ngos",
  "nggd",
  "nggg",
  "nggm",
  "nwzw",
  "nogo",
  "nogn",
  "noga",
  "ndsa",
  "nglm",
  "nfgl",
}

NeutralPassiveUnitList =
{
  "nalb",
  "nech",
  "ncrb",
  "ndog",
  "ndwm",
  "nfbr",
  "nfro",
  "nhmc",
  "npng",
  "npig",
  "necr",
  "nrac",
  "nrat",
  "nsea",
  "nshe",
  "nskk",
  "nsno",
  "uder",
  "uvul",
  "nske",
  "Nalc",
  "Nswt",
  "Nngs",
  "Ntin",
  "Nbst",
  "nbpm",
  "Nbrn",
  "Nfir",
  "Nplh",
  "zcso",
  "zhyd",
  "zmar",
  "zjug",
  "zzrg",
  "nvlk",
  "nvk2",
  "ngog",
  "nvlw",
  "nvl2",
  "nvil",
  "ncat",
  "Naka",
}

AllRacesUnitList = {}

AllUnitList = {}


function UnitList_Init()
  -- Merge the four races into one table:
  Utility.TableMerge(AllRacesUnitList, HumanUnitList)
  Utility.TableMerge(AllRacesUnitList, OrcUnitList)
  Utility.TableMerge(AllRacesUnitList, UndeadUnitList)
  Utility.TableMerge(AllRacesUnitList, NightElfUnitList)

  -- Merge everything into one big table:
  Utility.TableMerge(AllUnitList, AllRacesUnitList)
  Utility.TableMerge(AllUnitList, HumanCampaignUnitList)
  Utility.TableMerge(AllUnitList, OrcCampaignUnitList)
  Utility.TableMerge(AllUnitList, UndeadCampaignUnitList)
  Utility.TableMerge(AllUnitList, NightElfCampaignUnitList)
  Utility.TableMerge(AllUnitList, NeutralHostileUnitList)
  Utility.TableMerge(AllUnitList, NeutralPassiveUnitList)
end

HumanUpgradeList =
{
  "Rhan",
  "Rhpm",
  "Rhrt",
  "Rhra",
  "Rhcd",
  "Rhss",
  "Rhde",
  "Rhfc",
  "Rhfl",
  "Rhgb",
  "Rhfs",
  "Rhlh",
  "Rhac",
  "Rhme",
  "Rhar",
  "Rhri",
  "Rhse",
  "Rhpt",
  "Rhst",
  "Rhhb",
  "Rhla",
  "Rhsb",
}

OrcUpgradeList = 
{
  "Ropm",
  "Robk",
  "Robs",
  "Robf",
  "Roen",
  "Rovs",
  "Rolf",
  "Ropg",
  "Rows",
  "Rorb",
  "Rost",
  "Rost",
  "Rosp",
  "Rowt",
  "Roar",
  "Rome",
  "Rora",
  "Rotr",
  "Rwdm",
  "Rowd",
}

UndeadUpgradeList = 
{
  "Rupm",
  "Ruba",
  "Rubu",
  "Ruac",
  "Rura",
  "Rucr",
  "Rusp",
  "Rupc",
  "Ruex",
  "Rufb",
  "Rugf",
  "Rune",
  "Rusl",
  "Rusm",
  "Rusf",
  "Ruar",
  "Rume",
  "Ruwb",
}

NightElfUpgradeList =
{
  "Resi",
  "Repm",
  "Recb",
  "Redc",
  "Redt",
  "Rehs",
  "Reht",
  "Reib",
  "Reeb",
  "Reec",
  "Remk",
  "Rema",
  "Renb",
  "Rerh",
  "Rers",
  "Resc",
  "Resm",
  "Resw",
  "Reuv",
  "Remg",
  "Repb",
  "Rews",
}

AllRacesUpgradeList = {}

function UpgradeList_Init()
   -- Merge the four races into one table:
   Utility.TableMerge(AllRacesUpgradeList, HumanUpgradeList)
   Utility.TableMerge(AllRacesUpgradeList, OrcUpgradeList)
   Utility.TableMerge(AllRacesUpgradeList, UndeadUpgradeList)
   Utility.TableMerge(AllRacesUpgradeList, NightElfUpgradeList)
end
function CreateNeutralPassiveBuildings()
    local p = Player(PLAYER_NEUTRAL_PASSIVE)
    local u
    local unitID
    local t
    local life
    u = BlzCreateUnitWithSkin(p, FourCC("ngol"), -1728.0, -6720.0, 270.000, FourCC("ngol"))
    SetResourceAmount(u, 100000)
    u = BlzCreateUnitWithSkin(p, FourCC("ngol"), -4864.0, -7040.0, 270.000, FourCC("ngol"))
    SetResourceAmount(u, 100000)
    u = BlzCreateUnitWithSkin(p, FourCC("ngol"), 5056.0, -6912.0, 270.000, FourCC("ngol"))
    SetResourceAmount(u, 100000)
    u = BlzCreateUnitWithSkin(p, FourCC("ngol"), 1024.0, -6592.0, 270.000, FourCC("ngol"))
    SetResourceAmount(u, 100000)
    u = BlzCreateUnitWithSkin(p, FourCC("ngme"), -192.0, -1088.0, 270.000, FourCC("ngme"))
    u = BlzCreateUnitWithSkin(p, FourCC("nfoh"), 192.0, -1024.0, 270.000, FourCC("nfoh"))
    u = BlzCreateUnitWithSkin(p, FourCC("nmoo"), 576.0, -1024.0, 270.000, FourCC("nmoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("ngad"), 960.0, -1088.0, 270.000, FourCC("ngad"))
    u = BlzCreateUnitWithSkin(p, FourCC("ntav"), 384.0, -1728.0, 270.000, FourCC("ntav"))
    SetUnitColor(u, ConvertPlayerColor(0))
    u = BlzCreateUnitWithSkin(p, FourCC("nten"), -480.0, -2144.0, 270.000, FourCC("nten"))
    u = BlzCreateUnitWithSkin(p, FourCC("nten"), 32.0, -2400.0, 270.000, FourCC("nten"))
    u = BlzCreateUnitWithSkin(p, FourCC("ngol"), -6272.0, 0.0, 270.000, FourCC("ngol"))
    SetResourceAmount(u, 100000)
    u = BlzCreateUnitWithSkin(p, FourCC("ngol"), 3648.0, -1600.0, 270.000, FourCC("ngol"))
    SetResourceAmount(u, 100000)
    u = BlzCreateUnitWithSkin(p, FourCC("ngol"), 5184.0, 5504.0, 270.000, FourCC("ngol"))
    SetResourceAmount(u, 100000)
    u = BlzCreateUnitWithSkin(p, FourCC("ncop"), 896.0, -1856.0, 270.000, FourCC("ncop"))
    u = BlzCreateUnitWithSkin(p, FourCC("ngol"), 6528.0, -4928.0, 270.000, FourCC("ngol"))
    SetResourceAmount(u, 100000)
    u = BlzCreateUnitWithSkin(p, FourCC("ngol"), 0.0, -3200.0, 270.000, FourCC("ngol"))
    SetResourceAmount(u, 100000)
    u = BlzCreateUnitWithSkin(p, FourCC("ngol"), -3648.0, -4096.0, 270.000, FourCC("ngol"))
    SetResourceAmount(u, 100000)
    u = BlzCreateUnitWithSkin(p, FourCC("ngol"), -1280.0, 960.0, 270.000, FourCC("ngol"))
    SetResourceAmount(u, 100000)
    u = BlzCreateUnitWithSkin(p, FourCC("ngol"), 2560.0, 2688.0, 270.000, FourCC("ngol"))
    SetResourceAmount(u, 100000)
    u = BlzCreateUnitWithSkin(p, FourCC("ngol"), -6272.0, 2304.0, 270.000, FourCC("ngol"))
    SetResourceAmount(u, 100000)
    u = BlzCreateUnitWithSkin(p, FourCC("ngol"), -2816.0, -2112.0, 270.000, FourCC("ngol"))
    SetResourceAmount(u, 100000)
end

function CreatePlayerBuildings()
end

function CreatePlayerUnits()
end

function CreateAllUnits()
    CreateNeutralPassiveBuildings()
    CreatePlayerBuildings()
    CreatePlayerUnits()
end

function Trig_Melee_Initialization_Actions()
    MeleeStartingVisibility()
    MeleeStartingHeroLimit()
    MeleeGrantHeroItems()
    MeleeStartingResources()
    MeleeClearExcessUnits()
    MeleeStartingUnits()
end

function InitTrig_Melee_Initialization()
    gg_trg_Melee_Initialization = CreateTrigger()
    TriggerAddAction(gg_trg_Melee_Initialization, Trig_Melee_Initialization_Actions)
end

function Trig_CallInit_Actions()
        Init()
end

function InitTrig_CallInit()
    gg_trg_CallInit = CreateTrigger()
    TriggerAddAction(gg_trg_CallInit, Trig_CallInit_Actions)
end

function InitCustomTriggers()
    InitTrig_Melee_Initialization()
    InitTrig_CallInit()
end

function RunInitializationTriggers()
    ConditionalTriggerExecute(gg_trg_Melee_Initialization)
    ConditionalTriggerExecute(gg_trg_CallInit)
end

function InitCustomPlayerSlots()
    SetPlayerStartLocation(Player(0), 0)
    SetPlayerColor(Player(0), ConvertPlayerColor(0))
    SetPlayerRacePreference(Player(0), RACE_PREF_RANDOM)
    SetPlayerRaceSelectable(Player(0), true)
    SetPlayerController(Player(0), MAP_CONTROL_USER)
    SetPlayerStartLocation(Player(1), 1)
    SetPlayerColor(Player(1), ConvertPlayerColor(1))
    SetPlayerRacePreference(Player(1), RACE_PREF_RANDOM)
    SetPlayerRaceSelectable(Player(1), true)
    SetPlayerController(Player(1), MAP_CONTROL_USER)
    SetPlayerStartLocation(Player(2), 2)
    SetPlayerColor(Player(2), ConvertPlayerColor(2))
    SetPlayerRacePreference(Player(2), RACE_PREF_RANDOM)
    SetPlayerRaceSelectable(Player(2), true)
    SetPlayerController(Player(2), MAP_CONTROL_USER)
    SetPlayerStartLocation(Player(3), 3)
    SetPlayerColor(Player(3), ConvertPlayerColor(3))
    SetPlayerRacePreference(Player(3), RACE_PREF_RANDOM)
    SetPlayerRaceSelectable(Player(3), true)
    SetPlayerController(Player(3), MAP_CONTROL_USER)
    SetPlayerStartLocation(Player(4), 4)
    ForcePlayerStartLocation(Player(4), 4)
    SetPlayerColor(Player(4), ConvertPlayerColor(4))
    SetPlayerRacePreference(Player(4), RACE_PREF_NIGHTELF)
    SetPlayerRaceSelectable(Player(4), false)
    SetPlayerController(Player(4), MAP_CONTROL_USER)
    SetPlayerStartLocation(Player(5), 5)
    ForcePlayerStartLocation(Player(5), 5)
    SetPlayerColor(Player(5), ConvertPlayerColor(5))
    SetPlayerRacePreference(Player(5), RACE_PREF_NIGHTELF)
    SetPlayerRaceSelectable(Player(5), false)
    SetPlayerController(Player(5), MAP_CONTROL_USER)
    SetPlayerStartLocation(Player(6), 6)
    ForcePlayerStartLocation(Player(6), 6)
    SetPlayerColor(Player(6), ConvertPlayerColor(6))
    SetPlayerRacePreference(Player(6), RACE_PREF_NIGHTELF)
    SetPlayerRaceSelectable(Player(6), false)
    SetPlayerController(Player(6), MAP_CONTROL_USER)
    SetPlayerStartLocation(Player(7), 7)
    ForcePlayerStartLocation(Player(7), 7)
    SetPlayerColor(Player(7), ConvertPlayerColor(7))
    SetPlayerRacePreference(Player(7), RACE_PREF_NIGHTELF)
    SetPlayerRaceSelectable(Player(7), false)
    SetPlayerController(Player(7), MAP_CONTROL_USER)
    SetPlayerStartLocation(Player(8), 8)
    ForcePlayerStartLocation(Player(8), 8)
    SetPlayerColor(Player(8), ConvertPlayerColor(8))
    SetPlayerRacePreference(Player(8), RACE_PREF_NIGHTELF)
    SetPlayerRaceSelectable(Player(8), false)
    SetPlayerController(Player(8), MAP_CONTROL_USER)
    SetPlayerStartLocation(Player(9), 9)
    ForcePlayerStartLocation(Player(9), 9)
    SetPlayerColor(Player(9), ConvertPlayerColor(9))
    SetPlayerRacePreference(Player(9), RACE_PREF_NIGHTELF)
    SetPlayerRaceSelectable(Player(9), false)
    SetPlayerController(Player(9), MAP_CONTROL_USER)
    SetPlayerStartLocation(Player(10), 10)
    ForcePlayerStartLocation(Player(10), 10)
    SetPlayerColor(Player(10), ConvertPlayerColor(10))
    SetPlayerRacePreference(Player(10), RACE_PREF_UNDEAD)
    SetPlayerRaceSelectable(Player(10), false)
    SetPlayerController(Player(10), MAP_CONTROL_COMPUTER)
    SetPlayerStartLocation(Player(14), 11)
    ForcePlayerStartLocation(Player(14), 11)
    SetPlayerColor(Player(14), ConvertPlayerColor(14))
    SetPlayerRacePreference(Player(14), RACE_PREF_UNDEAD)
    SetPlayerRaceSelectable(Player(14), false)
    SetPlayerController(Player(14), MAP_CONTROL_COMPUTER)
    SetPlayerStartLocation(Player(18), 12)
    ForcePlayerStartLocation(Player(18), 12)
    SetPlayerColor(Player(18), ConvertPlayerColor(18))
    SetPlayerRacePreference(Player(18), RACE_PREF_UNDEAD)
    SetPlayerRaceSelectable(Player(18), false)
    SetPlayerController(Player(18), MAP_CONTROL_COMPUTER)
    SetPlayerStartLocation(Player(22), 13)
    ForcePlayerStartLocation(Player(22), 13)
    SetPlayerColor(Player(22), ConvertPlayerColor(22))
    SetPlayerRacePreference(Player(22), RACE_PREF_UNDEAD)
    SetPlayerRaceSelectable(Player(22), false)
    SetPlayerController(Player(22), MAP_CONTROL_COMPUTER)
end

function InitCustomTeams()
    SetPlayerTeam(Player(0), 0)
    SetPlayerState(Player(0), PLAYER_STATE_ALLIED_VICTORY, 1)
    SetPlayerTeam(Player(1), 0)
    SetPlayerState(Player(1), PLAYER_STATE_ALLIED_VICTORY, 1)
    SetPlayerTeam(Player(2), 0)
    SetPlayerState(Player(2), PLAYER_STATE_ALLIED_VICTORY, 1)
    SetPlayerTeam(Player(3), 0)
    SetPlayerState(Player(3), PLAYER_STATE_ALLIED_VICTORY, 1)
    SetPlayerAllianceStateAllyBJ(Player(0), Player(1), true)
    SetPlayerAllianceStateAllyBJ(Player(0), Player(2), true)
    SetPlayerAllianceStateAllyBJ(Player(0), Player(3), true)
    SetPlayerAllianceStateAllyBJ(Player(1), Player(0), true)
    SetPlayerAllianceStateAllyBJ(Player(1), Player(2), true)
    SetPlayerAllianceStateAllyBJ(Player(1), Player(3), true)
    SetPlayerAllianceStateAllyBJ(Player(2), Player(0), true)
    SetPlayerAllianceStateAllyBJ(Player(2), Player(1), true)
    SetPlayerAllianceStateAllyBJ(Player(2), Player(3), true)
    SetPlayerAllianceStateAllyBJ(Player(3), Player(0), true)
    SetPlayerAllianceStateAllyBJ(Player(3), Player(1), true)
    SetPlayerAllianceStateAllyBJ(Player(3), Player(2), true)
    SetPlayerAllianceStateVisionBJ(Player(0), Player(1), true)
    SetPlayerAllianceStateVisionBJ(Player(0), Player(2), true)
    SetPlayerAllianceStateVisionBJ(Player(0), Player(3), true)
    SetPlayerAllianceStateVisionBJ(Player(1), Player(0), true)
    SetPlayerAllianceStateVisionBJ(Player(1), Player(2), true)
    SetPlayerAllianceStateVisionBJ(Player(1), Player(3), true)
    SetPlayerAllianceStateVisionBJ(Player(2), Player(0), true)
    SetPlayerAllianceStateVisionBJ(Player(2), Player(1), true)
    SetPlayerAllianceStateVisionBJ(Player(2), Player(3), true)
    SetPlayerAllianceStateVisionBJ(Player(3), Player(0), true)
    SetPlayerAllianceStateVisionBJ(Player(3), Player(1), true)
    SetPlayerAllianceStateVisionBJ(Player(3), Player(2), true)
    SetPlayerTeam(Player(10), 1)
    SetPlayerState(Player(10), PLAYER_STATE_ALLIED_VICTORY, 1)
    SetPlayerTeam(Player(14), 1)
    SetPlayerState(Player(14), PLAYER_STATE_ALLIED_VICTORY, 1)
    SetPlayerTeam(Player(18), 1)
    SetPlayerState(Player(18), PLAYER_STATE_ALLIED_VICTORY, 1)
    SetPlayerTeam(Player(22), 1)
    SetPlayerState(Player(22), PLAYER_STATE_ALLIED_VICTORY, 1)
    SetPlayerAllianceStateAllyBJ(Player(10), Player(14), true)
    SetPlayerAllianceStateAllyBJ(Player(10), Player(18), true)
    SetPlayerAllianceStateAllyBJ(Player(10), Player(22), true)
    SetPlayerAllianceStateAllyBJ(Player(14), Player(10), true)
    SetPlayerAllianceStateAllyBJ(Player(14), Player(18), true)
    SetPlayerAllianceStateAllyBJ(Player(14), Player(22), true)
    SetPlayerAllianceStateAllyBJ(Player(18), Player(10), true)
    SetPlayerAllianceStateAllyBJ(Player(18), Player(14), true)
    SetPlayerAllianceStateAllyBJ(Player(18), Player(22), true)
    SetPlayerAllianceStateAllyBJ(Player(22), Player(10), true)
    SetPlayerAllianceStateAllyBJ(Player(22), Player(14), true)
    SetPlayerAllianceStateAllyBJ(Player(22), Player(18), true)
    SetPlayerAllianceStateVisionBJ(Player(10), Player(14), true)
    SetPlayerAllianceStateVisionBJ(Player(10), Player(18), true)
    SetPlayerAllianceStateVisionBJ(Player(10), Player(22), true)
    SetPlayerAllianceStateVisionBJ(Player(14), Player(10), true)
    SetPlayerAllianceStateVisionBJ(Player(14), Player(18), true)
    SetPlayerAllianceStateVisionBJ(Player(14), Player(22), true)
    SetPlayerAllianceStateVisionBJ(Player(18), Player(10), true)
    SetPlayerAllianceStateVisionBJ(Player(18), Player(14), true)
    SetPlayerAllianceStateVisionBJ(Player(18), Player(22), true)
    SetPlayerAllianceStateVisionBJ(Player(22), Player(10), true)
    SetPlayerAllianceStateVisionBJ(Player(22), Player(14), true)
    SetPlayerAllianceStateVisionBJ(Player(22), Player(18), true)
    SetPlayerTeam(Player(4), 2)
    SetPlayerState(Player(4), PLAYER_STATE_ALLIED_VICTORY, 1)
    SetPlayerTeam(Player(5), 2)
    SetPlayerState(Player(5), PLAYER_STATE_ALLIED_VICTORY, 1)
    SetPlayerTeam(Player(6), 2)
    SetPlayerState(Player(6), PLAYER_STATE_ALLIED_VICTORY, 1)
    SetPlayerTeam(Player(7), 2)
    SetPlayerState(Player(7), PLAYER_STATE_ALLIED_VICTORY, 1)
    SetPlayerTeam(Player(8), 2)
    SetPlayerState(Player(8), PLAYER_STATE_ALLIED_VICTORY, 1)
    SetPlayerTeam(Player(9), 2)
    SetPlayerState(Player(9), PLAYER_STATE_ALLIED_VICTORY, 1)
    SetPlayerAllianceStateAllyBJ(Player(4), Player(5), true)
    SetPlayerAllianceStateAllyBJ(Player(4), Player(6), true)
    SetPlayerAllianceStateAllyBJ(Player(4), Player(7), true)
    SetPlayerAllianceStateAllyBJ(Player(4), Player(8), true)
    SetPlayerAllianceStateAllyBJ(Player(4), Player(9), true)
    SetPlayerAllianceStateAllyBJ(Player(5), Player(4), true)
    SetPlayerAllianceStateAllyBJ(Player(5), Player(6), true)
    SetPlayerAllianceStateAllyBJ(Player(5), Player(7), true)
    SetPlayerAllianceStateAllyBJ(Player(5), Player(8), true)
    SetPlayerAllianceStateAllyBJ(Player(5), Player(9), true)
    SetPlayerAllianceStateAllyBJ(Player(6), Player(4), true)
    SetPlayerAllianceStateAllyBJ(Player(6), Player(5), true)
    SetPlayerAllianceStateAllyBJ(Player(6), Player(7), true)
    SetPlayerAllianceStateAllyBJ(Player(6), Player(8), true)
    SetPlayerAllianceStateAllyBJ(Player(6), Player(9), true)
    SetPlayerAllianceStateAllyBJ(Player(7), Player(4), true)
    SetPlayerAllianceStateAllyBJ(Player(7), Player(5), true)
    SetPlayerAllianceStateAllyBJ(Player(7), Player(6), true)
    SetPlayerAllianceStateAllyBJ(Player(7), Player(8), true)
    SetPlayerAllianceStateAllyBJ(Player(7), Player(9), true)
    SetPlayerAllianceStateAllyBJ(Player(8), Player(4), true)
    SetPlayerAllianceStateAllyBJ(Player(8), Player(5), true)
    SetPlayerAllianceStateAllyBJ(Player(8), Player(6), true)
    SetPlayerAllianceStateAllyBJ(Player(8), Player(7), true)
    SetPlayerAllianceStateAllyBJ(Player(8), Player(9), true)
    SetPlayerAllianceStateAllyBJ(Player(9), Player(4), true)
    SetPlayerAllianceStateAllyBJ(Player(9), Player(5), true)
    SetPlayerAllianceStateAllyBJ(Player(9), Player(6), true)
    SetPlayerAllianceStateAllyBJ(Player(9), Player(7), true)
    SetPlayerAllianceStateAllyBJ(Player(9), Player(8), true)
    SetPlayerAllianceStateVisionBJ(Player(4), Player(5), true)
    SetPlayerAllianceStateVisionBJ(Player(4), Player(6), true)
    SetPlayerAllianceStateVisionBJ(Player(4), Player(7), true)
    SetPlayerAllianceStateVisionBJ(Player(4), Player(8), true)
    SetPlayerAllianceStateVisionBJ(Player(4), Player(9), true)
    SetPlayerAllianceStateVisionBJ(Player(5), Player(4), true)
    SetPlayerAllianceStateVisionBJ(Player(5), Player(6), true)
    SetPlayerAllianceStateVisionBJ(Player(5), Player(7), true)
    SetPlayerAllianceStateVisionBJ(Player(5), Player(8), true)
    SetPlayerAllianceStateVisionBJ(Player(5), Player(9), true)
    SetPlayerAllianceStateVisionBJ(Player(6), Player(4), true)
    SetPlayerAllianceStateVisionBJ(Player(6), Player(5), true)
    SetPlayerAllianceStateVisionBJ(Player(6), Player(7), true)
    SetPlayerAllianceStateVisionBJ(Player(6), Player(8), true)
    SetPlayerAllianceStateVisionBJ(Player(6), Player(9), true)
    SetPlayerAllianceStateVisionBJ(Player(7), Player(4), true)
    SetPlayerAllianceStateVisionBJ(Player(7), Player(5), true)
    SetPlayerAllianceStateVisionBJ(Player(7), Player(6), true)
    SetPlayerAllianceStateVisionBJ(Player(7), Player(8), true)
    SetPlayerAllianceStateVisionBJ(Player(7), Player(9), true)
    SetPlayerAllianceStateVisionBJ(Player(8), Player(4), true)
    SetPlayerAllianceStateVisionBJ(Player(8), Player(5), true)
    SetPlayerAllianceStateVisionBJ(Player(8), Player(6), true)
    SetPlayerAllianceStateVisionBJ(Player(8), Player(7), true)
    SetPlayerAllianceStateVisionBJ(Player(8), Player(9), true)
    SetPlayerAllianceStateVisionBJ(Player(9), Player(4), true)
    SetPlayerAllianceStateVisionBJ(Player(9), Player(5), true)
    SetPlayerAllianceStateVisionBJ(Player(9), Player(6), true)
    SetPlayerAllianceStateVisionBJ(Player(9), Player(7), true)
    SetPlayerAllianceStateVisionBJ(Player(9), Player(8), true)
end

function InitAllyPriorities()
    SetStartLocPrioCount(0, 2)
    SetStartLocPrio(0, 0, 1, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(0, 1, 3, MAP_LOC_PRIO_HIGH)
    SetStartLocPrioCount(1, 1)
    SetStartLocPrio(1, 0, 0, MAP_LOC_PRIO_HIGH)
    SetStartLocPrioCount(2, 1)
    SetStartLocPrio(2, 0, 3, MAP_LOC_PRIO_HIGH)
    SetStartLocPrioCount(3, 2)
    SetStartLocPrio(3, 0, 0, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(3, 1, 2, MAP_LOC_PRIO_LOW)
    SetStartLocPrioCount(4, 5)
    SetStartLocPrio(4, 0, 5, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(4, 1, 6, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(4, 2, 7, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(4, 3, 8, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(4, 4, 9, MAP_LOC_PRIO_HIGH)
    SetStartLocPrioCount(5, 5)
    SetStartLocPrio(5, 0, 4, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(5, 1, 6, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(5, 2, 7, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(5, 3, 8, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(5, 4, 9, MAP_LOC_PRIO_HIGH)
    SetStartLocPrioCount(6, 5)
    SetStartLocPrio(6, 0, 4, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(6, 1, 5, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(6, 2, 7, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(6, 3, 8, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(6, 4, 9, MAP_LOC_PRIO_HIGH)
    SetStartLocPrioCount(7, 5)
    SetStartLocPrio(7, 0, 4, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(7, 1, 5, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(7, 2, 6, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(7, 3, 8, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(7, 4, 9, MAP_LOC_PRIO_HIGH)
    SetStartLocPrioCount(8, 5)
    SetStartLocPrio(8, 0, 4, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(8, 1, 5, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(8, 2, 6, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(8, 3, 7, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(8, 4, 9, MAP_LOC_PRIO_HIGH)
    SetStartLocPrioCount(9, 5)
    SetStartLocPrio(9, 0, 4, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(9, 1, 5, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(9, 2, 6, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(9, 3, 7, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(9, 4, 8, MAP_LOC_PRIO_HIGH)
    SetStartLocPrioCount(10, 6)
    SetStartLocPrio(10, 0, 0, MAP_LOC_PRIO_LOW)
    SetStartLocPrio(10, 1, 1, MAP_LOC_PRIO_LOW)
    SetStartLocPrio(10, 2, 2, MAP_LOC_PRIO_LOW)
    SetStartLocPrio(10, 3, 3, MAP_LOC_PRIO_LOW)
    SetStartLocPrio(10, 4, 12, MAP_LOC_PRIO_LOW)
    SetStartLocPrio(10, 5, 13, MAP_LOC_PRIO_LOW)
    SetEnemyStartLocPrioCount(10, 6)
    SetEnemyStartLocPrio(10, 0, 0, MAP_LOC_PRIO_LOW)
    SetEnemyStartLocPrio(10, 1, 1, MAP_LOC_PRIO_LOW)
    SetEnemyStartLocPrio(10, 2, 2, MAP_LOC_PRIO_LOW)
    SetEnemyStartLocPrio(10, 3, 3, MAP_LOC_PRIO_LOW)
    SetEnemyStartLocPrio(10, 4, 12, MAP_LOC_PRIO_LOW)
    SetEnemyStartLocPrio(10, 5, 13, MAP_LOC_PRIO_LOW)
    SetStartLocPrioCount(11, 4)
    SetStartLocPrio(11, 0, 0, MAP_LOC_PRIO_LOW)
    SetStartLocPrio(11, 1, 1, MAP_LOC_PRIO_LOW)
    SetStartLocPrio(11, 2, 2, MAP_LOC_PRIO_LOW)
    SetStartLocPrio(11, 3, 3, MAP_LOC_PRIO_LOW)
    SetEnemyStartLocPrioCount(11, 4)
    SetEnemyStartLocPrio(11, 0, 0, MAP_LOC_PRIO_LOW)
    SetEnemyStartLocPrio(11, 1, 1, MAP_LOC_PRIO_LOW)
    SetEnemyStartLocPrio(11, 2, 2, MAP_LOC_PRIO_LOW)
    SetEnemyStartLocPrio(11, 3, 3, MAP_LOC_PRIO_LOW)
    SetStartLocPrioCount(12, 10)
    SetStartLocPrio(12, 0, 0, MAP_LOC_PRIO_LOW)
    SetStartLocPrio(12, 1, 1, MAP_LOC_PRIO_LOW)
    SetStartLocPrio(12, 2, 2, MAP_LOC_PRIO_LOW)
    SetStartLocPrio(12, 3, 3, MAP_LOC_PRIO_LOW)
    SetStartLocPrio(12, 4, 4, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(12, 5, 5, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(12, 6, 6, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(12, 7, 7, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(12, 8, 8, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(12, 9, 9, MAP_LOC_PRIO_HIGH)
    SetEnemyStartLocPrioCount(12, 7)
    SetEnemyStartLocPrio(12, 0, 0, MAP_LOC_PRIO_LOW)
    SetEnemyStartLocPrio(12, 1, 1, MAP_LOC_PRIO_LOW)
    SetEnemyStartLocPrio(12, 2, 2, MAP_LOC_PRIO_LOW)
    SetEnemyStartLocPrio(12, 3, 3, MAP_LOC_PRIO_LOW)
    SetEnemyStartLocPrio(12, 4, 4, MAP_LOC_PRIO_LOW)
    SetEnemyStartLocPrio(12, 5, 6, MAP_LOC_PRIO_LOW)
    SetEnemyStartLocPrio(12, 6, 9, MAP_LOC_PRIO_LOW)
    SetEnemyStartLocPrioCount(13, 5)
    SetEnemyStartLocPrio(13, 0, 4, MAP_LOC_PRIO_LOW)
    SetEnemyStartLocPrio(13, 1, 5, MAP_LOC_PRIO_LOW)
    SetEnemyStartLocPrio(13, 2, 7, MAP_LOC_PRIO_LOW)
    SetEnemyStartLocPrio(13, 3, 8, MAP_LOC_PRIO_LOW)
    SetEnemyStartLocPrio(13, 4, 9, MAP_LOC_PRIO_LOW)
end

function main()
    SetCameraBounds(-7424.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), -7680.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM), 7424.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), 7168.0 - GetCameraMargin(CAMERA_MARGIN_TOP), -7424.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), 7168.0 - GetCameraMargin(CAMERA_MARGIN_TOP), 7424.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), -7680.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM))
    SetDayNightModels("Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl", "Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl")
    NewSoundEnvironment("Default")
    SetAmbientDaySound("CityScapeDay")
    SetAmbientNightSound("CityScapeNight")
    SetMapMusic("Music", true, 0)
    CreateAllUnits()
    InitBlizzard()
    InitGlobals()
    InitCustomTriggers()
    RunInitializationTriggers()
end

function config()
    SetMapName("TRIGSTR_001")
    SetMapDescription("TRIGSTR_003")
    SetPlayers(14)
    SetTeams(14)
    SetGamePlacement(MAP_PLACEMENT_TEAMS_TOGETHER)
    DefineStartLocation(0, -1728.0, -5952.0)
    DefineStartLocation(1, -4352.0, -6464.0)
    DefineStartLocation(2, 4800.0, -6144.0)
    DefineStartLocation(3, 1152.0, -5824.0)
    DefineStartLocation(4, 1152.0, -256.0)
    DefineStartLocation(5, 1152.0, -256.0)
    DefineStartLocation(6, 1152.0, -256.0)
    DefineStartLocation(7, 1152.0, -256.0)
    DefineStartLocation(8, 1152.0, -256.0)
    DefineStartLocation(9, 1152.0, -256.0)
    DefineStartLocation(10, -5248.0, 4608.0)
    DefineStartLocation(11, -6016.0, 6016.0)
    DefineStartLocation(12, -4160.0, 6080.0)
    DefineStartLocation(13, -2560.0, 5696.0)
    InitCustomPlayerSlots()
    InitCustomTeams()
    InitAllyPriorities()
end

