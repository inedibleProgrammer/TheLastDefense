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