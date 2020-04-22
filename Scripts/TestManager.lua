TestManager = {}
local this = TestManager

this.RedTable = {}


function this.Init()
  local function RedAdd(commandData)
    local input = commandData.tokens[3]
    table.insert(this.RedTable, input)
  end
  CommandManager.AddCommand("red_add", RedAdd)

  local function RedRemove(commandData)
    local input = commandData.tokens[3]
    for index = 1, #this.RedTable do
      if (this.RedTable[index] == input) then
        table.remove(this.RedTable, input)
      end
    end
  end
  CommandManager.AddCommand("red_remove", RedRemove)

  local function RedPrint()
    local redData = "R"
    for k,v in ipairs(this.RedTable) do
      redData = redData .. ";" .. v
    end
    print(redData)
  end
  CommandManager.AddCommand("red_print", RedPrint)
end

function this.Process()
end