--Update: ALL

HighScoreState = Class{__includes = BaseState}

function HighScoreState:enter(params)
    self.highScores = params.highScores
end

function HighScoreState:update()
    if love.keyboard.wasPressed('escape') then
        gSounds['wall_hit']:play()

        gStateMachine:change('start', {highScores = self.highScores})
    end
end

function HighScoreState:render()
    love.graphics.setFont(gFonts['largeFont'])
    love.graphics.printf('High Scores', 0, 20, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['mediumFont'])

    for i = 1, 10 do
        local name = self.highScores[i].name or '---'
        local scores = self.highScores[i].scores or '---'

        --Displays number
        love.graphics.printf(tostring(i) .. '.', VIRTUAL_WIDTH / 4, 60 + i * 13, 50, 'left' )

        --Displays name
        love.graphics.printf(name, VIRTUAL_WIDTH / 4 + 40, 60 + i * 13, 50, 'right')

        --Displays scores
        love.graphics.printf(tostring(scores), VIRTUAL_WIDTH / 2, 60 + i * 13, 100, 'right')
    end

    love.graphics.setFont(gFonts['smallFont'])
    love.graphics.printf('PRESS ESCAPE OR RETURN TO GO BACK TO THE MAIN MENU', 0, VIRTUAL_HEIGHT - 16, VIRTUAL_WIDTH, 'center')
end