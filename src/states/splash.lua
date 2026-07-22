local Gamestate = require "lib.hump.gamestate"
local Timer = require "lib.hump.timer"
local TitleState = require "src.states.title"
local shakes = require "src.system.shakes"

local splash = {}

function splash:enter()
    -- Load your logo image asset here
    -- self.logo = love.graphics.newImage("assets/images/logo.png")
    
    self.alpha = 0 -- Start fully invisible
    
    -- Sequence: Fade In (1s) -> Stay (1.5s) -> Fade Out (1s) -> Switch State
    Timer.tween(1.0, self, {alpha = 1}, 'linear', function()
        Timer.after(1.5, function()
            shakes.trigger(shakes.current.power,0.5,CurrentTime)
            Timer.tween(1.0, self, {alpha = 0}, 'linear', function()
                Gamestate.switch(TitleState)
            end)
        end)
    end)
end

function splash:update(dt)
    Timer.update(dt) -- Keep HUMP's timer ticking
    CurrentTime = love.timer.getTime()
end

function splash:draw()
    love.graphics.clear(0, 0, 0) -- Pure black background
    shakes.drawShakeScreen(shakes.current.power, CurrentTime)

    
    -- Set drawing color with the dynamic transparency value
    love.graphics.setColor(1, 1, 1, self.alpha)
    
    -- Draw text placeholder (or replace with love.graphics.draw(self.logo, ...))
    love.graphics.setNewFont(16)
    love.graphics.printf("COMPANY LOGO HERE", 0, 140, 400, "center")
    
    
    -- Always reset color back to full white so it doesn't bleed into other draws
    love.graphics.setColor(1, 1, 1, 1)
end

return splash
