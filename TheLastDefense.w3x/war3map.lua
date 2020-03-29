gg_trg_Melee_Initialization = nil
gg_trg_CallInit = nil
function InitGlobals()
end

AbominationManager = {}

local this = AbominationManager
this.spawnPeriod = 5 -- Seconds
this.upgradePeriod = 300 -- Seconds

-- Definition of Abomination:
local Abomination = {}

function Abomination.Create()
  local this = {}

  function this.DetermineUnit()
    -- Select a random unit
  end


  return this
end
-- End Abomination

function this.Init()
  this.clockTrigger = CreateTrigger()
  TriggerAddAction(this.clockTrigger, this.AbominationHandler)
  TriggerRegisterTimerEvent(this.clockTrigger, 1.00, true)
end

function this.AbominationHandler()
  local currentElapsedSeconds = GameClock.GetElapsedSeconds()
  print(currentElapsedSeconds)
end
ColorActions = {}

function ColorActions.ColorStringToNumber(color)
    if (color == "red") then return 1
    elseif(color == "blue") then return 2
    elseif(color == "teal" or color == "cyan") then return 3
    elseif(color == "purple") then return 4
    elseif(color == "yellow") then return 5
    elseif(color == "orange") then return 6
    elseif(color == "green") then return 7
    elseif(color == "pink") then return 8
    elseif(color == "light_gray" or color == "gray") then return 9
    elseif(color == "light_blue") then return 10
    elseif(color == "dark_green") then return 11
    elseif(color == "brown") then return 12
    elseif(color == "maroon") then return 13
    elseif(color == "navy") then return 14
    elseif(color == "turquoise") then return 15
    elseif(color == "violet") then return 16
    elseif(color == "wheat") then return 17
    elseif(color == "peach") then return 18
    elseif(color == "mint") then return 19
    elseif(color == "lavender") then return 20
    elseif(color == "coal") then return 21
    elseif(color == "snow") then return 22
    elseif(color == "emerald") then return 23
    elseif(color == "peanut") then return 24
    else return nil
    end
end

function ColorActions.NumberToColorString(color)
    if (color == 1) then return "red"
    elseif(color == 2) then return "blue"
    elseif(color == 3) then return "teal"
    elseif(color == 4) then return "purple"
    elseif(color == 5) then return "yellow"
    elseif(color == 6) then return "orange"
    elseif(color == 7) then return "green"
    elseif(color == 8) then return "pink"
    elseif(color == 9) then return "gray"
    elseif(color == 10) then return "light_blue"
    elseif(color == 11) then return "dark_green"
    elseif(color == 12) then return "brown"
    elseif(color == 13) then return "maroon"
    elseif(color == 14) then return "navy"
    elseif(color == 15) then return "turquoise"
    elseif(color == 16) then return "violet"
    elseif(color == 17) then return "wheat"
    elseif(color == 18) then return "peach"
    elseif(color == 19) then return "mint"
    elseif(color == 20) then return "lavender"
    elseif(color == 21) then return "coal"
    elseif(color == 22) then return "snow"
    elseif(color == 23) then return "emerald"
    elseif(color == 24) then return "peanut"
    else return nil
    end
end

-- Preconditions: Page = {1, 2}
function ColorActions.ShowColors(commandingPlayer, page)
-- native DisplayTextToPlayer          takes player toPlayer, real x, real y, string message returns nothing
-- native DisplayTimedTextToPlayer     takes player toPlayer, real x, real y, real duration, string message returns nothing
    local initial_color = 1
    local final_color = 24
    local currentColorText = ""
    if(page == 1) then
        initial_color = 1
        final_color = 13
    elseif(page == 2) then
        initial_color = 14
        final_color = 24
    else
        -- do nothing
    end

    for i = initial_color, final_color do
        currentColorText = ColorActions.NumberToColorString(i)
        DisplayTimedTextToPlayer(commandingPlayer, 0, 0, 15.0,"|c" .. ColorList[currentColorText].hex_code .. currentColorText .. "|r (" .. I2S(i) .. ") : " .. GetPlayerName(Player(i-1)))
    end
end



--===================================================================================================================================================================
--===================================================================================================================================================================
--===================================================================================================================================================================

ColorList = {}

ColorList.red =
{
    text = "red",
    number = 1,
    hex_code = "00FF0303"
}

ColorList.blue =
{
    text = "blue",
    number = 2,
    hex_code = "000042FF"
}

ColorList.teal =
{
    text = "teal",
    number = 3,
    hex_code = "001CE6B9"
}

