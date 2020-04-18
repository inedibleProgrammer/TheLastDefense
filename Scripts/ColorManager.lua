ColorManager = {}
local this = ColorManager

this.ColorList = {}

--[[ Definition of a Color: ]]
Color = {}
function Color.Create(text, number, hexCode)
  local this = {}
  this.text = text
  this.number = number
  this.hexCode = hexCode

  return this
end
--[[ End Definition of a Color ]]

function this.Init()
  this.AddColor("red", 1, "00FF0303")
  this.AddColor("blue", 2, "000042FF")
  this.AddColor("teal", 3, "001CE6B9")
  this.AddColor("purple", 4, "00540081")
  this.AddColor("yellow", 5, "00FFFC00")
  this.AddColor("orange", 6, "00FE8A0E")
  this.AddColor("green", 7, "0020C000")
  this.AddColor("pink", 8, "00E55BB0")
  this.AddColor("gray", 9, "00959697")
  this.AddColor("light_blue", 10, "007EBFF1")
  this.AddColor("dark_green", 11, "00106246")
  this.AddColor("brown", 12, "004E2A04")
  this.AddColor("maroon", 13, "009B0000")
  this.AddColor("navy", 14, "000000C3")
  this.AddColor("turquoise", 15, "0000EAFF")
  this.AddColor("violet", 16, "00BE00FE")
  this.AddColor("wheat", 17, "00EBCD87")
  this.AddColor("peach", 18, "00F8A48B")
  this.AddColor("mint", 19, "00BFFF80")
  this.AddColor("lavender", 20, "00DCB9EB")
  this.AddColor("coal", 21, "00282828")
  this.AddColor("snow", 22, "00EBF0FF")
  this.AddColor("emerald", 23, "0000781E")
  this.AddColor("peanut", 24, "00A46F33")
  this.AddColor("some_weird_green", 25, "0022744F")
  this.AddColor("gold", 26, "00FFD700")
  this.AddColor("bright_blue", 27, "0019CAF6")

  --[[ Commands: ]]
  local function PrintColors(commandData)
    local initialColor = 1
    local finalColor = 13

    if (commandData.tokens[3] == "2") then
      initialColor = 14
      finalColor = 24
    end

    for i = initialColor, finalColor do
      local c = this.GetColor_N(i)
      DisplayTimedTextToPlayer(commandData.commandingPlayer, 0, 0, 15.0, "|c" .. c.hexCode .. c.text .. "|r" .. "(" .. c.number .. ")")
    end
  end

  CommandManager.AddCommand("colors", PrintColors)
end

function this.AddColor(text, number, hexCode)
  local color = Color.Create(text, number, hexCode)
  table.insert(this.ColorList, color)
end

function this.GetColor_T(t)
  for k,v in ipairs(this.ColorList) do
    if t == v.text then
      return v
    end
  end
end

function this.GetColor_N(n)
  for k,v in ipairs(this.ColorList) do
    if n == v.number then
      return v
    end
  end
end

function this.GetColorCode(text)
  for k,v in ipairs(this.ColorList) do
    if text == v.text then
      return v.hexCode
    end
  end
end