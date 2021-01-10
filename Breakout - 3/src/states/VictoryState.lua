--Update: ALL
VictoryState = Class{__includes = BaseState}

function VictoryState:enter(params)
    self.paddle = params.paddle
    self.score = params.score
    self.health = params.health
    self.level = params.level

        --Ball position
    self.ball = Ball()
    self.ball.skin = math.random(7)
end

function VictoryState:update(dt)
    self.paddle:update(dt)

    --Ball's position
    self.ball.x = self.paddle.x + self.paddle.width / 2 - 5
    self.ball.y = self.paddle.y - 8

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('serve', {
            level = self.level + 1,
            paddle = self.paddle,
            bricks = LevelMaker.createMap(self.level + 1),
            score = self.score,
            health= self.health,
            ball = self.ball
        })
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function VictoryState:render()
    --Displays Sprites
    self.paddle:render()
    self.ball:render()

    --Displays Score
    RenderScore(self.score)
    --Displays Health
    RenderHealth(self.health)

    love.graphics.setFont(gFonts['largeFont'])
    love.graphics.printf('LEVEL ' .. tostring(self.level) .. ' COMPLETED', 0, VIRTUAL_HEIGHT / 2 - 46, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['mediumFont'])
    love.graphics.printf('PRESS ENTER TO CONTINUE', 0, VIRTUAL_HEIGHT / 2 - 6, VIRTUAL_WIDTH, 'center')
end