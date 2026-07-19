local input = require "src.input"

local menu = {}

function menu:enter()
    -- Define your exact list of choices
    self.options = {"Quick 1P Game", "Play", "Options", "Exit"}
    self.selected = 1 -- Start highlighted on item 1
end

function menu:update(dt)
    for _, player in ipairs(input.players) do
        if player:pressed('down') then
            self.selected = self.selected + 1
            if self.selected > #self.options then self.selected = 1 end
        elseif player:pressed('up') then
            self.selected = self.selected - 1
            if self.selected < 1 then self.selected = #self.options end
        end
        
        -- CHANGED: Use 'action' or 'start' to select menu items
        if player:pressed('action') or player:pressed('start') then
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
