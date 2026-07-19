local baton = require "lib.baton"

local input = {
    players = {} -- This array will hold our individual player input objects
}

-- Your exact configuration blueprint, moved inside a reusable constructor function
function input.createPlayerInstance(playerIndex, joystickDevice)
    return baton.new({
        controls = {
            -- If it's Player 2+, we ignore keyboard bindings so they don't fight over the same keys
            left   = { playerIndex == 1 and 'key:a' or nil, 'axis:leftx-', 'button:dpleft' },
            right  = { playerIndex == 1 and 'key:d' or nil, 'joy:axis1+', 'axis:leftx+', 'button:dpright' },     
            up     = { playerIndex == 1 and 'key:w' or nil, 'button:dpup', 'axis:lefty-', 'button:dpup' },        
            down   = { playerIndex == 1 and 'key:s' or nil, 'joy:axis2+', 'axis:lefty+', 'button:dpdown' },      
            action = { playerIndex == 1 and 'key:space' or nil, 'button:a' },
            start  = { playerIndex == 1 and 'key:return' or nil, 'button:start' },
        },
        pairs = {
            move = {'left', 'right', 'up', 'down'}
        },
        joystick = joystickDevice -- Directly links this instance to controller 1, 2, 3, etc.
    })
end

-- A setup function you run once on game startup to look for controllers
function input:initialize()
    local connectedJoysticks = love.joystick.getJoysticks()
    
    -- Always create at least Player 1 (Keyboard defaults)
    self.players[1] = self.createPlayerInstance(1, connectedJoysticks[1])
    
    -- Dynamically scale up for every extra controller found plugged in
    for i = 2, #connectedJoysticks do
        self.players[i] = self.createPlayerInstance(i, connectedJoysticks[i])
    end
end

-- A single utility call to update all identified players at once
function input:update()
    for _, playerInput in ipairs(self.players) do
        playerInput:update()
    end
end

return input
