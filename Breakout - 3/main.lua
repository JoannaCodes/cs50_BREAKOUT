--Update: gFrames['hearts'], gStateMachine['vctory']
require 'src/Dependencies'

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Breakout')

    math.randomseed(os.time())

    gTextures = {
        ['background'] = love.graphics.newImage('graphics/background.png'),
        ['arrows'] = love.graphics.newImage('graphics/arrows.png'),
        ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
        ['particle'] = love.graphics.newImage('graphics/particle.png'),

        --Sprite Sheet
        ['main'] = love.graphics.newImage('graphics/breakout.png')
    }

    gFrames = {
        ['paddle'] = GenerateQuadsPaddles(gTextures['main']),
        ['ball'] = GenerateQuadsBalls(gTextures['main']),
        ['bricks'] = GenerateQuadsBricks(gTextures['main']),
        ['hearts'] = GenerateQuads(gTextures['hearts'], 10, 9),
        ['arrows'] = GenerateQuads(gTextures['arrows'], 24, 24),
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
        ['play'] = function () return PlayState() end,
        ['serve'] = function () return ServeState() end,
        ['game_over']  = function () return GameOverState() end,
        ['victory'] = function () return VictoryState() end
    }

    --Default state
    gStateMachine:change('start')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable = true,
        fullscreen = false,
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

    --Reset table
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

function RenderScore(score)
    love.graphics.setFont(gFonts['smallFont'])
    love.graphics.printf('Score:   ' .. tostring(score), 0, 4, VIRTUAL_WIDTH - 15, 'right')
end

function RenderHealth(health)
    -- start of our health rendering
    local healthX = VIRTUAL_WIDTH - 115
    
    -- render health left
    for i = 1, health do
        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][1], healthX, 3)
        healthX = healthX + 11
    end

    -- render missing health
    for i = 1, 3 - health do
        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][2], healthX, 3)
        healthX = healthX + 11
    end
end