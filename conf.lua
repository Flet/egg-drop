function love.conf(t)
    -- Game identity (used for save data folder)
    t.identity = "lovely-egg-drop"
    t.version = "11.4"  -- Love2D version compatibility (11.4 for love.js web builds)

    -- Window configuration
    t.window.title = "Egg Drop"
    t.window.icon = nil
    t.window.width = 1280
    t.window.height = 720
    t.window.borderless = false
    t.window.resizable = false
    t.window.minwidth = 1280
    t.window.minheight = 720
    t.window.fullscreen = false
    t.window.fullscreentype = "desktop"
    t.window.vsync = 1  -- Enable vsync for smooth 60fps
    t.window.msaa = 0   -- No anti-aliasing (we want crisp pixels)
    t.window.display = 1
    t.window.highdpi = false
    t.window.x = nil
    t.window.y = nil

    -- Modules to enable/disable
    t.modules.audio = true
    t.modules.data = true
    t.modules.event = true
    t.modules.font = true
    t.modules.graphics = true
    t.modules.image = true
    t.modules.joystick = false  -- Disable joystick (not needed)
    t.modules.keyboard = true
    t.modules.math = true
    t.modules.mouse = true
    t.modules.physics = false   -- Disable Box2D (custom physics)
    t.modules.sound = true
    t.modules.system = true
    t.modules.thread = false    -- Disable threading (not needed)
    t.modules.timer = true
    t.modules.touch = false     -- Disable touch (not needed)
    t.modules.video = false     -- Disable video (not needed)
    t.modules.window = true

    -- Console (useful for debugging on Windows)
    t.console = true  -- Set to false for release builds

    -- Accelerometer (mobile)
    t.accelerometerjoystick = false

    -- Audio
    t.audio.mixwithsystem = true
end