ColorList.purple =
{
    text = "purple",
    number = 4,
    hex_code = "00540081"
}

ColorList.yellow =
{
    text = "yellow",
    number = 5,
    hex_code = "00FFFC00"
}

ColorList.orange =
{
    text = "orange",
    number = 6,
    hex_code = "00FE8A0E"
}

ColorList.green =
{
    text = "green",
    number = 7,
    hex_code = "0020C000"
}

ColorList.pink =
{
    text = "pink",
    number = 8,
    hex_code = "00E55BB0"
}

ColorList.gray =
{
    text = "gray",
    number = 9,
    hex_code = "00959697"
}

ColorList.light_blue =
{
    text = "light_blue",
    number = 10,
    hex_code = "007EBFF1"
}

ColorList.dark_green =
{
    text = "dark_green",
    number = 11,
    hex_code = "00106246"
}

ColorList.brown =
{
    text = "brown",
    number = 12,
    hex_code = "004E2A04"
}

ColorList.maroon =
{
    text = "maroon",
    number = 13,
    hex_code = "009B0000"
}

ColorList.navy =
{
    text = "navy",
    number = 14,
    hex_code = "000000C3"
}

ColorList.turquoise =
{
    text = "turquoise",
    number = 15,
    hex_code = "0000EAFF"
}

ColorList.violet =
{
    text = "violet",
    number = 16,
    hex_code = "00BE00FE"
}

ColorList.wheat =
{
    text = "wheat",
    number = 17,
    hex_code = "00EBCD87"
}

ColorList.peach =
{
    text = "peach",
    number = 18,
    hex_code = "00F8A48B"
}

ColorList.mint =
{
    text = "mint",
    number = 19,
    hex_code = "00BFFF80"
}

ColorList.lavender =
{
    text = "lavender",
    number = 20,
    hex_code = "00DCB9EB"
}

ColorList.coal =
{
    text = "coal",
    number = 21,
    hex_code = "00282828"
}

ColorList.snow =
{
    text = "snow",
    number = 22,
    hex_code = "00EBF0FF"
}

ColorList.emerald =
{
    text = "emerald",
    number = 23,
    hex_code = "0000781E"
}

ColorList.peanut =
{
    text = "peanut",
    number = 24,
    hex_code = "00A46F33"
}

ColorList.some_weird_green =
{
    text = "some_weird_green",
    number = 25,
    hex_code = "0022744F"
}

ColorList.gold =
{
    text = "gold",
    number = 26,
    hex_code = "00FFD700"
}

ColorList.bright_blue =
{
    text = "bright_blue",
    number = 27,
    hex_code = "0019CAF6"
}
CommandManager = {}

local this = CommandManager

function this.Init()
  -- Initialize trigger
  this.commandTrigger = CreateTrigger()
  TriggerAddAction(this.commandTrigger, this.CommandHandler)
  Utility.TriggerRegisterAllPlayersChat(this.commandTrigger, "-cmd")
end

-- We come here if any player types -cmd
function this.CommandHandler()
  local commandData = {}
  commandData.message = GetEventPlayerChatString()
  commandData.commandingPlayer = GetTriggerPlayer()
  commandData.commandingPlayerName = GetPlayerName(commandData.commandingPlayer)
  commandData.tokens = Utility.MySplit(commandData.message, " ")
  commandData.credentialsVerified = false

  if(commandData.commandingPlayerName == "The_Master_Lich"
    or commandData.commandingPlayerName == "WorldEdit"
    or commandData.commandingPlayerName == "MasterLich")
  then
    commandData.credentialsVerified = true
  end

  if(commandData.tokens[2] == "time") then
    this.Command_Time(commandData)
  elseif(commandData.tokens[2] == "clear") then
    this.Command_Clear()
  elseif(commandData.tokens[2] == "visible") then
    this.Command_Visible(commandData)
  elseif(commandData.tokens[2] == "colors") then
    this.Command_ShowColors(commandData)
  else
    -- Do nothing.
  end
end

function this.Command_Time(commandData)
  local currentTimeString = "|c" .. ColorList.gold.hex_code .. "Time Elapsed: |r" .. I2S(GameClock.hours) .. ":" .. I2S(GameClock.minutes) .. ":" .. I2S(GameClock.seconds)
  DisplayTimedTextToPlayer(commandData.commandingPlayer, 0.00, 0.00, 10, currentTimeString)
end

function this.Command_Clear()
  ClearTextMessages()
end

