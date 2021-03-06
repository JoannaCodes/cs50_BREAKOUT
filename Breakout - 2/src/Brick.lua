--Update:
Brick = Class{}

function Brick:init(x, y)
    --Brick colors
    self.tier = 0 --stripped
    self.color = 1 --plain

    --Brick position
    self.x = x
    self.y = y

    --Brick size
    self.width = 32
    self.height = 16

    self.inPlay = true
end

function Brick:hit()
    gSounds['brick-hit-2']:play()
    self.inPlay = false
end

function Brick:render()
    if self.inPlay then
        love.graphics.draw(gTextures['main'], 
            -- multiply color by 4 (-1) to get our color offset, then add tier to that
            -- to draw the correct tier and color brick onto the screen
            gFrames['bricks'][1 + ((self.color - 1) * 4) + self.tier],
            self.x, self.y)
    end
end