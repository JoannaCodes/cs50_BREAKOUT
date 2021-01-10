StartState = Class{__includes = BaseState}

--Keeps track of the user choice
local highlighted = 1

function StartState:update(dt)
    --Higlight toggling
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        highlighted = highlighted == 1 and 2 or 1 --Toggles down to option 2 then reset to option 1
        gSounds['paddle_hit']:play()
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function StartState:render()
    --Title
    love.graphics.setFont(gFonts['largeFont'])
    love.graphics.printf('BREAKOUT', 0, 60, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['mediumFont'])

    if highlighted == 1 then
        love.graphics.setColor(239,255,0,255)
    end

    love.graphics.printf("START", 0, VIRTUAL_HEIGHT / 2 + 70, VIRTUAL_WIDTH, 'center')

    --Reset color
    love.graphics.setColor(255,255,255,255)

    --High Score
    if highlighted == 2 then
        love.graphics.setColor(239,255,0,255)
    end

    love.graphics.printf("HIGH SCORE", 0, VIRTUAL_HEIGHT / 2 + 90, VIRTUAL_WIDTH, 'center')

    --Reset color
    love.graphics.setColor(255,255,255,255)
end