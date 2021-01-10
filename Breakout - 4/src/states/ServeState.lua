--Update:
ServeState = Class{__includes = BaseState}

--Takes value of params from the StartState
function ServeState:enter(params)
    self.level = params.level
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.score = params.score
    self.health = params.health

        --Ball position
    self.ball = Ball()
    self.ball.skin = math.random(7)
end

function ServeState:update(dt)
    self.paddle:update(dt)

    --Ball's position
    self.ball.x = self.paddle.x + self.paddle.width / 2 - 5
    self.ball.y = self.paddle.y - 8

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play', {
            level = self.level,
            paddle = self.paddle,
            bricks = self.bricks,
            score = self.score,
            health= self.health,
            ball = self.ball
        })
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function ServeState:render()
    --Displays Sprites
    self.paddle:render()
    self.ball:render()
    for k, bricks in pairs(self.bricks) do
        bricks:render()
    end

    --Displays Score
    RenderScore(self.score)
    --Displays Health
    RenderHealth(self.health)

    love.graphics.setFont(gFonts['largeFont'])
    love.graphics.printf('LEVEL ' .. self.level, 0, VIRTUAL_HEIGHT / 2 - 46, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['mediumFont'])
    love.graphics.printf('PRESS ENTER TO SERVE!', 0, VIRTUAL_HEIGHT / 2 - 6, VIRTUAL_WIDTH, 'center')
end