require 'src/Dependencies'

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Breakout')

    gTextures = {
        ['background'] = love.graphics.newImage('graphics/background.png'),
        ['main'] = love.graphics.newImage('graphics/breakout.png'),
        ['arrows'] = love.graphics.newImage('graphics/arrows.png'),
        ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
        ['particle'] = love.graphics.newImage('graphics/particle.png')
    }

    gSounds = {
        ['brick-hit-1'] = love.audio.newSource('sounds/brick-hit-1.wav', 'static'),
        ['brick-hit-2'] = love.audio.newSource('sounds/brick-hit-2.wav', 'static'),
        ['confirm'] = love.audio.newSource('sounds/confirm.wav', 'static'),
        ['high_score'] = love.audio.newSource('sounds/high_score.wav', 'static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
        ['no-select'] = love.audio.newSource('sounds/no-select.wav', 'static'),
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['pause'] = love.audio.newSource('sounds/pause.wav', 'static'),
        ['recover'] = love.audio.newSource('sounds/recover.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
        ['victory'] = love.audio.newSource('sounds/victory.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),

        ['music'] = love.audio.newSource('sounds/music.wav', 'static')
    }

    --gSounds['music']:setLooping(true)
    --gSounds['music']:play()

    gFonts = {
        ['smallFont'] = love.graphics.newFont('fonts/font.ttf', 8),
        ['mediumFont'] = love.graphics.newFont('fonts/font.ttf', 16),
        ['largeFont'] = love.graphics.newFont('fonts/font.ttf', 32)
    }

    love.graphics.setFont(gFonts['smallFont'])

    gStateMachine = StateMachine {
        ['start'] = function () return StartState() end,
    }

    gStateMachine:change('start')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

        local background_width = gTextures['background']:getWidth()
        local background_height = gTextures['background']:getHeight()

        love.graphics.draw(gTextures['background'], 
            -- draw at coordinates 0, 0
            0, 0, 
            -- no rotation
            0,
            -- scale factors on X and Y axis so it fills the screen
            VIRTUAL_WIDTH / (background_width - 1), VIRTUAL_HEIGHT / (background_height - 1))

        gStateMachine:render()

        DisplayFPS()

    push:finish()
end

function DisplayFPS()
    love.graphics.setFont(gFonts['smallFont'])
    love.graphics.setColor(0,255,0,255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
end