function this.Command_Visible(commandData)
  if(commandData.credentialsVerified) then
    FogModifierStart(CreateFogModifierRect(commandData.commandingPlayer, FOG_OF_WAR_VISIBLE, GetWorldBounds(), true, true))
  end
end

function this.Command_ShowColors(commandData)
  if(commandData.tokens[3] == "2") then
    ColorActions.ShowColors(commandData.commandingPlayer, 2)
  else
    ColorActions.ShowColors(commandData.commandingPlayer, 1)
  end
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
--[[
  The beginning of everything
]]

function Init()
  print("Init Start")

  print("GameClockInit Start")
  xpcall(GameClock.Init, print)
  print("GameClockInit End")

  print("CommandManagerInit Start")
  xpcall(CommandManager.Init, print)
  print("CommandManagerInit End")

  print("UnitList_Init start")
  xpcall(UnitList_Init, print)
  print("UnitList_Init end")

  -- print("TestManager TestHumanUnits start")
  -- xpcall(TestManager.Test_HumanUnits, print)
  -- print("TestManager TestHumanUnits end")

  print("AbominationManagerInit start")
  xpcall(AbominationManager.Init, print)
  print("AbominationManagerInit end")

  print("Init End")
end

Utility = {}

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
TestManager = {}

local this = TestManager



function this.Test_HumanUnits()
  for k,v in ipairs(AllRacesUnitList) do
    CreateNUnitsAtLoc(1, FourCC(v), Player(0), GetRectCenter(GetPlayableMapRect()), bj_UNIT_FACING)
  end
end

-- CreateNUnitsAtLoc(1, FourCC(unit), Player(0), GetRectCenter(GetPlayableMapRect()), bj_UNIT_FACING)
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

AllRacesUnitList = {}


function UnitList_Init()
  -- Merge the four races into one table:
  Utility.TableMerge(AllRacesUnitList, HumanUnitList)
  Utility.TableMerge(AllRacesUnitList, OrcUnitList)
  Utility.TableMerge(AllRacesUnitList, UndeadUnitList)
  Utility.TableMerge(AllRacesUnitList, NightElfUnitList)
end

function CreateNeutralPassiveBuildings()
    local p = Player(PLAYER_NEUTRAL_PASSIVE)
    local u
    local unitID
    local t
    local life
    u = BlzCreateUnitWithSkin(p, FourCC("ngol"), -6336.0, 256.0, 270.000, FourCC("ngol"))
    SetResourceAmount(u, 100000)
    u = BlzCreateUnitWithSkin(p, FourCC("ngol"), -4864.0, -7040.0, 270.000, FourCC("ngol"))
    SetResourceAmount(u, 100000)
    u = BlzCreateUnitWithSkin(p, FourCC("ngol"), 5056.0, -6912.0, 270.000, FourCC("ngol"))
    SetResourceAmount(u, 100000)
    u = BlzCreateUnitWithSkin(p, FourCC("ngol"), 6528.0, 3328.0, 270.000, FourCC("ngol"))
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
    MeleeStartingAI()
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
    SetPlayerStartLocation(Player(10), 4)
    ForcePlayerStartLocation(Player(10), 4)
    SetPlayerColor(Player(10), ConvertPlayerColor(10))
    SetPlayerRacePreference(Player(10), RACE_PREF_UNDEAD)
    SetPlayerRaceSelectable(Player(10), false)
    SetPlayerController(Player(10), MAP_CONTROL_COMPUTER)
    SetPlayerStartLocation(Player(14), 5)
    ForcePlayerStartLocation(Player(14), 5)
    SetPlayerColor(Player(14), ConvertPlayerColor(14))
    SetPlayerRacePreference(Player(14), RACE_PREF_UNDEAD)
    SetPlayerRaceSelectable(Player(14), false)
    SetPlayerController(Player(14), MAP_CONTROL_COMPUTER)
    SetPlayerStartLocation(Player(18), 6)
    ForcePlayerStartLocation(Player(18), 6)
    SetPlayerColor(Player(18), ConvertPlayerColor(18))
    SetPlayerRacePreference(Player(18), RACE_PREF_UNDEAD)
    SetPlayerRaceSelectable(Player(18), false)
    SetPlayerController(Player(18), MAP_CONTROL_COMPUTER)
    SetPlayerStartLocation(Player(22), 7)
    ForcePlayerStartLocation(Player(22), 7)
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
end

