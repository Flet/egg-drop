-- Audio System
-- Manages game audio with pitch variation for natural sound variety

local Audio = {}

-- Sound source pools
Audio.sounds = {
    dropSources = {},    -- Pool of sources for overlapping plays
    bounceSources = {},  -- Pool for bounce sounds (circle pegs)
    clickSources = {},   -- Pool for click sounds (rectangle pegs)
    sweepSources = {},   -- Pool for sweep sounds (target hits)
    clackSources = {}    -- Pool for clack sounds (wall/barrier hits)
}

-- Track which source to use next (round-robin)
Audio.dropSourceIndex = 1
Audio.bounceSourceIndex = 1
Audio.clickSourceIndex = 1
Audio.sweepSourceIndex = 1
Audio.clackSourceIndex = 1

function Audio:init()
    print("Audio: Initializing...")

    -- Create source pool for drop sounds (allows up to 4 simultaneous drops)
    local dropPath = "assets/sounds/pop.ogg"
    for i = 1, 4 do
        local source = love.audio.newSource(dropPath, "static")
        if source then
            table.insert(self.sounds.dropSources, source)
        else
            print("ERROR: Could not load " .. dropPath)
            return false
        end
    end

    -- Create source pool for bounce sounds (circle pegs, up to 8 simultaneous)
    local bouncePath = "assets/sounds/bounce.ogg"
    for i = 1, 8 do
        local source = love.audio.newSource(bouncePath, "static")
        if source then
            table.insert(self.sounds.bounceSources, source)
        else
            print("ERROR: Could not load " .. bouncePath)
            return false
        end
    end

    -- Create source pool for click sounds (rectangle pegs, up to 8 simultaneous)
    local clickPath = "assets/sounds/click.ogg"
    for i = 1, 8 do
        local source = love.audio.newSource(clickPath, "static")
        if source then
            table.insert(self.sounds.clickSources, source)
        else
            print("ERROR: Could not load " .. clickPath)
            return false
        end
    end

    -- Create source pool for sweep sounds (target hits, up to 6 simultaneous)
    local sweepPath = "assets/sounds/sweep.ogg"
    for i = 1, 6 do
        local source = love.audio.newSource(sweepPath, "static")
        if source then
            table.insert(self.sounds.sweepSources, source)
        else
            print("ERROR: Could not load " .. sweepPath)
            return false
        end
    end

    -- Create source pool for clack sounds (wall/barrier hits, up to 8 simultaneous)
    local clackPath = "assets/sounds/clack.ogg"
    for i = 1, 8 do
        local source = love.audio.newSource(clackPath, "static")
        if source then
            table.insert(self.sounds.clackSources, source)
        else
            print("ERROR: Could not load " .. clackPath)
            return false
        end
    end

    print("Audio: Loaded " .. #self.sounds.dropSources .. " drop, " ..
          #self.sounds.bounceSources .. " bounce, " ..
          #self.sounds.clickSources .. " click, " ..
          #self.sounds.sweepSources .. " sweep, " ..
          #self.sounds.clackSources .. " clack sources")
    return true
end

function Audio:playDropSound()
    -- Get next source in pool (round-robin)
    local source = self.sounds.dropSources[self.dropSourceIndex]

    -- Cycle to next source for next call
    self.dropSourceIndex = self.dropSourceIndex + 1
    if self.dropSourceIndex > #self.sounds.dropSources then
        self.dropSourceIndex = 1
    end

    -- Only play if source is not already playing (web compatibility)
    if not source:isPlaying() then
        -- Random pitch variation: 0.6 to 1.1 (50% variation)
        local pitchVariation = 0.6 + math.random() * 0.5
        source:setPitch(pitchVariation)

        -- Play without seek (avoid love.js bug)
        love.audio.play(source)
    end
end

function Audio:playBounceSound()
    -- Get next source in pool (round-robin)
    local source = self.sounds.bounceSources[self.bounceSourceIndex]

    -- Cycle to next source for next call
    self.bounceSourceIndex = self.bounceSourceIndex + 1
    if self.bounceSourceIndex > #self.sounds.bounceSources then
        self.bounceSourceIndex = 1
    end

    -- Only play if source is not already playing (web compatibility)
    if not source:isPlaying() then
        -- Random pitch variation: 0.9 to 1.1 (10% variation each way)
        local pitchVariation = 0.9 + math.random() * 0.2
        source:setPitch(pitchVariation)

        -- Play without seek (avoid love.js bug)
        love.audio.play(source)
    end
end

function Audio:playClickSound()
    -- Get next source in pool (round-robin)
    local source = self.sounds.clickSources[self.clickSourceIndex]

    -- Cycle to next source for next call
    self.clickSourceIndex = self.clickSourceIndex + 1
    if self.clickSourceIndex > #self.sounds.clickSources then
        self.clickSourceIndex = 1
    end

    -- Only play if source is not already playing (web compatibility)
    if not source:isPlaying() then
        -- Random pitch variation: 0.95 to 1.05 (5% variation each way - subtle)
        local pitchVariation = 0.95 + math.random() * 0.1
        source:setPitch(pitchVariation)

        -- Play without seek (avoid love.js bug)
        love.audio.play(source)
    end
end

function Audio:playSweepSound()
    -- Get next source in pool (round-robin)
    local source = self.sounds.sweepSources[self.sweepSourceIndex]

    -- Cycle to next source for next call
    self.sweepSourceIndex = self.sweepSourceIndex + 1
    if self.sweepSourceIndex > #self.sounds.sweepSources then
        self.sweepSourceIndex = 1
    end

    -- Only play if source is not already playing (web compatibility)
    if not source:isPlaying() then
        -- Random pitch variation: 0.9 to 1.1 (10% variation - satisfying sweep)
        local pitchVariation = 0.9 + math.random() * 0.2
        source:setPitch(pitchVariation)

        -- Play without seek (avoid love.js bug)
        love.audio.play(source)
    end
end

function Audio:playClackSound()
    -- Get next source in pool (round-robin)
    local source = self.sounds.clackSources[self.clackSourceIndex]

    -- Cycle to next source for next call
    self.clackSourceIndex = self.clackSourceIndex + 1
    if self.clackSourceIndex > #self.sounds.clackSources then
        self.clackSourceIndex = 1
    end

    -- Only play if source is not already playing (web compatibility)
    if not source:isPlaying() then
        -- Random pitch variation: 0.95 to 1.05 (5% variation - sharp clack)
        local pitchVariation = 0.95 + math.random() * 0.1
        source:setPitch(pitchVariation)

        -- Play without seek (avoid love.js bug)
        love.audio.play(source)
    end
end

return Audio
