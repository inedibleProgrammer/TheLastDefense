ItemManager = {}
local this = ItemManager

this.ShopItemList = {}

--[[ Definition of a Shop Item: ]]
ShopItem = {}
function ShopItem.Create(iID, price)
  local this = {}
  this.iID = iID
  this.price = price

  return this
end
--[[ End Definition of a Shop Item ]]

function this.Init()
  print("Initializing Items: ")

  --[[ Get all the item prices and save them ]]
  -- This process takes no more than one minute to finish
  for k,v in ipairs(AllItemList) do
    local price = this.GetItemPrice(v)

    if (price > 0) then
      local si = ShopItem.Create(v, price)
      table.insert(this.ShopItemList, si)
    end
  end

  --[[ Add Commands: ]]
end

--   This function determines the price of an item
-- by selling the item to a shop and comparing the
-- user's gold before and after.
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

function this.GetRandomShopItem()
  local r = GetRandomInt(1, #this.ShopItemList)
  local si = {}

  si = this.ShopItemList[r]
  return si
end