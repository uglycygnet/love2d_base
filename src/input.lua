local baton = require "lib.baton"
local input = {
  players = {},       
  joinedDevices = {}  
}

function input.createPlayerInstance(deviceType, joystickDevice)
  return baton.new({
    controls = {
      left   = { deviceType == "keyboard" and "key:left" or nil,  "axis:leftx-", "button:dpleft" },
      right  = { deviceType == "keyboard" and "key:right" or nil, "axis:leftx+", "button:dpright" },
      up     = { deviceType == "keyboard" and "key:up" or nil,    "axis:lefty-", "button:dpup" },
      down   = { deviceType == "keyboard" and "key:down" or nil,  "axis:lefty+", "button:dpdown" },
      action = { deviceType == "keyboard" and "key:space" or nil, "button:a" },
      start  = { deviceType == "keyboard" and "key:return" or nil, "button:start" },
    },
    pairs = { move = {"left", "right", "up", "down"} },
    joystick = joystickDevice 
  })
end

function input:registerPlayer(deviceType, joystickDevice)
  local deviceKey = joystickDevice or "keyboard"
  
  -- Prevent double registration
  if self.joinedDevices[deviceKey] then return end 
  
  local nextIndex = #self.players + 1
  self.joinedDevices[deviceKey] = true
  self.players[nextIndex] = self.createPlayerInstance(deviceType, joystickDevice)
  
  print("Player " .. nextIndex .. " registered with " .. deviceType)
end

function input:update()
  -- Safe guard to prevent looping errors on empty sets
  if not self.players then return end
  
  for _, playerInput in ipairs(self.players) do
    -- Double check the Baton instance exists before calling update
    if playerInput and playerInput.update then
      playerInput:update()
    end
  end
end

return input

