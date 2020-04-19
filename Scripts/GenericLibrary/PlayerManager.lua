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