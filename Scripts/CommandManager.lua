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