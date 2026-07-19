function love.conf(t)
    -- Identity and Window metadata
    t.identity = "my_custom_love_game"
    t.version = "11.5" -- Fits standard LÖVE 11.x releases
    
    -- Set the physical window size (Push will scale the pixel art to fit this)
    t.window.width = 1280                  
    t.window.height = 720                 
    t.window.resizable = true -- Let players stretch the window freely
    t.window.vsync = 1    
    
    -- Modules to enable/disable (Disabling unused ones saves system memory)
    t.modules.audio = true
    t.modules.data = true
    t.modules.event = true
    t.modules.font = true
    t.modules.graphics = true
    t.modules.image = true
    t.modules.joystick = true              -- Crucial for Baton controller support
    t.modules.keyboard = true              -- Crucial for Baton keyboard support
    t.modules.math = true
    t.modules.mouse = true
    t.modules.physics = false              -- Turn true only if using Box2D physics
    t.modules.sound = true
    t.modules.system = true
    t.modules.timer = true
    t.modules.touch = false                -- Turn true only for mobile/touch targets
    t.modules.video = false                -- Turn true only if playing raw .ogv video files
end
