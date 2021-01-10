--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

PlayState = Class{__includes = BaseState}

local skin = {
    [1] = 4,
    [2] = 10,
}

lockBrick = false
--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]
function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.ball = {params.ball}
    self.level = params.level

    self.recoverPoints = params.recoverPoints

    -- growth points for paddle
    self.paddleGrowth = params.paddleGrowth

    -- give ball random starting velocity --> for multiball power up too
    self.ball[1].dx = math.random(-200, 200)
    self.ball[1].dy = math.random(-50, -60)

-- ADDED: POWER UP init-----------------------------------------------
    self.powerUp = PowerUps(skin[math.random(2)])

    self.timer = 0
    self.spawnTime = math.random(5, 15)
    -- spawn can can double once a power up is activated...
----------------------------------------------------------------------

-- ADDED: LOCK BRICK KEY init ----------------------------------------
    self.keys = params.keys
----------------------------------------------------------------------
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    -- update positions based on velocity
    self.paddle:update(dt)

--- ADDED: POWER UP update(dt) -----------------------------------------------------------------------
    self.powerUp:update(dt)
    self.timer = self.timer + dt

    -- spawning of power up based on timer
    if self.timer > self.spawnTime then
        self.powerUp.dy = self.powerUp.dy + 100 * dt
        self.powerUp.spawn = true

        self.timer = 0
    end

    -- power up collision to the paddle
    if self.powerUp:collides(self.paddle) then
        if self.powerUp.skin == 4 then
            gSounds['confirm']:play()
        -- ADDED: MULTIBALL power up
            for i = 0, 1 do
                ball = Ball()
                ball.skin = math.random(7)
                ball.x = self.ball[1].x
                ball.y = self.ball[1].y
                ball.dx = self.ball[1].dx + math.random(-200, 200)
                ball.dy = self.ball[1].dy + math.random(-50, 60)

                table.insert(self.ball, ball)
            end

        elseif self.powerUp.skin == 10 then
            gSounds['victory']:play()
        -- ADDED: LOCK BRICK KEY
            self.keys = self.keys + 1

        else
            gSounds['no-select']:play()
        end

        -- reset
        self.powerUp:reset()
        self.timer = 0
        self.spawnTime = math.random(5, 15)
        self.powerUp = PowerUps(skin[math.random(2)])
    end

    --  reset
    if self.powerUp.y >= VIRTUAL_HEIGHT then
        self.powerUp:reset()
        self.timer = 0
        self.spawnTime = math.random(5, 15)
        self.powerUp = PowerUps(skin[math.random(2)])
    end
