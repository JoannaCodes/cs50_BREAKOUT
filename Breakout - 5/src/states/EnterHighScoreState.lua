EnterHighScoreState = Class{__includes = BaseState}

local char = {
    [1] = 65,
    [2] = 65,
    [3] = 65
}

local highlightedChar = 1

function EnterHighScoreState:enter(params)
    self.highScores = params.highScores
    self.score = params.score
    self.scoreIndex = params.scoreIndex
end
function EnterHighScoreState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        local name = string.char(char[1]) .. string.char(char[2]) .. string.char(char[3])

        for i = 10, self.scoreIndex, -1 do
            self.highScores[i + 1] = {
                name = self.highScores[i].name,
                score = self.highScores[i].score
            }
        end

        self.highScores[self.scoreIndex].name = name
        self.highScores[self.scoreIndex].score = self.score

        --Writes score file
        local scoreStr = ''

        for i = 1, 10 do
            scoreStr = scoreStr .. self.highScores[i].name .. '\n'
            scoreStr = scoreStr .. tostring(self.highScores[i].score) .. '\n'
        end

        love.filesystem.write('breakout.lst', scoreStr)

        gStateMachine:change('highscore', {
            highScores = self.highScores
        })
    end

    if love.keyboard.wasPressed('right') then
        highlightedChar = highlightedChar + 1
        if highlightedChar > 3 then
            highlightedChar = 1
        end

    elseif love.keyboard.wasPressed('left')  then
        highlightedChar = highlightedChar + 1
        if highlightedChar < 1 then
            highlightedChar = 3
        end
    end

    if love.keyboard.wasPressed('up') then
        char[highlightedChar] = char[highlightedChar] + 1
        if char[highlightedChar] > 90 then
            char[highlightedChar] = 65
        end

    elseif love.keyboard.wasPressed('down') then
        char[highlightedChar] = char[highlightedChar] - 1
        if char[highlightedChar] < 65 then
            char[highlightedChar] = 90
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function EnterHighScoreState:render()
    love.graphics.setFont(gFonts['mediumFont'])
    love.graphics.printf('SCORE: ' .. self.score, 0, 20, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['largeFont'])

    if highlightedChar == 1 then
        love.graphics.setColor(239,255,0,255)
    end

    love.graphics.printf(string.char(char[1]), 0, 100, VIRTUAL_WIDTH - 40, 'center')
    love.graphics.setColor(255,255,255,255)

    if highlightedChar == 2 then
        love.graphics.setColor(239,255,0,255)
    end

    love.graphics.printf(string.char(char[2]), 0, 100, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255,255,255,255)

    if highlightedChar == 3 then
        love.graphics.setColor(239,255,0,255)
    end

    love.graphics.printf(string.char(char[3]), 0, 100, VIRTUAL_WIDTH + 40, 'center')
    love.graphics.setColor(255,255,255,255)

    love.graphics.setFont(gFonts['smallFont'])
    love.graphics.printf('PRESS ENTER', 0, VIRTUAL_HEIGHT - 16, VIRTUAL_WIDTH, 'center')
end