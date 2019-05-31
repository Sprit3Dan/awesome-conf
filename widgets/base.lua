local widget = {
    widget    = wibox.container.rotate,
    direction = 'west',
    wibox.widget {
        {
            max_value     = 1,
            value         = 0.6,
            widget        = wibox.widget.progressbar,
        },
        forced_height = 100,
        forced_width  = 20,
        direction     = 'east',
        layout        = wibox.container.rotate,
    },
},




return setmetatable(vcontrol, {
    __call = vcontrol.new,
})
  