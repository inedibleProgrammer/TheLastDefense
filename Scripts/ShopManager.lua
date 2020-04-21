ShopManager = {}
local this = ShopManager

this.updatePeriod = 60 -- Seconds
this.nItems = 8

this.ItemsForSale = {}

function this.Init()
  local marketPlacePoint = Utility.Point.Create(895.6, -1609.6)
  this.marketPlace = CreateUnit(Player(27), FourCC("nmrk"), marketPlacePoint.x, marketPlacePoint.y, 0.0)

  --[[ Add Commands: ]]
  local function ViewShopItems()
    for k,v in ipairs(this.ItemsForSale) do
      print(v.iID)
    end
  end
  CommandManager.AddCommand("shop", ViewShopItems)
end


function this.Process()
  local currentElapsedSeconds = GameClock.GetElapsedSeconds()
  
  --[[ Update Shop Items: ]]
  if (ModuloInteger(currentElapsedSeconds, this.updatePeriod) == 0) then
    -- First, empty the market
    if (#this.ItemsForSale >= 1) then
      for k,v in ipairs(this.ItemsForSale) do
        RemoveItemFromStock(this.marketPlace, FourCC(v.iID))
        this.ItemsForSale[k] = nil
      end
    end

    -- Now, add items to the shop
    for i = 1, this.nItems do
      local si = ItemManager.GetRandomShopItem()
      table.insert(this.ItemsForSale, si)
      AddItemToStock(this.marketPlace, FourCC(si.iID), 1, 1)
    end
  end
end