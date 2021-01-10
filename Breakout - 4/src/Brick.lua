--Update: Particles
Brick = Class{}

--Should be based on the heirch of the bricks
pallete = {
    --blue
    [3] = {
        ['r'] = 217,
        ['g'] = 87,
        ['b'] = 99
    },

    --green
    [2] = {
        ['r'] = 106,
        ['g'] = 190,
        ['b'] = 47
    },

    --red
    [1] = {
        ['r'] = 99,
        ['g'] = 155,
        ['b'] = 255
    },

    --purple
    [4] = {
        ['r'] = 251,
        ['g'] = 123,
        ['b'] = 186
    },

    --gold
    [5] = {
        ['r'] = 251,
        ['g'] = 242,
        ['b'] = 54
    }
}

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

    --Initialize newParticleSystem()
    --love2D's function for particles: love.graphics,newParticleSystem(texture, particles) or (image, buffer)
    --Wher image:The image to use.
    --number buffer (1000): the max number of particles at the same time.
    self.pSystem = love.graphics.newParticleSystem(gTextures['particle'], 64)

    --Settings of newParticleSystem()
    self.pSystem:setParticleLifetime(0.5, 1) --Span of particles in the PlayState()
    self.pSystem:setLinearAcceleration(-15, 0, 15, 80) -- Movement (going down).
    self.pSystem:setEmissionArea('normal', 10, 10) --Spread of particle
end

function Brick:hit()
    gSounds['brick-hit-2']:stop()
    gSounds['brick-hit-2']:play()

    --Sets color of particle depending on the brick
    self.pSystem:setColors(
        pallete[self.color].r / 255,
        pallete[self.color].g / 255,
        pallete[self.color].b / 255,
        55 * (self.tier + 1) / 255,
        pallete[self.color].r / 255,
        pallete[self.color].g / 255,
        pallete[self.color].b / 255,
        0
    ) --Fades to transparency

    self.pSystem:emit(64) --Particles live at least 2s and at most 5s.

    --if tier value is greater than 0 which is for striped colored brick and color is set to 1 then
    --tier will decrement and color will be set to 5 (last plain brick) then will go through another condition
    if self.tier > 0 then
        if self.color == 1 then
            self.tier = self.tier - 1
            self.color = 5
        
        --if color is greater than 1 (1-5 plain bricks) then
        --color will decrement
        else
            self.color = self.color - 1
        end
    else
        if self.color == 1 then
            self.inPlay = false
        else
            self.color = self.color - 1
        end
    end

    if not self.inPlay then
        gSounds['brick-hit-1']:stop()
        gSounds['brick-hit-1']:play()
    end
end

--For particle movement
function Brick:update(dt)
    self.pSystem:update(dt)
end

function Brick:render()
    if self.inPlay then
        love.graphics.draw(gTextures['main'], 
        --Multiply color by 4 (-1) to get our color offset, then add tier to that
        --To draw the correct tier and color brick onto the screen
        gFrames['bricks'][1 + ((self.color - 1) * 4) + self.tier],
        self.x, self.y)
    end
end

--For displaying pacrticles
function Brick:renderParticles()
    love.graphics.draw(self.pSystem, self.x + 16, self.y + 8)
end