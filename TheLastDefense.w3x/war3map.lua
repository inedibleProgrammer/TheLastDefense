gg_trg_Upgrades = nil
gg_trg_KillRandomUnitInGroup = nil
gg_trg_CreateUnitAndAttackGround = nil
gg_trg_Melee_Initialization = nil
gg_trg_CallInit = nil
gg_trg_HealUnit = nil
gg_unit_nten_0015 = nil
gg_trg_camera = nil
gg_trg_AUnitDies = nil
gg_trg_ItemTesting = nil
function InitGlobals()
end

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
    local attemptCounter = 10

    -- if(gameParameters.level < 3) then -- Trying to help with lag
    --   attemptCounter = 0
    -- end

    -- Select a random unit that is not a hero, and meets the level restraint:
    while( ((isHero == true) or (levelRestraint == true)) and (attemptCounter >= 0) ) do
      local r = GetRandomInt(1, #AllUnitList)

      isHero = IsHeroUnitId(FourCC(AllUnitList[r]))
      levelRestraint = (GetFoodUsed(FourCC(AllUnitList[r])) > gameParameters.level)

      if(isHero or levelRestraint) then
        -- Do nothing
      else
        local u = CreateUnit(this.player, FourCC(AllUnitList[r]), this.spawnPoint.x, this.spawnPoint.y, 0.0)
        this.ApplyUnitModifications(u, gameParameters)
      end

      -- if( (IsHeroUnitId(FourCC(AllUnitList[r]))) or (GetFoodUsed(FourCC(AllUnitList[r])) > gameParameters.level) ) then
      --   -- Do nothing
      -- else
      --   local u = CreateUnit(this.player, FourCC(AllUnitList[r]), this.spawnPoint.x, this.spawnPoint.y, 0.0)
      --   this.ApplyUnitModifications(u, gameParameters)
      -- end
      -- local u = CreateUnit(this.player, FourCC(AllUnitList[r]), this.spawnPoint.x, this.spawnPoint.y, 0.0)

      -- Conditions for an undesirable unit:
      -- isHero = IsHeroUnitId(GetUnitTypeId(u))
      -- levelRestraint = (BlzGetUnitMaxHP(u) > (gameParameters.level * gameParameters.healthMultiplier))

      -- If the unit is desirable, remove it.
      -- if(levelRestraint or isHero) then
      --   RemoveUnit(u)
      -- end

      -- this.ApplyUnitModifications(u, gameParameters)

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
    or commandData.commandingPlayerName == "MasterLich"
    or commandData.commandingPlayerName == "MasterLich#11192")
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
  elseif(commandData.tokens[2] == "ally") then
    this.Command_Ally(commandData)
  elseif(commandData.tokens[2] == "unally") then
    this.Command_Unally(commandData)
  elseif(commandData.tokens[2] == "vision") then
    this.Command_Vision(commandData)
  elseif(commandData.tokens[2] == "unvision") then
    this.Command_Unvision(commandData)
  elseif(commandData.tokens[2] == "cam") then
    this.Command_CameraAdjust(commandData)
  elseif(commandData.tokens[2] == "shop") then
    TheLastDefense.ViewShopItems(commandData)
  elseif(commandData.tokens[2] == "buy") then
    TheLastDefense.BuyShopItem(commandData)
  elseif(commandData.tokens[2] == "abominations") then
    this.Command_PrintAbominations()
  elseif(commandData.tokens[2] == "defenders") then
    this.Command_PrintDefenders()
  elseif(commandData.tokens[2] == "parameters") then
    this.Command_PrintGameParameters()
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
  local page = 1
  if(commandData.tokens[3] == "2") then
    page = 2
  end
  ColorActions.ShowColors(commandData.commandingPlayer, page)
end

--[[ ALLIANCE COMMANDS ]]
-- This function can be used for:
  -- Ally
  -- Unally
  -- Vision
  -- Unvision
