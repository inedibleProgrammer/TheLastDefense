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

function this.Command_PrintAbominations()
  AbominationManager.PrintAbominationNames()
end

function this.Command_PrintDefenders()
  DefenderManager.PrintDefenderNames()
end

function this.Command_PrintGameParameters()
  TheLastDefense.PrintGameParameters()
end