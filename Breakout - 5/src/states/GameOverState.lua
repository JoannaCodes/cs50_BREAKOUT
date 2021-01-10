--Update:
GameOverState = Class{__includes = BaseState}

function GameOverState:enter(params)
    --Sets score
    self.score = params.score
    self.highScores = params.highScores
end

function GameOverState:update(dt)
    --Goeas back to StartState
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        local highScore = false

        local scoreIndex = 11

        for i = 10, 1, -1 do
            local score = self.highScores[i].score or 0
            if self.score > score then
                highScoreIndex = i
                highScore = true
            end
        end

        if highScore then
            gSounds['high_score']:play()
            gStateMachine:change('enter_highscore', {
                score = self.score,
                highScores = self.highScores,
                scoreIndex = highScoreIndex
            })

        else
            --Goes to the Start State of score is not high than the attained score
            gStateMachine:change('start', {highScores = self.highScores})
        end
    end

    --Quit
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

--Displays GAME OVEr and FINAL SCORE
function GameOverState:render()
    love.graphics.setFont(gFonts['largeFont'])
    love.graphics.printf('GAME OVER', 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['mediumFont'])
    love.graphics.printf('FINAL SCORE: ' .. tostring(self.score), 0, 150, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('PRESS ENTER!', 0, 200, VIRTUAL_WIDTH, 'center')
end