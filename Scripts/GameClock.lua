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

function this.GetElapsedSeconds()
  local hoursToSeconds = this.hours * 3600
  local minutesToSeconds = this.minutes * 60
  local elapsedSeconds = hoursToSeconds + minutesToSeconds + this.seconds
end