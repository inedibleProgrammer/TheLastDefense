--[[ This module handles game specific logic ]]

TheLastDefense = {}

local this = TheLastDefense

this.gameParameters = {}
this.gameParameters.nSpawnCount = 1 -- Number of units to spawn each spawn tick
this.gameParameters.spawnPeriod = 10 -- Seconds
this.gameParameters.nBurstCount = 4 -- Number of units to spawn each burst tick
this.gameParameters.burstPeriod = 30 -- Seconds
this.gameParameters.upgradePeriod = 300 -- Seconds
this.gameParameters.healthMultiplier = 100 -- HP, Are there units with less than this * level?
this.gameParameters.level = 0 -- Scale monster spawning
this.gameParameters.upgradesFinished = false
this.gameParameters.unitSteroidEnabled = false -- Start adding HP to units
this.gameParameters.unitSteroidCounter = 1 -- Add 100 * this counter HP to units
this.gameParameters.shopUpdatePeriod = 300 -- Seconds

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

  -- Wormwood
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
    for i=1, this.gameParameters.nSpawnCount do
      AbominationManager.AbominationSpawn(this.gameParameters)
    end
  end

  if(ModuloInteger(currentElapsedSeconds, this.gameParameters.shopUpdatePeriod) == 0) then
    print("Shop Items Updated")
    this.UpdateShopItems()
  end

  if(ModuloInteger(currentElapsedSeconds, this.gameParameters.burstPeriod) == 0) then
    for i=1, this.gameParameters.nBurstCount do
      AbominationManager.AbominationSpawn(this.gameParameters)
    end
  end

  -- After a certain point, we should ramp up the difficulty:
  if( (this.gameParameters.level == 5) and not(this.gameParameters.upgradesFinished) ) then
    -- this.gameParameters.healthMultiplier = 200 Deprecated with new food system
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

  -- Make sure he doesn't get triggered to move.. (from inside abomination manager)
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
    this.shopItemList[k] = nil
    -- table.remove(this.shopItemList)
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

  -- Don't bother to do anything unless the item to buy makes sense
  if( (1 <= nItemToBuy) and (nItemToBuy <= 4) ) then
    local dropPoint = {}
    local playerCurrentGold = GetPlayerState(commandData.commandingPlayer, PLAYER_STATE_RESOURCE_GOLD)
    local itemPrice = this.shopItemList[nItemToBuy].price

    -- Don't bother to do anything unless the player has enough gold
    if(playerCurrentGold >= itemPrice) then

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