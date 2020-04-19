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