function this.PlayerAllianceFilter(commandData)
  local doPlayersPass = false

  local otherPlayerColor = commandData.tokens[3]
  local otherPlayerNumber = ColorActions.ColorStringToNumber(otherPlayerColor)

  if( not(otherPlayerNumber == nil) ) then
    -- ColorActions.ColorStringToNumber returns based off of 1-indexing
    otherPlayerNumber = otherPlayerNumber - 1

    local otherPlayer = Player(otherPlayerNumber)

    if( not(commandData.commandingPlayer == otherPlayer) ) then
      commandData.otherPlayer = otherPlayer
      doPlayersPass = true
    end
  end

  return doPlayersPass
end

function this.Command_Ally(commandData)
  if(this.PlayerAllianceFilter(commandData)) then
    SetPlayerAlliance(commandData.commandingPlayer, commandData.otherPlayer, ALLIANCE_PASSIVE, true)
  end
end

function this.Command_Unally(commandData)
  if(this.PlayerAllianceFilter(commandData)) then
    SetPlayerAlliance(commandData.commandingPlayer, commandData.otherPlayer, ALLIANCE_PASSIVE, false)
  end
end

function this.Command_Vision(commandData)
  if(this.PlayerAllianceFilter(commandData)) then
    SetPlayerAlliance(commandData.commandingPlayer, commandData.otherPlayer, ALLIANCE_SHARED_VISION, true)
  end
end

function this.Command_Unvision(commandData)
  if(this.PlayerAllianceFilter(commandData)) then
    SetPlayerAlliance(commandData.commandingPlayer, commandData.otherPlayer, ALLIANCE_SHARED_VISION, false)
  end  
end

--[[ END ALLIANCE COMMANDS ]]

function this.Command_CameraAdjust(commandData)
  local distance = tonumber(commandData.tokens[3])
  if( not(distance == nil) ) then
    if( (distance >= 500) and (distance <= 3000) ) then
      SetCameraFieldForPlayer(commandData.commandingPlayer, CAMERA_FIELD_TARGET_DISTANCE, distance, 1.00)
    end
  end
end


--[[ GAME SPECIFIC COMMANDS ]]
-- I need to make it so commands can be added externally.
function this.Command_PrintAbominations()
  AbominationManager.PrintAbominationNames()
end

function this.Command_PrintDefenders()
  DefenderManager.PrintDefenderNames()
end

function this.Command_PrintGameParameters()
  TheLastDefense.PrintGameParameters()
end


--[[ END GAME SPECIFIC COMMANDS ]]



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
  -- print("Init Start")

  --print("loading minimap")
  xpcall(BlzChangeMinimapTerrainTex("war3mapImported\\castle.blp"), print)
  --print("end loading minimap")

  --print("GameClockInit Start")
  xpcall(GameClock.Init, print)
  --print("GameClockInit End")

  --print("CommandManagerInit Start")
  xpcall(CommandManager.Init, print)
  --print("CommandManagerInit End")

  --print("UnitList_Init start")
  xpcall(UnitList_Init, print)
  --print("UnitList_Init end")

  --print("UpgradeList_Init start")
  xpcall(UpgradeList_Init, print)
  --print("UpgradeList_Init end")

  --print("ItemList_Init start")
  xpcall(ItemList_Init, print)
  --print("ItemList_Init end")

  -- print("TestManager_Init start")
  xpcall(TestManager.Test_Init, print)
  -- print("TestManager_Init end")

  --print("AbominationManagerInit start")
  xpcall(AbominationManager.Init, print)
  --print("AbominationManagerInit end")

  --print("DefenderManagerInit start")
  xpcall(DefenderManager.Init, print)
  --print("DefenderManagerInit end")

  --print("MultiboardManagerInit start")
  xpcall(MultiboardManager.Init, print)
  --print("MultiboardManagerInit end")

  --print("TheLastDefenseInit start")
  xpcall(TheLastDefense.Init, print)
  --print("TheLastDefenseInit end")

  -- print("Init End")
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
MultiboardManager = {}

