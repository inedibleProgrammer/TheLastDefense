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