----------------------------------------------------------------------------------

    for l, ball in pairs(self.ball) do
        ball:update(dt)
    end

    for l, ball in pairs(self.ball) do
        if ball:collides(self.paddle) then
            -- raise ball above paddle in case it goes below it, then reverse dy
            ball.y = self.paddle.y - 8
            ball.dy = -ball.dy

            --
            -- tweak angle of bounce based on where it hits the paddle
            --

            -- if we hit the paddle on its left side while moving left...
            if ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
                ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - ball.x))
            
            -- else if we hit the paddle on its right side while moving right...
            elseif ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
                ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - ball.x))
            end

            gSounds['paddle-hit']:play()
        end
    end

        -- detect collision across all bricks with the ball
    for l, ball in pairs(self.ball) do
        for k, brick in pairs(self.bricks) do
            -- only check collision if we're in play
            if brick.inPlay and ball:collides(brick) then

    -- CHANGED: scoring with locked brick ----------------------------------------------------
                if brick.locked == false then
                    self.score = self.score + (brick.tier * 200 + brick.color * 25)

                    -- trigger the brick's hit function, which removes it from play
                    brick:hit()
                end

                if self.keys >= 1 and brick.locked == true then
                    self.score = self.score + 5000
                    self.keys = self.keys - 1
                    brick.inPlay = false

                    brick:lockHit()
                end

                if brick.locked == true then
                    gSounds['brick-hit-2']:play()
                end
    -------------------------------------------------------------------------------------------

                -- if we have enough points, recover a point of health
                if self.score > self.recoverPoints then
                    self.health = math.min(3, self.health + 1)

                    -- multiply recover points by 2
                    self.recoverPoints = math.min(1000000, self.recoverPoints * 2)

                    -- play recover sound effect
                    gSounds['recover']:play()
                end

            -- ADDED: paddle growth ------------------------------------------------------------------------
                if self.score > self.paddleGrowth then
                -- ADDED: grow function
                    self:grow()

                    -- multiply paddle growth points by 2
                    self.paddleGrowth = math.min(1000000, self.paddleGrowth * 2)

                    gSounds['recover']:play()
                end
            -------------------------------------------------------------------------------------------------

                -- go to our victory screen if there are no more bricks left
                if self:checkVictory() then
                    gSounds['victory']:play()

                    gStateMachine:change('victory', {
                        level = self.level,
                        paddle = self.paddle,
                        health = self.health,
                        score = self.score,
                        highScores = self.highScores,
                        ball = self.ball,
                        recoverPoints = self.recoverPoints,
                        paddleGrowth = self.paddleGrowth,
                        keys = self.keys
                    })
                end

                --
                -- collision code for bricks
                --
                -- we check to see if the opposite side of our velocity is outside of the brick;
                -- if it is, we trigger a collision on that side. else we're within the X + width of
                -- the brick and should check to see if the top or bottom edge is outside of the brick,
                -- colliding on the top or bottom accordingly 
                --

                -- left edge; only check if we're moving right, and offset the check by a couple of pixels
                -- so that flush corner hits register as Y flips, not X flips
                if ball.x + 2 < brick.x and ball.dx > 0 then
                    
                    -- flip x velocity and reset position outside of brick
                    ball.dx = -ball.dx
                    ball.x = brick.x - 8
                
                -- right edge; only check if we're moving left, , and offset the check by a couple of pixels
                -- so that flush corner hits register as Y flips, not X flips
                elseif ball.x + 6 > brick.x + brick.width and ball.dx < 0 then
                    
                    -- flip x velocity and reset position outside of brick
                    ball.dx = -ball.dx
                    ball.x = brick.x + 32
                
                -- top edge if no X collisions, always check
                elseif ball.y < brick.y then
                    
                    -- flip y velocity and reset position outside of brick
                    ball.dy = -ball.dy
                    ball.y = brick.y - 8
                
                -- bottom edge if no X collisions or top collision, last possibility
                else
                    
                    -- flip y velocity and reset position outside of brick
                    ball.dy = -ball.dy
                    ball.y = brick.y + 16
                end

                -- slightly scale the y velocity to speed up the game, capping at +- 150
                if math.abs(ball.dy) < 150 then
                    ball.dy = ball.dy * 1.02
                end

                -- only allow colliding with one brick, for corners
                break
            end
        end
    end

--- CHANGED: added for loop and for the extraballs -----------------------
    for l, ball in pairs(self.ball) do
        if ball.y >= VIRTUAL_HEIGHT then
            table.remove(self.ball, l)
        end
    end

    -- checks if extra balls are gone
    if #self.ball == 0 then
        self.health = self.health - 1
        if self.health == 0 then
            gSounds['hurt']:play()
            gStateMachine:change('game-over', {
                score = self.score,
                highScores = self.highScores
            })

        else
            gSounds['hurt']:play()
            gStateMachine:change('serve', {
                paddle = self.paddle,
                ball = self.ball,
                bricks = self.bricks,
                health = self.health,
                score = self.score,
                highScores = self.highScores,
                level = self.level,
                recoverPoints = self.recoverPoints,
                paddleGrowth = self.paddleGrowth,
                keys = self.keys
            })

        -- ADDED: shrink function and extra ball
            self:paddleShrink()
        end
    end
--------------------------------------------------------------------------

    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    -- render bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    -- render all particle systems
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

--- ADDED: POWER UP render --------------------------------------
    self.powerUp:render()
-----------------------------------------------------------------

    self.paddle:render()

--- CHANGED: created a for loop so the balls are rendering in synce ------
    for l, ball in pairs(self.ball) do
        ball:render()
    end
---------------------------------------------------------------------------

    renderScore(self.score)
    renderHealth(self.health)
    renderKeys(self.keys)

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
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

-- ADDED: groow and shrink functions for paddle -----------------------------------
function PlayState:paddleShrink()
    if self.health < 3 then
        gSounds['hurt']:play()
        self.paddle.size = self.paddle.size - 1
        self.paddle.width = self.paddle.width - 32

        if self.paddle.size < 1 then
            self.paddle.size = 1
            self.paddle.width = 32
        end
    end
end

function PlayState:grow()
    self.paddle.size = self.paddle.size + 1
    self.paddle.width = self.paddle.width + 32

    if self.paddle.size > 4 then
        self.paddle.size = 4
        self.paddle.width = 128
    end
end
----------------------------------------------------------------------------------------