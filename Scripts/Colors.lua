ColorActions = {}

function ColorActions.ColorStringToNumber(color)
    if (color == "red") then return 1
    elseif(color == "blue") then return 2
    elseif(color == "teal" or color == "cyan") then return 3
    elseif(color == "purple") then return 4
    elseif(color == "yellow") then return 5
    elseif(color == "orange") then return 6
    elseif(color == "green") then return 7
    elseif(color == "pink") then return 8
    elseif(color == "light_gray" or color == "gray") then return 9
    elseif(color == "light_blue") then return 10
    elseif(color == "dark_green") then return 11
    elseif(color == "brown") then return 12
    elseif(color == "maroon") then return 13
    elseif(color == "navy") then return 14
    elseif(color == "turquoise") then return 15
    elseif(color == "violet") then return 16
    elseif(color == "wheat") then return 17
    elseif(color == "peach") then return 18
    elseif(color == "mint") then return 19
    elseif(color == "lavender") then return 20
    elseif(color == "coal") then return 21
    elseif(color == "snow") then return 22
    elseif(color == "emerald") then return 23
    elseif(color == "peanut") then return 24
    else return nil
    end
end

function ColorActions.NumberToColorString(color)
    if (color == 1) then return "red"
    elseif(color == 2) then return "blue"
    elseif(color == 3) then return "teal"
    elseif(color == 4) then return "purple"
    elseif(color == 5) then return "yellow"
    elseif(color == 6) then return "orange"
    elseif(color == 7) then return "green"
    elseif(color == 8) then return "pink"
    elseif(color == 9) then return "gray"
    elseif(color == 10) then return "light_blue"
    elseif(color == 11) then return "dark_green"
    elseif(color == 12) then return "brown"
    elseif(color == 13) then return "maroon"
    elseif(color == 14) then return "navy"
    elseif(color == 15) then return "turquoise"
    elseif(color == 16) then return "violet"
    elseif(color == 17) then return "wheat"
    elseif(color == 18) then return "peach"
    elseif(color == 19) then return "mint"
    elseif(color == 20) then return "lavender"
    elseif(color == 21) then return "coal"
    elseif(color == 22) then return "snow"
    elseif(color == 23) then return "emerald"
    elseif(color == 24) then return "peanut"
    else return nil
    end
end

-- Preconditions: Page = {1, 2}
function ColorActions.ShowColors(commandingPlayer, page)
-- native DisplayTextToPlayer          takes player toPlayer, real x, real y, string message returns nothing
-- native DisplayTimedTextToPlayer     takes player toPlayer, real x, real y, real duration, string message returns nothing
    local initial_color = 1
    local final_color = 24
    local currentColorText = ""
    if(page == 1) then
        initial_color = 1
        final_color = 13
    elseif(page == 2) then
        initial_color = 14
        final_color = 24
    else
        -- do nothing
    end

    for i = initial_color, final_color do
        currentColorText = ColorActions.NumberToColorString(i)
        DisplayTimedTextToPlayer(commandingPlayer, 0, 0, 15.0,"|c" .. ColorList[currentColorText].hex_code .. currentColorText .. "|r (" .. I2S(i) .. ") : " .. GetPlayerName(Player(i-1)))
    end
end



--===================================================================================================================================================================
--===================================================================================================================================================================
--===================================================================================================================================================================

ColorList = {}

ColorList.red =
{
    text = "red",
    number = 1,
    hex_code = "00FF0303"
}

ColorList.blue =
{
    text = "blue",
    number = 2,
    hex_code = "000042FF"
}

ColorList.teal =
{
    text = "teal",
    number = 3,
    hex_code = "001CE6B9"
}

ColorList.purple =
{
    text = "purple",
    number = 4,
    hex_code = "00540081"
}

ColorList.yellow =
{
    text = "yellow",
    number = 5,
    hex_code = "00FFFC00"
}

ColorList.orange =
{
    text = "orange",
    number = 6,
    hex_code = "00FE8A0E"
}

ColorList.green =
{
    text = "green",
    number = 7,
    hex_code = "0020C000"
}

ColorList.pink =
{
    text = "pink",
    number = 8,
    hex_code = "00E55BB0"
}

ColorList.gray =
{
    text = "gray",
    number = 9,
    hex_code = "00959697"
}

ColorList.light_blue =
{
    text = "light_blue",
    number = 10,
    hex_code = "007EBFF1"
}

ColorList.dark_green =
{
    text = "dark_green",
    number = 11,
    hex_code = "00106246"
}

ColorList.brown =
{
    text = "brown",
    number = 12,
    hex_code = "004E2A04"
}

ColorList.maroon =
{
    text = "maroon",
    number = 13,
    hex_code = "009B0000"
}

ColorList.navy =
{
    text = "navy",
    number = 14,
    hex_code = "000000C3"
}

ColorList.turquoise =
{
    text = "turquoise",
    number = 15,
    hex_code = "0000EAFF"
}

ColorList.violet =
{
    text = "violet",
    number = 16,
    hex_code = "00BE00FE"
}

ColorList.wheat =
{
    text = "wheat",
    number = 17,
    hex_code = "00EBCD87"
}

ColorList.peach =
{
    text = "peach",
    number = 18,
    hex_code = "00F8A48B"
}

ColorList.mint =
{
    text = "mint",
    number = 19,
    hex_code = "00BFFF80"
}

ColorList.lavender =
{
    text = "lavender",
    number = 20,
    hex_code = "00DCB9EB"
}

ColorList.coal =
{
    text = "coal",
    number = 21,
    hex_code = "00282828"
}

ColorList.snow =
{
    text = "snow",
    number = 22,
    hex_code = "00EBF0FF"
}

ColorList.emerald =
{
    text = "emerald",
    number = 23,
    hex_code = "0000781E"
}

ColorList.peanut =
{
    text = "peanut",
    number = 24,
    hex_code = "00A46F33"
}

ColorList.some_weird_green =
{
    text = "some_weird_green",
    number = 25,
    hex_code = "0022744F"
}

ColorList.gold =
{
    text = "gold",
    number = 26,
    hex_code = "00FFD700"
}

ColorList.bright_blue =
{
    text = "bright_blue",
    number = 27,
    hex_code = "0019CAF6"
}