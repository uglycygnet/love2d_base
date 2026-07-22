local baton = require "lib.baton"
local input = {
  players = {},       
  joinedDevices = {}  
}

function input.createPlayerInstance(deviceType, joystickDevice)
  local isKeyboard = deviceType == "keyboard"
  local controls = {
    left = isKeyboard and {"key:left", "axis:leftx-", "button:dpleft"} or {"axis:leftx-", "button:dpleft"},
    right = isKeyboard and {"key:right", "axis:leftx+", "button:dpright"} or {"axis:leftx+", "button:dpright"},
    up = isKeyboard and {"key:up", "axis:lefty-", "button:dpup"} or {"axis:lefty-", "button:dpup"},
    down = isKeyboard and {"key:down", "axis:lefty+", "button:dpdown"} or {"axis:lefty+", "button:dpdown"},
    action = isKeyboard and {"key:space", "button:a"} or {"button:a"},
    start = isKeyboard and {"key:return", "button:start"} or {"button:start"},
  }

  return baton.new({
    controls = controls,
    pairs = { move = {"left", "right", "up", "down"} },
    joystick = joystickDevice,
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

