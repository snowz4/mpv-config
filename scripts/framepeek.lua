-- framepeek.lua
-- Shows current frame / total frames on OSD when frame-stepping with , and .

local mp = require("mp")

local pending_timer = nil
local last_press_time = 0

local function show_frame_pos()
    if pending_timer then
        pending_timer:kill()
        pending_timer = nil
    end
    pending_timer = mp.add_timeout(0.1, function()
        local current = mp.get_property_number("estimated-frame-number", 0)
        local total = mp.get_property_number("estimated-frame-count", 0)
        mp.osd_message(string.format("%d / %d", current, total), 1)
    end)
end

local function get_frame_duration()
    local fps = mp.get_property_number("container-fps", 24)
    return 1.0 / fps
end

local function step(direction)
    mp.commandv("script-message", "pause-indicator-ignore")

    local now = mp.get_time()
    local is_repeat = (now - last_press_time) < 0.25
    last_press_time = now

    if is_repeat then
        -- When holding the key, use seek to avoid frame-step's pause toggle
        local d = get_frame_duration() * direction
        mp.commandv("no-osd", "seek", tostring(d), "exact")
    else
        -- Single press: use precise frame-step
        mp.set_property_bool("pause", true)
        if direction > 0 then
            mp.command("no-osd frame-step")
        else
            mp.command("no-osd frame-back-step")
        end
    end

    show_frame_pos()
end

mp.add_key_binding(".", "frame-step-counter", function() step(1) end, {repeatable = true})
mp.add_key_binding(",", "frame-back-counter", function() step(-1) end, {repeatable = true})