local this = MultiboardManager

this.MultiboardList = {}

local Multiboard = {}

--[[ Definition of a multiboard: ]]
function Multiboard.Create(title, nRows, nColumns)
  local this = {}
  this.title = title
  this.nRows = nRows
  this.nColumns = nColumns
  this.initialized = false
  this.board = nil

  function this.Initialize()
    this.initialized = true
    this.board = CreateMultiboard()

    MultiboardSetRowCount(this.board, this.nColumns)
    MultiboardSetColumnCount(this.board, this.nRows)
    MultiboardSetTitleText(this.board, this.title)
  end

  function this.Terminate()

  end

  function this.SetItem(row, column, text)
    local mbi = MultiboardGetItem(this.board, row, column)
      MultiboardSetItemValue(this.board, text)
      MultiboardReleaseItem(this.board)
    mbi = nil
  end

  function this.SetStyle(row, column, width)
    local mbi = MultiboardGetItem(this.board, row, column)
      MultiboardSetItemStyle(mbi, true, false)
      MultiboardSetItemWidth(mbi, width)
      MultiboardReleaseItem(mbi)
    mbi = nil
  end

  function this.Display(show)
    MultiboardDisplay(this.board, show)
  end

  function this.Minimize(show)
    MultiboardMinimize(this.board, show)
  end




  return this
end

-- End definition of multiboard

function this.Init()
  -- Nothing to do here?
  print("MultiboardManager Init")
end

function this.GetBoard(title, nRows, nColumns)
  -- local m = Multiboard.Create("MY_FIRST_MULTIBOARD", 4, 2)
  local m = Multiboard.Create(title, nRows, nColumns)
  return m
end
TestManager = {}

local this = TestManager


function this.Test_Init()
  -- Tests you want to run immediately:
  -- this.PrintRuler()
  
  -- this.Test_ItemDescription()
  this.Test_ItemThings()
end

function this.PrintRuler()
  DisplayTimedTextToPlayer(Player(0), 0.0, 0.5, 500, "01234567890123456789012345678901234567890123456789012345678")
end


function this.Test_HumanUnits()
  for k,v in ipairs(AllRacesUnitList) do
    CreateNUnitsAtLoc(1, FourCC(v), Player(0), GetRectCenter(GetPlayableMapRect()), bj_UNIT_FACING)
  end
end

function this.Test_ItemDescription()
  local i = CreateItem(FourCC("afac"), 0.0, 0.0)
  print(BlzGetItemDescription(i))
  RemoveItem(i)
  i = nil
end

function this.Test_ItemThings()
  print(TheLastDefense.GetItemPrice("arsh"))
end
--[[ This module handles game specific logic ]]

TheLastDefense = {}

local this = TheLastDefense

this.gameParameters = {}
this.gameParameters.spawnPeriod = 10 -- Seconds
this.gameParameters.burstPeriod = 30 -- Seconds
this.gameParameters.upgradePeriod = 180 -- Seconds
this.gameParameters.healthMultiplier = 100 -- HP, Are there units with less than this * level?
this.gameParameters.level = 0 -- Scale monster spawning
this.gameParameters.upgradesFinished = false
this.gameParameters.unitSteroidEnabled = false -- Start adding HP to units
this.gameParameters.unitSteroidCounter = 1 -- Add 100 * this counter HP to units
this.gameParameters.shopUpdatePeriod = 30 -- Seconds

this.multiboard = nil
this.multiboard_initialized = false
this.multiboard_rows = 0

this.finalBoss = {}

this.shopItemList = {}
this.shopItemList.itemCount = 4 -- This should probably never change from 4, since you can only fit 4 items on a screen
--[[ Definition of a shop item: ]]
this.shopItem = {}

function this.shopItem.Create(ID, price)
  local this = {}
  this.ID = ID
  this.price = price

  return this
