-- ADDED NEW CLASS ---------------------------------------------------------------------------------------------------
PowerUps = Class{}

function PowerUps:init(skin)
    self.x = math.random(5, VIRTUAL_WIDTH - 26)
    self.y = 0
    self.width = 16
    self.height = 16
    self.dy = 0

    self.skin = skin
    self.spawn = false
end

function PowerUps:update(dt)
    self.y = self.y + self.dy
end

function PowerUps:reset()
    self.spawn = false
end

function PowerUps:collides(target)
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end

    return true
end

function PowerUps:render()
    if self.spawn == true then
        love.graphics.draw(gTextures['main'], gFrames['power'][self.skin], self.x, self.y)
    end
end