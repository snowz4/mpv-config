-- framepeek.lua
-- Shows current frame / total frames on OSD when frame-stepping with , and .

local mp = require("mp")

local pending_timer = nil

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

mp.add_key_binding(".", "frame-step-counter", function()
    mp.commandv("script-message", "pause-indicator-ignore")
    mp.command("no-osd frame-step")
    show_frame_pos()
end, {repeatable = true})

mp.add_key_binding(",", "frame-back-counter", function()
    mp.commandv("script-message", "pause-indicator-ignore")
    mp.command("no-osd frame-back-step")
    show_frame_pos()
end, {repeatable = true})
