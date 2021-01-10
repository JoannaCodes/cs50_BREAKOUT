--Update: Random Color brick
LevelMaker = Class{}
--Pattern
NONE = 1
SINGLE_PYRAMID = 2
MULTI_PYRAMID = 3

--Brick alternation
SOLID = 1
ALTERNATE = 2
SKIP = 3
NONE = 4
function LevelMaker.createMap(level)
    local bricks = {}

    -- Randomly choose the number of rows (should be odd)
    local numRows = math.random(1, 5)

    -- Randomly choose the number of columns (should be odd)
    local numCols = math.random(7, 13)
    numCols = numCols % 2 == 0 and (numCols + 1) or numCols

    --math.floor (x) - Returns the largest integral value less than or equal to x. Whole number
    local highestTier = math.min(3, math.floor(level / 5))
    local highestColor = math.min(5, level % 5 + 3 )


    --Lay out bricks such that they touch each other and fill the space
    for y = 1, numRows do
        local skipPattern = math.random(2) == 1 and true or false
        local alternatePattern =  math.random(2) == 1 and true or false

        --Alternation of colors: 1: one color 2: other color and alse with the tier
        local alternateColor1 = math.random(1, highestColor)
        local alternateColor2 = math.random(1, highestColor)
        local alternateTier1 = math.random(0, highestTier)
        local alternateTier2 = math.random(0, highestTier)

        local solidColor = math.random(1, highestColor)
        local solidTier = math.random(0, highestTier)

        --True:displays brick; False:skip a brick per row
        local skipFlag = math.random(2) == 1 and true or false
        --True:displays alternate colors (green, violet, green, violet); False:solid colors per row
        local alternateFlag = math.random(2) == 1 and true or false

        for x =1, numCols do
            --if skipPattern and skipFlag is true then the value of skipFlag will br set to false (no brick will display)
            if skipPattern and skipFlag then
                skipFlag = not skipFlag
                
                --loops the condition
                goto continue
            else --Where skipPattern and skipFlag are false, sets skipFlag to true
                skipFlag = not skipFlag
            end

            --Brick position
            b = Brick(
                -- x-coordinate
                (x-1)                   --Decrement x by 1 because tables are 1-indexed, coords are 0
                * 32                    --Multiply by 32, the brick width
                + 8                     --The screen should have 8 pixels of padding; we can fit 13 cols + 16 pixels total
                + (13 - numCols) * 16,  --Left-side padding for when there are fewer than 13 columns
                
                -- y-coordinate
                y * 16                  --Just use y * 16, since we need top padding anyway
            )

            --if alternatePattern and alternateFlag is true then display Color1 and whatever alternateFlag is set to false
            if alternatePattern and alternateFlag then
                b.color = alternateColor1
                b.tier = alternateTier1
                alternateFlag = not alternateFlag
            else --Where alternatePattern and alternateFlag, sets alternateFlag to true
                b.color = alternateColor2
                b.tier = alternateTier2
                alternateFlag = not alternateFlag
            end

            --if alternatePattern only is true then display only solid colors
            if not alternatePattern then
                b.color = solidColor
                b.tier = solidTier
            end

            table.insert(bricks, b)
        
            ::continue::
        end
    end

    --if no bricks were displayed then repeat the process
    if #bricks == 0 then
        return self.createMap(level)
    else
        return bricks
    end
end