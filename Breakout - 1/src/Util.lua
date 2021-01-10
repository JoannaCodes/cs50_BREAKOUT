--Update: GenerateQuads(), table.slice(), GenerateQuadsPaddles(), GenerateQuadsBalls(), GenerateQuadsBricks()
Util = Class{}

--For quads with same sizes
function GenerateQuads(atlas, tileWidth, tileHeight)
    local sheetWidth = atlas:getWidth() / tileWidth
    local sheetHeigth = atlas:getHeight() / tileHeight

    local sheetCounter = 1
    local spriteSheet = {}

    for y = 0, sheetHeigth - 1 do
        for x = 0, sheetWidth - 1 do
            spriteSheet = love.graphics.newQuad(x * tileWidth, y * tileHeight, tileWidth, tileHeight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spriteSheet
end

function table.slice(tbl, first, last, step)
    local sliced = {}

    for i = first or 1, last or #tbl, step or 1 do
        sliced[#sliced + 1] = tbl[i]
    end

    return sliced
end

--For quads with different sizes
function GenerateQuadsPaddles(atlas)
    local x = 0
    local y = 64

    local counter = 1
    local quads = {}

    --There are four paddles of differents sizes
    --So itereate up to 4
    for i = 0, 3 do
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

    for i = 0, 3 do
        --Balls: 8x8
        --1st Row: 4 balls
        quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
        x = x + 8 --For the next ball, since the sizes are the same no need to take then one by one like the paddle
        counter = counter + 1
    end

    x = 96
    y = 56

    for i = 0, 2 do
        --Balls: 8x8

        --2nd Row: 3 balls
        quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
        x = x + 8 --For the next ball
        counter = counter + 1
    end

    return quads
end