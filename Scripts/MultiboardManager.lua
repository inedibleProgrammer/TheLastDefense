MultiboardManager = {}

local this = MultiboardManager

this.MultiboardList = {}

local Multiboard = {}

--[[ Definition of a multiboard: ]]
function Multiboard.Create(title, nRows, nColumns)
  local this = {}
  this.title = title
  this.nRows = nRows
  this.nColumns = nColumns
  this.initialized = false
  this.board = nil

  function this.Initialize()
    this.initialized = true
    this.board = CreateMultiboard()

    MultiboardSetColumnCount(this.board, this.nRows)
    MultiboardSetRowCount(this.board, this.nColumns)
    MultiboardSetTitleText(this.board, this.title)
  end

  function this.Terminate()

  end

  function this.SetItem(row, column, text)
    local mbi = MultiboardGetItem(this.board, row, column)
      MultiboardSetItemValue(this.board, text)
      MultiboardReleaseItem(this.board)
    mbi = nil
  end

  function this.SetStyle(i, place, width)
  end

  function this.Display(show)
    MultiboardDisplay(this.board, show)
  end




  return this
end

-- End definition of multiboard

function this.Init()
  -- Nothing to do here?
  print("MultiboardManager Init")
end

function this.GetBoard(title, nRows, nColumns)
  -- local m = Multiboard.Create("MY_FIRST_MULTIBOARD", 4, 2)
  local m = Multiboard.Create(title, nRows, nColumns)
  return m
end