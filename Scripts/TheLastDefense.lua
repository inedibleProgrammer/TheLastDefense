--[[ This module handles game specific logic ]]

TheLastDefense = {}

local this = TheLastDefense


function this.Init()
  this.InitializeAbominations()
end


function this.InitializeAbominations()
  --[[ For every player in the game, there needs to be an abomination targeting that player ]]
  for k,v in ipairs(DefenderManager.DefenderList) do
    AbominationManager.AbominationList[k].active = true
    AbominationManager.AbominationList[k].objectivePoint = v.startingPoint
    AbominationManager.AbominationList[k].targetPlayer = v.player
  end
end