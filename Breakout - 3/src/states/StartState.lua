--Update:
StartState = Class{__includes = BaseState}

--Keeps track of the user choice
--1:Start, 2:Highscore
local highlighted = 1

--Uses self.current:enter(enterParams), this where it start, initialization of params
function StartState:update(dt)
    --Highlight toggling
    --Default Options sets to 'start' then 'and' for the toggle then 'or' repeats the toggle options
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        gSounds['paddle_hit']:play()
        highlighted = highlighted == 1 and 2 or 1 --Withour 'or 1' the toggle highlight will got back to 1
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['confirm']:play()
        if highlighted == 1 then
            gStateMachine:change('serve', {
                paddle = Paddle(1),
                bricks = LevelMaker.createMap(1),
                score = 0,
                health= 3,
                level = 1
            })
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function StartState:render()
    --Title
    love.graphics.setFont(gFonts['largeFont'])
    love.graphics.printf('BREAKOUT', 0, 70, VIRTUAL_WIDTH, 'center')

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