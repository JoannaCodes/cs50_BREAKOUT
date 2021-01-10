--Update: GenerateQuadsBricks()
Util = Class{}

--Quads
--Getting quads: table[counter] = love.graphics.newQuad(x * Quadwidth, y * Quadheight, Quadwidth, Quadheight, var:getDimensions())
--x * Quadwidth, y * Quadheight: will shift to the next tile/quad
--Quadwidth, Quadheight: width and height of the tile/quad
--var:getDimensions(): vsr is the sprite sheet

--Displaying quads: love.graphics.draw(texture, quad table, x, y)

--For quads with same sizes
function GenerateQuads(atlas, tileWidth, tileHeight)
    local sheetWidth = atlas:getWidth() / tileWidth
    local sheetHeigth = atlas:getHeight() / tileHeight

    local sheetCounter = 1
    local spriteSheet = {}

    --y and x is the starting position
    for y = 0, sheetHeigth - 1 do --Iterates from top to bottom
        for x = 0, sheetWidth - 1 do --Iterates form left to right
            spriteSheet[sheetCounter] = love.graphics.newQuad(x * tileWidth, y * tileHeight, tileWidth, tileHeight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1 --syncs with the for loop index
        end
    end

    return spriteSheet
end
--Slices table values through iteration
function table.slice(tbl, first, last, step)
    local sliced = {}

    for i = first or 1, last or #tbl, step or 1 do
        sliced[#sliced + 1] = tbl[i]
    end

    --Returns table with 21 pieces of 32 x 16 bricks
    return sliced
end

--bricks: 32 x 16
function GenerateQuadsBricks(atlas)
    --table.slice is used so it will find 21 bricks in the sprite sheet
    return table.slice(GenerateQuads(atlas, 32, 16), 1, 21)
end

--=======================================================================

--For quads with different sizes
function GenerateQuadsPaddles(atlas)
    local x = 0
    local y = 64

    local counter = 1
    local quads = {}

    --There are four paddles of differents sizes in one color
    --So itereate up to 4
    for i = 1, 4 do
        --Small: 32x16
        quads[counter] = love.graphics.newQuad(x, y, 32, 16, atlas:getDimensions())
        counter = counter + 1

        --Medium: 64x16
        quads[counter] = love.graphics.newQuad(x + 32, y, 64, 16, atlas:getDimensions())
        counter = counter + 1
        --Large: 96x16
        quads[counter] = love.graphics.newQuad(x + 96, y, 96, 16, atlas:getDimensions())
        counter = counter + 1

        --Huge
        quads[counter] = love.graphics.newQuad(x, y + 16, 128, 16, atlas:getDimensions())
        counter = counter + 1

        --shifts to the next of paddle
        x = 0
        y= y + 32
    end

    return quads
end

function GenerateQuadsBalls(atlas)
    local x = 96
    local y = 48

    local counter = 1
    local quads = {}

    --there are 4 boals in a row
    for i = 1, 4 do
        --Balls: 8x8
        --1st Row: 4 balls
        quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
        x = x + 8 --For the next ball, since the sizes are the same no need to take then one by one like the paddle
        counter = counter + 1
    end

    --shifts to next row
    x = 96
    y = 56

    for i = 1, 3 do
        --Balls: 8x8

        --2nd Row: 3 balls
        quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
        x = x + 8 --For the next ball
        counter = counter + 1
    end

    return quads
end