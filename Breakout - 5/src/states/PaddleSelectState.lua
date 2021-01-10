PaddleSelectState = Class{__includes = BaseState}


function PaddleSelectState:enter(params)
    self.level = params.level
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.score = params.score
    self.highScores = params.highScores
    self.health = params.health
end

function PaddleSelectState:init()
    self.currentPaddle = 1
end

function PaddleSelectState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['confirm']:play()
        gStateMachine:change('serve', {
            paddle = Paddle(self.currentPaddle),
            bricks = LevelMaker.createMap(1),
            score = 0,
            health= 3,
            level = 1,
            highScores = self.highScores
        })
    end

    if love.keyboard.wasPressed('right') then
        gSounds['select']:play()
        self.currentPaddle = self.currentPaddle + 1
        if self.currentPaddle > 4 then
            self.currentPaddle = 4
        end
    end

    if love.keyboard.wasPressed('left') then
        gSounds['select']:play()
        self.currentPaddle = self.currentPaddle - 1
        if self.currentPaddle < 1 then
            self.currentPaddle = 1
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PaddleSelectState:render()
    love.graphics.setFont(gFonts['mediumFont'])
    love.graphics.printf('SELECT PADDLE', 0, 20, VIRTUAL_WIDTH, 'center')

    if self.currentPaddle == 1 then
        love.graphics.setColor(168,158,153, 128/255)
    end
    --Right Arrow
    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][1], VIRTUAL_WIDTH / 4 - 20, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)
    --Reset color
    love.graphics.setColor(1, 1, 1, 1)

        --                                                     position of default size paddle * skin
    love.graphics.draw(gTextures['main'], gFrames['paddle'][2 + 4 * (self.currentPaddle - 1)], VIRTUAL_WIDTH / 2 - 32, VIRTUAL_HEIGHT - 64)

    if self.currentPaddle == 4 then
        love.graphics.setColor(168,158,153, 128/255)
    end
    --Left Arrow
    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][2], VIRTUAL_WIDTH - VIRTUAL_WIDTH / 4, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setFont(gFonts['smallFont'])
    love.graphics.printf('PRESS ENTER TO CONTINUE', 0, VIRTUAL_HEIGHT - 16, VIRTUAL_WIDTH, 'center')
end