function InitAllyPriorities()
    SetStartLocPrioCount(0, 1)
    SetStartLocPrio(0, 0, 1, MAP_LOC_PRIO_HIGH)
    SetStartLocPrioCount(1, 2)
    SetStartLocPrio(1, 0, 0, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(1, 1, 2, MAP_LOC_PRIO_LOW)
    SetStartLocPrioCount(2, 3)
    SetStartLocPrio(2, 0, 0, MAP_LOC_PRIO_LOW)
    SetStartLocPrio(2, 1, 1, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(2, 2, 3, MAP_LOC_PRIO_HIGH)
    SetStartLocPrioCount(3, 3)
    SetStartLocPrio(3, 0, 0, MAP_LOC_PRIO_LOW)
    SetStartLocPrio(3, 1, 1, MAP_LOC_PRIO_LOW)
    SetStartLocPrio(3, 2, 2, MAP_LOC_PRIO_HIGH)
    SetStartLocPrioCount(4, 6)
    SetStartLocPrio(4, 0, 0, MAP_LOC_PRIO_LOW)
    SetStartLocPrio(4, 1, 1, MAP_LOC_PRIO_LOW)
    SetStartLocPrio(4, 2, 2, MAP_LOC_PRIO_LOW)
    SetStartLocPrio(4, 3, 3, MAP_LOC_PRIO_LOW)
    SetStartLocPrio(4, 4, 6, MAP_LOC_PRIO_LOW)
    SetStartLocPrio(4, 5, 7, MAP_LOC_PRIO_LOW)
    SetEnemyStartLocPrioCount(4, 6)
    SetEnemyStartLocPrio(4, 0, 0, MAP_LOC_PRIO_LOW)
    SetEnemyStartLocPrio(4, 1, 1, MAP_LOC_PRIO_LOW)
    SetEnemyStartLocPrio(4, 2, 2, MAP_LOC_PRIO_LOW)
    SetEnemyStartLocPrio(4, 3, 3, MAP_LOC_PRIO_LOW)
    SetEnemyStartLocPrio(4, 4, 6, MAP_LOC_PRIO_LOW)
    SetEnemyStartLocPrio(4, 5, 7, MAP_LOC_PRIO_LOW)
    SetStartLocPrioCount(5, 4)
    SetStartLocPrio(5, 0, 0, MAP_LOC_PRIO_LOW)
    SetStartLocPrio(5, 1, 1, MAP_LOC_PRIO_LOW)
    SetStartLocPrio(5, 2, 2, MAP_LOC_PRIO_LOW)
    SetStartLocPrio(5, 3, 3, MAP_LOC_PRIO_LOW)
    SetEnemyStartLocPrioCount(5, 4)
    SetEnemyStartLocPrio(5, 0, 0, MAP_LOC_PRIO_LOW)
    SetEnemyStartLocPrio(5, 1, 1, MAP_LOC_PRIO_LOW)
    SetEnemyStartLocPrio(5, 2, 2, MAP_LOC_PRIO_LOW)
    SetEnemyStartLocPrio(5, 3, 3, MAP_LOC_PRIO_LOW)
    SetStartLocPrioCount(6, 4)
    SetStartLocPrio(6, 0, 0, MAP_LOC_PRIO_LOW)
    SetStartLocPrio(6, 1, 1, MAP_LOC_PRIO_LOW)
    SetStartLocPrio(6, 2, 2, MAP_LOC_PRIO_LOW)
    SetStartLocPrio(6, 3, 3, MAP_LOC_PRIO_LOW)
    SetEnemyStartLocPrioCount(6, 4)
    SetEnemyStartLocPrio(6, 0, 0, MAP_LOC_PRIO_LOW)
    SetEnemyStartLocPrio(6, 1, 1, MAP_LOC_PRIO_LOW)
    SetEnemyStartLocPrio(6, 2, 2, MAP_LOC_PRIO_LOW)
    SetEnemyStartLocPrio(6, 3, 3, MAP_LOC_PRIO_LOW)
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
    SetPlayers(8)
    SetTeams(8)
    SetGamePlacement(MAP_PLACEMENT_TEAMS_TOGETHER)
    DefineStartLocation(0, -6144.0, -512.0)
    DefineStartLocation(1, -4352.0, -6464.0)
    DefineStartLocation(2, 4800.0, -6144.0)
    DefineStartLocation(3, 5696.0, 3072.0)
    DefineStartLocation(4, -5248.0, 4608.0)
    DefineStartLocation(5, -6016.0, 6016.0)
    DefineStartLocation(6, -4160.0, 6080.0)
    DefineStartLocation(7, -2560.0, 5696.0)
    InitCustomPlayerSlots()
    InitCustomTeams()
    InitAllyPriorities()
end

