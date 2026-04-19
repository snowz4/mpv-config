-- frame_counter.lua
-- Shows current frame / total frames on OSD when frame-stepping with , and .

local mp = require("mp")

local function show_frame_pos()
    local current = mp.get_property_number("estimated-frame-number", 0)
    local total = mp.get_property_number("estimated-frame-count", 0)
    mp.osd_message(string.format("%d / %d", current, total), 2)
end

mp.add_key_binding(",", "frame-back-counter", function()
    mp.command("frame-back-step")
    mp.add_timeout(0.05, show_frame_pos)
end)

mp.add_key_binding(".", "frame-step-counter", function()
    mp.command("frame-step")
    mp.add_timeout(0.05, show_frame_pos)
end)
