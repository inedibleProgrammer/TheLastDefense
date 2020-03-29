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