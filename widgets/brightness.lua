--[[

Brightness control
==================

based on `xbacklight`!

alternative ways to control brightness:
    sudo setpci -s 00:02.0 F4.B=80
    xgamma -gamma .75
    xrandr --output LVDS1 --brightness 0.9
    echo X > /sys/class/backlight/intel_backlight/brightness
    xbacklight

--]]

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local naughty = require("naughty")
local beautiful = require("beautiful")



------------------------------------------
-- Private utility functions
------------------------------------------

local function readcommand(command)
    local file = io.popen(command)
    local text = file:read('*all')
    file:close()
    return text
end

local function quote_arg(str)
    return "'" .. string.gsub(str, "'", "'\\''") .. "'"
end

local function quote_args(first, ...)
    if #{...} == 0 then
        return quote_arg(first)
    else
        return quote_arg(first), quote_args(...)
    end
end

local function make_argv(...)
    return table.concat({quote_args(...)}, " ")
end


------------------------------------------
-- Volume control interface
------------------------------------------

local bwidget = {}

function bwidget:new(args)
    return setmetatable({}, {__index = self}):init(args)
end

function bwidget:init(args)
    self.cmd = "xbacklight"

    self.iconfont = 'adobe-saucecodepro mono 20' or args.iconfont
    self.widget = wibox.widget {
        widget    = wibox.container.rotate,
        direction = 'west',
        {
            {
                {
                    id = 'pg',
                    max_value     = 100,
                    widget = wibox.widget.progressbar,
                    
                    shape            = gears.shape.rounded_rect,
                    bar_shape        = gears.shape.rounded_rect,
                    color            = beautiful.trd_basic_color,
                    background_color = beautiful.fth_basic_color,
                    margins = {
                        top = 3,
                        bottom = 3,
                        left = 5,
                        right = 5
                    },
                },
                forced_height = 80,
                direction     = 'east',
                layout        = wibox.container.rotate,
            },
            {
                markup = '<span foreground=\"black\"></span>',
                align  = 'center',
                widget = wibox.widget.textbox,
                font = self.iconfont
            },
            layout  = wibox.layout.stack,
        },
    }
    
    gears.timer {
        timeout = 0,
        callback = function()
            local brightness = 0
            if args.updateFn ~= nil then
                brightness = args.updateFn()
            else
                brightness = math.floor(0.5+tonumber(self:exec("-get")))
            end
            self:update(brightness)
        end,
        autostart = true,
        call_now = true,
    }

    return self
end

function bwidget:exec(...)
    return readcommand(make_argv(self.cmd, ...))
end

function bwidget:update(brightness)
    self.widget:get_children_by_id("pg")[1]:set_value(brightness)
end

return setmetatable(bwidget, {
  __call = bwidget.new,
})
