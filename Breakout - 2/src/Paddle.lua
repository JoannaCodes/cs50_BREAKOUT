--Update: ALL
Paddle = Class{}

function Paddle:init()
    --Paddle position
    self.x = VIRTUAL_WIDTH / 2 - 32
    self.y = VIRTUAL_HEIGHT - 32

    --Default paddle size. Medium Paddle: 64x16
    self.width = 64
    self.height = 16

    --Paddle Velocity
    self.dx = 0

    --Paddle colors: Blue as default color. The table for the quad starts at 1
    --1:Blue, 2:Green, 3:Red, 4:Violet
    self.skin = 1

    --Paddle sizes: Medium as default size
    --1:Small, 2:Medium, 3:Large, 4:Huge
    self.size = 2
end

function Paddle:update(dt)
    --Paddle movement (left and right)
    if love.keyboard.isDown('left') then
        self.dx = -PADDLE_SPEED
    elseif love.keyboard.isDown('right') then
        self.dx = PADDLE_SPEED
    else
        self.dx = 0 --No movement
    end

    --Screen boundary
    if self.dx < 0 then
        self.x = math.max(0, self.x + self.dx * dt)
    else
        self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
    end
end

function Paddle:render()
    --Displays certain quad
    --love.graphics.draw(texture, quad, x, y)
    -- quad:[quad table][specific position of quad]
    --[self.size + 4 * (self.skin - 1)] is for changing the quad skin 
    --since there are 4 paddles each skin, when the user is choosing it will shift 4 quads to the next color
    -- gTexture is our global texture for all blocks
    -- gBallFrames is a table of quads mapping to each individual ball skin in the texture
    love.graphics.draw(gTextures['main'], gFrames['paddle'][self.size + 4 * (self.skin - 1)], self.x, self.y)
end