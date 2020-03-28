gg_trg_Melee_Initialization = nil
gg_trg_CallInit = nil
function InitGlobals()
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
  local credentialsVerified = false

  if(commandData.commandingPlayerName == "The_Master_Lich"
    or commandData.commandingPlayerName == "WorldEdit")
  then
    credentialsVerified = true
  end

  if(credentialsVerified) then
    FogModifierStart(CreateFogModifierRect(commandData.commandingPlayer, FOG_OF_WAR_VISIBLE, GetWorldBounds(), true, true))
    --CreateFogModifierRectBJ(true, commandData.commandingPlayer, FOG_OF_WAR_VISIBLE, GetPlayableMapRect())
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
end

function this.GetTime()
  local t = {}
  t.hours = this.hours
  t.minutes = this.minutes
  t.seconds = this.seconds
  return t
end
--[[
  The beginning of everything
]]

function Init()
  BJDebugMsg("Init Start")
  GameClock.Init()
  CommandManager.Init()
  BJDebugMsg("Init End")
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
    SetPlayerRacePreference(Player(0), RACE_PREF_HUMAN)
    SetPlayerRaceSelectable(Player(0), true)
    SetPlayerController(Player(0), MAP_CONTROL_USER)
end

function InitCustomTeams()
    SetPlayerTeam(Player(0), 0)
end

function main()
    SetCameraBounds(-7424.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), -7680.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM), 7424.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), 7168.0 - GetCameraMargin(CAMERA_MARGIN_TOP), -7424.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), 7168.0 - GetCameraMargin(CAMERA_MARGIN_TOP), 7424.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), -7680.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM))
    SetDayNightModels("Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl", "Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl")
    NewSoundEnvironment("Default")
    SetAmbientDaySound("CityScapeDay")
    SetAmbientNightSound("CityScapeNight")
    SetMapMusic("Music", true, 0)
    InitBlizzard()
    InitGlobals()
    InitCustomTriggers()
    RunInitializationTriggers()
end

function config()
    SetMapName("TRIGSTR_001")
    SetMapDescription("TRIGSTR_003")
    SetPlayers(1)
    SetTeams(1)
    SetGamePlacement(MAP_PLACEMENT_USE_MAP_SETTINGS)
    DefineStartLocation(0, -5376.0, 1984.0)
    InitCustomPlayerSlots()
    SetPlayerSlotAvailable(Player(0), MAP_CONTROL_USER)
    InitGenericPlayerSlots()
end

