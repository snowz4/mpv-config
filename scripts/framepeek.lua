-- framepeek.lua
-- Shows current frame / total frames on OSD when frame-stepping with , and .
-- Segurar a tecla avança/volta rápido usando seek por duração de frame.

local mp = require("mp")

local function show_frame_pos()
    local current = mp.get_property_number("estimated-frame-number", 0)
    local total = mp.get_property_number("estimated-frame-count", 0)
    mp.osd_message(string.format("%d / %d", current, total), 1)
end

local function get_frame_duration()
    local fps = mp.get_property_number("container-fps", 24)
    return 1.0 / fps
end

local function step_forward()
    mp.commandv("script-message", "pause-indicator-ignore")
    local d = get_frame_duration()
    mp.commandv("no-osd", "seek", tostring(d), "exact")
    show_frame_pos()
end

local function step_backward()
    mp.commandv("script-message", "pause-indicator-ignore")
    local d = get_frame_duration()
    mp.commandv("no-osd", "seek", tostring(-d), "exact")
    show_frame_pos()
end

mp.add_key_binding(".", "frame-step-counter", step_forward, {repeatable = true})
mp.add_key_binding(",", "frame-back-counter", step_backward, {repeatable = true})
