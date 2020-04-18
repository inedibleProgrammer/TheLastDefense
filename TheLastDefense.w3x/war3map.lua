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
--[[ The beginning of everything ]]

function Init()
  xpcall(CommandManager.Init("-c"), print)

  xpcall(ColorManager.Init, print)

  xpcall(GameClock.Init, print)

  xpcall(PlayerManager.Init, print)
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
    u = BlzCreateUnitWithSkin(p, FourCC("nmrk"), 896.0, -1600.0, 270.000, FourCC("nmrk"))
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

