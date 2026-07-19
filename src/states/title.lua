local Gamestate = require "lib.hump.gamestate"
local Timer = require "lib.hump.timer"
local input = require "src.input"
local MenuState = require "src.states.menu"

local title = {}

function title:enter()
    self.showText = true
    
    -- Create a continuous loop that toggles text visibility every 0.6 seconds
    Timer.every(0.6, function()
        self.showText = not self.showText
    end)
end

function title:update(dt)
    Timer.update(dt)
    
    -- Loop through all active player instances so ANY connected controller/keyboard can skip the title
    for _, player in ipairs(input.players) do
        if player:pressed('action') or player:pressed('start') then
            Gamestate.switch(MenuState)
            break -- Stop checking once a button press triggers the transition
        end
    end
end

function title:draw()
    love.graphics.clear(0.02, 0.02, 0.05) -- Very dark blue background
    
    -- Draw Main Game Title
    love.graphics.setNewFont(24)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("MY EPIC GAME", 0, 80, 400, "center") -- 400 is virtual width
    
    -- Draw Blinking Subtext
    if self.showText then
        love.graphics.setNewFont(12)
        love.graphics.setColor(0.7, 0.7, 0.7)
        love.graphics.printf("PRESS START / ENTER", 0, 180, 400, "center")
    end
    
    -- Clean up draw color
    love.graphics.setColor(1, 1, 1, 1)
end

return title
