--Update: Bricks, Brick collision, Updated Paddle Collision
PlayState = Class{__includes = BaseState}

function PlayState:init()
    --Initializing Paddle, Ball, & Bricks Class
    self.paddle = Paddle()
    --the skin default is 1: Blue. The table for the quad starts at 1
    self.ball = Ball(math.random(7))
    self.brick = LevelMaker.createMap()


    --Ball position
    self.ball.x = VIRTUAL_WIDTH / 2 - 5
    self.ball.y = VIRTUAL_HEIGHT - 42

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
    for k, bricks in pairs(self.brick) do
        if bricks.inPlay and self.ball:collision(bricks) then
            --if ball's postion is at the left edge of the brick and ball's direction os negative
            if self.ball.x + 2 < bricks.x and self.ball.dx > 0 then
                self.ball.dx = -self.ball.dx
                --Shifts the ball by the ball's width from the left edge in the brick once it collided so that it wont get stuck
                self.ball.x = bricks.x - 8

            --if ball's postion is at the right edge of the brick and ball's direction is negative
            elseif self.ball.x > bricks.x and self.ball.dx < 0 then
                self.ball.dx = -self.ball.dx
                --Shifts the ball by the bricks' width from the right edge in the brick once it collided so that it wont get stuck
                self.ball.x = bricks.x + 32

            --if ball's postion is at the top edge of the brick
            elseif self.ball.y < bricks.y then
                self.ball.dy = -self.ball.dy
                --Shifts the ball by the ball's height from the top edge in the brick once it collided so that it wont get stuck
                self.ball.y = bricks.y - 8

            --if ball's postion is at the bottom edge of the brick
            else
                self.ball.dy = -self.ball.dy
                --Shifts the ball by the bricks' height from the right edge in the brick once it collided so that it wont get stuck
                self.ball.y = bricks.y + 16
            end

            --Brick will be out of PlayState
            bricks:hit()

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
    for k, bricks in pairs(self.brick) do
        bricks:render()
    end

    --Displays PAUSE
    if self.pause then
        love.graphics.setFont(gFonts['largeFont'])
        love.graphics.printf('PAUSE', 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end