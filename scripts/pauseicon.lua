-- pause_indicator.lua
-- Shows a pause/play icon in the center of the screen

local mp = require("mp")
local assdraw = require("mp.assdraw")

local ov = mp.create_osd_overlay("ass-events")
local timer = nil
local DISPLAY_TIME = 0.8

local function draw_icon(paused)
    local icon = paused and "❚❚" or "▶"

    ov.res_x = 1920
    ov.res_y = 1080
    ov.data = string.format("{\\an5\\pos(960,540)\\fs80\\bord3\\3c&H000000&\\1c&HFFFFFF&\\alpha&H30&}%s", icon)
    ov:update()
end

local function hide_icon()
    ov:remove()
end

local ignore_until = 0

-- framepeek and other scripts can signal to skip the indicator
mp.register_script_message("pause-indicator-ignore", function()
    ignore_until = mp.get_time() + 0.2
end)

local initialized = false

local function on_pause_change(name, paused)
    if not initialized then
        initialized = true
        return
    end

    if mp.get_time() < ignore_until then
        return
    end

    if timer then
        timer:kill()
        timer = nil
    end

    draw_icon(paused)

    timer = mp.add_timeout(DISPLAY_TIME, hide_icon)
end

mp.observe_property("pause", "bool", on_pause_change)
