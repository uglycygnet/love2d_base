local input = require "src.input"

local menu = {}

function menu:enter()
    -- Define your exact list of choices
    self.options = {"Quick 1P Game", "Play", "Options", "Exit"}
    self.selected = 1 -- Start highlighted on item 1
    self.timer = 0
    self.showJoinText = true
end

function menu:update(dt)
    -- update flashing join text
    self.timer = (self.timer or 0) + dt
    if self.timer >= 0.6 then
        self.timer = self.timer - 0.6
        self.showJoinText = not self.showJoinText
    end

    -- allow Player 2 to join via keyboard or controller while in menu
    if #input.players < 2 then
        -- keyboard join
        if not input.joinedDevices["keyboard"] and (love.keyboard.isDown("return") or love.keyboard.isDown("space")) then
            input:registerPlayer("keyboard", nil)
        end

        -- controller join
        local joysticks = love.joystick.getJoysticks()
        for _, joystick in ipairs(joysticks) do
            if not input.joinedDevices[joystick] and (joystick:isGamepadDown("start") or joystick:isGamepadDown("a")) then
                input:registerPlayer("controller", joystick)
            end
        end
    end

    for _, player in ipairs(input.players) do
        if player:pressed('down') then
            print('down')
            self.selected = self.selected + 1
            if self.selected > #self.options then self.selected = 1 end
        elseif player:pressed('up') then
            print('up')
            self.selected = self.selected - 1
            if self.selected < 1 then self.selected = #self.options end
        end
        
        -- CHANGED: Use 'action' or 'start' to select menu items
        if player:pressed('action') or player:pressed('start') then
            print('action or start')
            self:executeChoice()
            break
        end
    end
end


function menu:draw()
    love.graphics.clear(0.05, 0.05, 0.05) -- dark background
    
    local startY = 200
    local spacing = 50
    
    for i, option in ipairs(self.options) do
        if i == self.selected then
            -- Highlighted item: Larger font size (or simulated styling)
            love.graphics.setNewFont(24)
            love.graphics.setColor(1, 1, 0) -- Yellow
            love.graphics.print("> " .. option, 300, startY + (i * spacing))
        else
            -- Normal item: Smaller font size
            love.graphics.setNewFont(16)
            love.graphics.setColor(1, 1, 1) -- White
            love.graphics.print(option, 320, startY + (i * spacing))
        end
    end

    -- flashing join prompt for Player 2 in top-right
    if #input.players < 2 and self.showJoinText then
        love.graphics.setNewFont(12)
        love.graphics.setColor(0.9, 0.9, 0.9)
        love.graphics.printf("Player 2 press START or ENTER to join", 0, 8, 380, "right")
        love.graphics.setColor(1, 1, 1)
    end
end

function menu:executeChoice()
    local choice = self.options[self.selected]
    if choice == "Exit" then
        love.event.quit()
    elseif choice == "Quick 1P Game" then
        -- Gamestate.switch(GameplayState)
    end
end

return menu
