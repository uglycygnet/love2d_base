local Gamestate = require "lib.hump.gamestate"
local moonshine = require "lib.moonshine"
local push = require "lib.push"
local input = require "src.input"

-- Load your sequential states
local IntroState = require "src.states.intro"

-- Define your internal retro game resolution
local VIRTUAL_WIDTH = 400
local VIRTUAL_HEIGHT = 300

local effect

function love.load()
    -- Look for hardware and build the player inputs dynamically
    input:initialize()
    
    
    -- Set up Push with your virtual resolution vs physical window size
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, 1280, 720, {
        fullscreen = false,
        resizable = true,
        pixelperfect = true -- Ensures sharp pixels, no blurry scaling
    })
    
    -- Initialize your shader stack (e.g., CRT and Vignette effect)
    effect = moonshine(moonshine.effects.crt)
                      .chain(moonshine.effects.vignette)
    
    -- Direct HUMP to automatically hook into love.update, love.draw, etc.
    Gamestate.registerEvents()
    
    -- Start the sequence!
    Gamestate.switch(IntroState)
end

function love.update(dt)
    input:update() -- Keep Baton polling for inputs every frame
end

-- Override love.draw so Moonshine wraps around whatever HUMP is currently drawing
function love.draw()
    effect(function()
        push:start()
            Gamestate.current():draw()
        push:finish()
    end)
end

-- Crucial: Pass window adjustments directly to the push library
function love.resize(w, h)
    push:resize(w, h)
end
