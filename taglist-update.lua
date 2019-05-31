function taglist_update(w, buttons, label, data, objects, args)
    -- update the widgets, creating them if needed
    w:reset()
    for i, o in ipairs(objects) do
        local cache = data[o]

        if not cache then
            cache = (args and args.widget_template) and
                custom_template(args) or default_template()

            cache.primary:buttons(common.create_buttons(buttons, o))

            if cache.create_callback then
                cache.create_callback(cache.primary, o, i, objects)
            end

            if args and args.create_callback then
                args.create_callback(cache.primary, o, i, objects)
            end

            data[o] = cache
        elseif cache.update_callback then
            cache.update_callback(cache.primary, o, i, objects)
        end

        local text, bg, bg_image, icon, item_args = label(o, cache.tb)
        item_args = item_args or {}

        -- The text might be invalid, so use pcall.
        if cache.tbm and (text == nil or text == "") then
            cache.tbm:set_margins(0)
        elseif cache.tb then
            if not cache.tb:set_markup_silently(text) then
                cache.tb:set_markup("<i>&lt;Invalid text&gt;</i>")
            end
        end

        if cache.bgb then
            cache.bgb:set_bg(bg)

            --TODO v5 remove this if, it existed only for a removed and
            -- undocumented API
            if type(bg_image) ~= "function" then
                cache.bgb:set_bgimage(bg_image)
            else
                gdebug.deprecate("If you read this, you used an undocumented API"..
                    " which has been replaced by the new awful.widget.common "..
                    "templating system, please migrate now. This feature is "..
                    "already staged for removal", {
                    deprecated_in = 4
                })
            end

            cache.bgb.shape        = item_args.shape
            cache.bgb.border_width = item_args.shape_border_width
            cache.bgb.border_color = item_args.shape_border_color

        end

        if cache.ib and icon then
            cache.ib:set_image(icon)
        elseif cache.ibm then
            cache.ibm:set_margins(0)
        end

        if item_args.icon_size and cache.ib then
            cache.ib.forced_height = item_args.icon_size
            cache.ib.forced_width  = item_args.icon_size
        elseif cache.ib then
            cache.ib.forced_height = nil
            cache.ib.forced_width  = nil
        end

        w:add(cache.primary)
   end
end