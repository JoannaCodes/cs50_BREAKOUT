--Update:
GameOverState = Class{__includes = BaseState}

function GameOverState:enter(params)
    --Sets score
    self.score = params.score
end

function GameOverState:update(dt)
    --Goeas back to StartState
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('start')
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
    love.graphics.printf('PRESS ENTER TO PLAY AGAIN', 0, 200, VIRTUAL_WIDTH, 'center')
end