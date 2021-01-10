--Update:
Ball = Class{}

function Ball:init(skin)
    self.width = 8
    self.height = 8

    self.dx = 0--math.random(2) == 1 and -100 or 100
    self.dy = 0--math.random(100,150)

    self.skin = skin
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    --Right wall bounce
    if self.x <= 0 then
        gSounds['wall_hit']:play()
        self.x = 0
        self.dx = -self.dx
    end

    --Right wall bounce
    if self.x >= VIRTUAL_WIDTH - 8 then
        gSounds['wall_hit']:play()
        self.x = VIRTUAL_WIDTH - 8
        self.dx = -self.dx
    end

    --Upper wall bounce
    if self.y <= 0 then
        gSounds['wall_hit']:play()
        self.y = 0
        self.dy = -self.dy
    end
end

function Ball:reset()
    --Reset position of ball
    self.x = VIRTUAL_WIDTH / 2 - 5
    self.y = VIRTUAL_HEIGHT - 42

    self.dx = 0
    self.dy = 0
end

function Ball:collision(target)
    --No collision
    if self.x > (target.x + target.width) or target.x > (self.x + self.width ) then
        return false
    end
    if self.y > (target.y + target.height) or target.y > (self.y + self.height ) then
        return false
    end

    --There is collision
    return true
end

function Ball:render()
    --Displays ball
    --love.graphics.draw(texture, quad, x, y)
    -- quad:[quad table][specific position of quad]
    --[self.skin] sets the quad skin
    love.graphics.draw(gTextures['main'], gFrames['ball'][self.skin], self.x, self.y)
end