end
-- End definition of a shop item

function this.Init()
  --[[ Initialize Timer: ]]
  this.clockTrigger = CreateTrigger()
  TriggerAddAction(this.clockTrigger, this.TheLastDefenseHandler)
  TriggerRegisterTimerEvent(this.clockTrigger, 1.00, true)

  --[[ Initialize Trigger that counts kills: ]]
  this.killCountingTrigger = CreateTrigger()
  TriggerAddAction(this.killCountingTrigger, this.KillCountingHandler)
  for k,v in ipairs(AbominationManager.AbominationList) do
    TriggerRegisterPlayerUnitEvent(this.killCountingTrigger, v.player, EVENT_PLAYER_UNIT_DEATH, nil)
  end

    --[[ Setup the trigger that handles when players leave the game: ]]
    this.playerLeavingTrigger = CreateTrigger()
    TriggerAddAction(this.playerLeavingTrigger, this.PlayerLeavingHandler)
    for k,v in ipairs(DefenderManager.DefenderList) do
      TriggerRegisterPlayerEvent(this.playerLeavingTrigger, v.player, EVENT_PLAYER_LEAVE)
    end

  --[[ Load AI for the defenders that are AI controlled: ]]
  for k,v in ipairs(DefenderManager.DefenderList) do
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

  this.InitializeFinalBoss()

  -- Assign abominations their targets
  this.InitializeAbominations()

  -- Get a multiboard:
  -- this.multiboard = MultiboardManager.GetBoard("MyFirstBoard", 1, 1) 
end

-- This should be turned into a state machine.
function this.TheLastDefenseHandler()
  local currentElapsedSeconds = GameClock.GetElapsedSeconds()

  -- Initialize the multiboard:
  if( (ModuloInteger(currentElapsedSeconds, 5) == 0) and not(this.multiboard_initialized) ) then
    print("Creating Board")
    this.multiboard_initialized = true
    
    this.multiboard = CreateMultiboardBJ(2, DefenderManager.defenderCount + 1, "ScoreBoard")
    MultiboardMinimizeBJ(true, this.multiboard)
    MultiboardSetItemStyleBJ(this.multiboard, 0, 0, true, false)
    MultiboardSetItemWidthBJ(this.multiboard, 0, 0, 10)

    for k,v in ipairs(DefenderManager.DefenderList) do
      MultiboardSetItemValueBJ(this.multiboard, 1, k, "|c" .. ColorList[ColorActions.NumberToColorString(GetPlayerId(v.player) + 1)].hex_code ..GetPlayerName(v.player) .. "|r")
      this.multiboard_rows = this.multiboard_rows + 1
    end

    MultiboardSetItemValueBJ(this.multiboard, 1, this.multiboard_rows + 1, "|c" .. ColorList.gold.hex_code .. "GameTime:" .. "|r")

    -- MultiboardSetItemValueBJ(this.multiboard, 1, 1, "Test")
    -- MultiboardSetItemValueBJ(this.multiboard, 2, 1, "|c" .. ColorList.light_blue.hex_code .. "Test2" .. "|r")
    -- this.multiboard.Initialize()
    -- this.multiboard.Display(true)
    -- this.multiboard.Minimize(true)
    
    -- this.multiboard.SetStyle(0, 0, 0.14)
    -- this.multiboard.SetItem(0, 0, "|c" .. ColorList.light_blue.hex_code .. "Test" .. "|r")

    -- MultiboardSetItemStyleBJ(this.multiboard.board, 1, 1, true, false)
    -- MultiboardSetItemWidthBJ(this.multiboard.board, )
    
  end

  -- Update ScoreBoard:

  if(this.multiboard_initialized) then
    for k,v in ipairs(DefenderManager.DefenderList) do
      MultiboardSetItemValueBJ(this.multiboard, 2, k, tostring(v.killCount))
    end
    MultiboardSetItemValueBJ(this.multiboard, 2, this.multiboard_rows + 1, tostring(GameClock.hours) .. ":" .. tostring(GameClock.minutes) .. ":" .. tostring(GameClock.seconds))
  end

  if(ModuloInteger(currentElapsedSeconds, this.gameParameters.upgradePeriod) == 0) then
    this.gameParameters.level = this.gameParameters.level + 1

    if(this.gameParameters.unitSteroidEnabled) then
      this.gameParameters.unitSteroidCounter = this.gameParameters.unitSteroidCounter + 1
    end
  end

  if(ModuloInteger(currentElapsedSeconds, this.gameParameters.spawnPeriod) == 0) then
    AbominationManager.AbominationSpawn(this.gameParameters)
  end

  if(ModuloInteger(currentElapsedSeconds, this.gameParameters.shopUpdatePeriod) == 0) then
    print("Shop Items Updated")
    this.UpdateShopItems()
  end

  if(ModuloInteger(currentElapsedSeconds, this.gameParameters.burstPeriod) == 0) then
    AbominationManager.AbominationSpawn(this.gameParameters)
    AbominationManager.AbominationSpawn(this.gameParameters)
    AbominationManager.AbominationSpawn(this.gameParameters)
  end

  -- After a certain point, we should ramp up the difficulty:
  if( (this.gameParameters.level == 5) and not(this.gameParameters.upgradesFinished) ) then
    this.gameParameters.healthMultiplier = 200
    this.DoUpgrades()
  end

  -- Time to apply steroids?
  if( this.gameParameters.level == 7 and not(this.gameParameters.unitSteroidEnabled) ) then
    this.gameParameters.unitSteroidEnabled = true
  end


  -- if a defender has lost all his units he is dead
  this.DetermineLivingDefenders()

  -- give the respective abomination of a dead defender a new living target defender
  this.UpdateAbominationTargets()
