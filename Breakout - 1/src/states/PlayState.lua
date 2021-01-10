--Update: ALL
PlayState = Class{__includes = BaseState}

function PlayState:init()
    --Initializing Paddle, Ball, & Bricks Class
    self.paddle = Paddle()
    --the skin default is 1: Blue. The table for the quad starts at 1
    self.ball = Ball(math.random(7))


    --Ball position
    self.ball.x = VIRTUAL_WIDTH / 2 - 5
    self.ball.y = VIRTUAL_HEIGHT - 42

    --Ball velocity
    self.ball.dx = math.random(-200, 200)
    self.ball.dy = math.random(-50, -60)

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
        --Shifts the ball above the paddle once it collided so that it wont get stuct and repeat the collision
        self.ball.y = self.paddle.y - 8
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

    --Displays PAUSE
    if self.pause then
        love.graphics.setFont(gFonts['largeFont'])
        love.graphics.printf('PAUSE', 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end