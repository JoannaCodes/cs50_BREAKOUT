--Update: hearts, score, particles, Level progression
PlayState = Class{__includes = BaseState}

--Takes value of params from the StartState
function PlayState:enter(params)
    self.level = params.level
    self.paddle = params.paddle
    self.ball = params.ball
    self.health = params.health
    self.score = params.score
    self.bricks = params.bricks

    --Ball velocity
    self.ball.dx = math.random(-200, 200)
    self.ball.dy = math.random(-50, -100)

    self.pause = false
end

function PlayState:update(dt)
    --Pause
    if self.pause then
        if love.keyboard.wasPressed('space') then
            self.pause = false
            gSounds['pause']:play()
        else
            return --Pauses all activity ing the PlayState
        end
    elseif love.keyboard.wasPressed('space') then
        self.pause = true
        gSounds['pause']:play()
        return
    end

    --Paddle movement
    self.paddle:update(dt)
    --Ball movement
    self.ball:update(dt)

    --Ball collision to the paddle
    if self.ball:collision(self.paddle) then
        gSounds['paddle_hit']:play()
        self.ball.dy = -self.ball.dy
        self.ball.y = self.paddle.y - 8 --Shifts the ball above the paddle once it collided so that it wont get stuct and repeat the collision

        --Paddle's center = self.paddle.x + (self.paddle.width / 2)
        --if ball's postion is from the left of the paddle's center and the paddles movement is going left 
        --then the balls direction will go left
        if self.ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
            self.ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - self.ball.x))

        --if ball's postion is from the right of the paddle's center and the paddles movement is going righ 
        --then the balls direction will go right
        elseif self.ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
            self.ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball.x)) --math.abs is used for the positive direction of the bounce
        end
    end

    --Ball collision to the bricks
    for k, bricks in pairs(self.bricks) do

        if bricks.inPlay and self.ball:collision(bricks) then
            --Score
            self.score = self.score + (bricks.tier * 200 + bricks.color * 5)

            --Brick will be out of PlayState
            bricks:hit()

            --goes to VictoryState() when the bricks are all gone
            --self:methid() self is the PlayState() function just like calling update and render function
            if self:checkVictory() then
                gSounds['victory']:play()

                gStateMachine:change('victory', {
                    level = self.level,
                    paddle = self.paddle,
                    score = self.score,
                    health= self.health,
                    ball = self.ball
                })
            end

            --if ball's postion is at the left edge (bricks.x) of the brick and ball's direction os negative
            if self.ball.x + 2 < bricks.x and self.ball.dx > 0 then
                self.ball.dx = -self.ball.dx
                --Shifts the ball by the ball's width from the left edge in the brick once it collided so that it wont get stuck
                self.ball.x = bricks.x - 8

            --if ball's postion is at the right edge (bricks.x + bricks.width) of the brick and ball's direction is negative
            elseif self.ball.x + 6 > bricks.x + bricks.width and self.ball.dx < 0 then
                self.ball.dx = -self.ball.dx
                --Shifts the ball by the bricks' width from the right edge in the brick once it collided so that it wont get stuck
                self.ball.x = bricks.x + 32

            --if ball's postion is at the top edge (bricks.y) of the brick
            elseif self.ball.y < bricks.y then
                self.ball.dy = -self.ball.dy
                --Shifts the ball by the ball's height from the top edge in the brick once it collided so that it wont get stuck
                self.ball.y = bricks.y - 8

            --if ball's postion is at the bottom edge (bricks.y + bricks.height) of the brick
            else
                self.ball.dy = -self.ball.dy
                --Shifts the ball by the bricks' height from the right edge in the brick once it collided so that it wont get stuck
                self.ball.y = bricks.y + 16
            end

            --Speeds up the ball
            self.ball.dy = self.ball.dy * 1.02

            --Allows to hit only one brick in corners
            break
        end
    end

    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    --Goes to the GameOverState if the condition is true
    if self.ball.y >= VIRTUAL_HEIGHT then
        self.health = self.health - 1
        gSounds['hurt']:play()
        if self.health == 0 then
            gStateMachine:change('game_over', {score = self.score})
        else
            gStateMachine:change('serve', {
                level = self.level,
                paddle = self.paddle,
                bricks = self.bricks,
                score = self.score,
                health= self.health,
            })
        end
    end

    --Quit
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    --Displays Sprites
    self.paddle:render()
    self.ball:render()
    for k, bricks in pairs(self.bricks) do
        bricks:render()
    end

    for k, bricks in pairs(self.bricks) do
        bricks:renderParticles()
    end

    --Score
    RenderScore(self.score)
    --Health
    RenderHealth(self.health)

    --Displays PAUSE
    if self.pause then
        love.graphics.setFont(gFonts['largeFont'])
        love.graphics.printf('PAUSE', 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')

        if love.keyboard.wasPressed('escape') then
            love.event.quit()
        end
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end
    end

    return true
end