end

function this.KillCountingHandler()
  local p = GetOwningPlayer(GetKillingUnit())

  for k,v in ipairs(DefenderManager.DefenderList) do
    if(v.player == p) then
      v.killCount = v.killCount + 1
    end
  end
end

function this.PlayerLeavingHandler()
  -- We want to split his resources up among his allies? TODO
  local p = GetTriggerPlayer()

  print(GetPlayerName(p) .. " has left the game.")
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

  -- Make sure he doesn't get triggered to move..
  this.gameParameters.finalBoss = this.finalBoss.u
end

function this.InitializeAbominations()
  --[[ For every player in the game, there needs to be an abomination targeting that player ]]
  for k,v in ipairs(DefenderManager.DefenderList) do
    AbominationManager.AbominationList[k].active = true
    AbominationManager.AbominationList[k].objectivePoint = v.startingPoint
    AbominationManager.AbominationList[k].targetPlayer = v.player
  end
end

function this.DoUpgrades()
  this.gameParameters.upgradesFinished = true

  for _,abom in ipairs(AbominationManager.AbominationList) do
    for _,upg in ipairs(AllRacesUpgradeList) do
      AddPlayerTechResearched(abom.player, FourCC(upg), 3)
    end
  end
end

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

function this.UpdateShopItems()
  -- First, clear the items in the shop list
  for k,v in ipairs(this.shopItemList) do
    -- this.shopItemList[k] = nil
    table.remove(this.shopItemList)
  end

  -- Now fill the list with random item codes
  for i = 1, this.shopItemList.itemCount do
    local shopItem = {}
    repeat 
      local r = GetRandomInt(1, #AllItemList)
      local ID = AllItemList[r]
      shopItem = this.shopItem.Create(ID, this.GetItemPrice(ID)) -- Maybe I should just get every item price at the beginning of the game and record it.
    until (shopItem.price ~= 0)
    table.insert(this.shopItemList, shopItem)
  end
end

function this.BuyShopItem(commandData)
  local itemToBuyString = commandData.tokens[3]
  local nItemToBuy = 0

  if (itemToBuyString == "1") then nItemToBuy = 1
  elseif (itemToBuyString == "2") then nItemToBuy = 2
  elseif (itemToBuyString == "3") then nItemToBuy = 3
  elseif (itemToBuyString == "4") then nItemToBuy = 4
  else -- do nothing
  end
  print("here1: " .. itemToBuyString .. nItemToBuy)

  -- Don't bother to do anything unless the item to buy makes sense
  if( (1 <= nItemToBuy) and (nItemToBuy <= 4) ) then
    print("here2")
    local dropPoint = {}
    local playerCurrentGold = GetPlayerState(commandData.commandingPlayer, PLAYER_STATE_RESOURCE_GOLD)
    local itemPrice = this.shopItemList[nItemToBuy].price
    print("here3")
    -- Don't bother to do anything unless the player has enough gold
    if(playerCurrentGold >= itemPrice) then
      print("here4")
      SetPlayerState(commandData.commandingPlayer, PLAYER_STATE_RESOURCE_GOLD, playerCurrentGold - itemPrice)

      -- Determine the dropping point
      for k,v in ipairs(DefenderManager.DefenderList) do
        if(v.player == commandData.commandingPlayer) then
          dropPoint = v.startingPoint
        end
      end

      CreateItem(FourCC(this.shopItemList[nItemToBuy].ID), dropPoint.x, dropPoint.y)
    end
  end
end

-- This should get called from the command manager
-- .. I should make it so "commands" can be added to the command manager
-- externally so that it doesn't have to be touched for every specific game.
function this.ViewShopItems(commandData)
  -- Check if they're actually in the right spot (the circle of power of the marketplace)
  -- local buyerPoint = Utility.Point.Create(916.7, -1864)

  if(this.shopItemList[1] == nil) then
    DisplayTimedTextToPlayer(commandData.commandingPlayer, 0.0, 0.0, 30, "Shop is empty")
  else
    for k,v in ipairs(this.shopItemList) do
      local i = CreateItem(FourCC(v.ID), 0.0, 0.0)
        DisplayTimedTextToPlayer(commandData.commandingPlayer, 0.0, 0.0, 30, "===========================================")
        DisplayTimedTextToPlayer(commandData.commandingPlayer, 0.0, 0.0, 30, "|c" .. ColorList.gold.hex_code ..  "Name: " .. "|r" .. GetItemName(i))
        DisplayTimedTextToPlayer(commandData.commandingPlayer, 0.0, 0.0, 30, "|c" .. ColorList.green.hex_code .. "Price: " .. "|r" .. v.price)
        DisplayTimedTextToPlayer(commandData.commandingPlayer, 0.0, 0.0, 30, "Description: " .. BlzGetItemDescription(i))
      RemoveItem(i)
    end
  end
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

function this.UpdateAbominationTargets()
  for k,v in ipairs(AbominationManager.AbominationList) do
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

function this.PrintGameParameters()
  print("P: " .. this.gameParameters.level .. ";" .. tostring(this.gameParameters.upgradesFinished) .. ";" .. tostring(this.gameParameters.unitSteroidEnabled) .. ";" .. this.gameParameters.unitSteroidCounter)
end

function this.InitializeMultiboard()
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
  -- IssueTargetOrder(commandedUnit, "attack", u)
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
    DefineStartLocation(0, -1728.0, -5952.0)
    DefineStartLocation(1, -4352.0, -6464.0)
    DefineStartLocation(2, 4800.0, -6144.0)
    DefineStartLocation(3, 1152.0, -5824.0)
    DefineStartLocation(4, -5248.0, 4608.0)
    DefineStartLocation(5, -6016.0, 6016.0)
    DefineStartLocation(6, -4160.0, 6080.0)
    DefineStartLocation(7, -2560.0, 5696.0)
    InitCustomPlayerSlots()
    InitCustomTeams()
    InitAllyPriorities()
end

