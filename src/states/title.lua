local Gamestate = require "lib.hump.gamestate"
local Timer = require "lib.hump.timer"
local input = require "src.input"
local MenuState = require "src.states.menu"
local themes = require "src.preferences.themes"
local shakes = require "src.system.shakes"

local title = {}

function title:enter()
    self.showText = true
    
    -- Clear any old active players if returning to title screen
    input.players = {}
    input.joinedDevices = {}
    
    Timer.every(0.6, function()
        self.showText = not self.showText
    end)
end

function title:update(dt)
    Timer.update(dt)
    CurrentTime = love.timer.getTime()
    
    -- 1. Check if Keyboard pressed Enter/Return to claim Player 1
    if love.keyboard.isDown("return") or love.keyboard.isDown("space") then
        shakes.trigger(shakes.current.power,0.5,CurrentTime)
        input:registerPlayer("keyboard", nil)
        Timer.after(0.5, function()
            Gamestate.switch(MenuState)
        end)
        return
    end
    
    -- 2. Check if ANY connected controller pressed Start or A to claim Player 1
    local joysticks = love.joystick.getJoysticks()
    for _, joystick in ipairs(joysticks) do
        if joystick:isGamepadDown("start") or joystick:isGamepadDown("a") then
            shakes.trigger(shakes.current.power,1.0,CurrentTime)
            input:registerPlayer("controller", joystick)
            Timer.after(1.0, function()
                Gamestate.switch(MenuState)
            end)
            return
        end
    end
end

function title:draw()
    love.graphics.clear(themes.current.background) 
    shakes.drawShakeScreen(shakes.current.power, CurrentTime)
    
    love.graphics.setNewFont(24)
    love.graphics.setColor(themes.current.primary)
    love.graphics.printf("MY EPIC GAME", 0, 80, 400, "center") 
    
    if self.showText then
        love.graphics.setNewFont(12)
        love.graphics.setColor(themes.current.secondary)
        love.graphics.printf("PRESS START / ENTER", 0, 180, 400, "center")
    end
    
    love.graphics.setColor(1, 1, 1, 1)
end

return title
