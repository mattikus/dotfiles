-- My awesome 3 configuration file

-- internal
require("awful")
require("beautiful")

-- external
require("wicked")


-- {{{ Initialization
-- Initialize theme (colors).

theme_path = ".config/awesome/themes/default"
beautiful.init(theme_path)
awful.beautiful.register(beautiful)

-- {{{ Markup helper functions
-- Inline markup is a tad ugly, so use these functions
-- to dynamically create markup, we hook them into
-- the beautiful namespace for clarity.
beautiful.markup = {}

function beautiful.markup.bg(color, text)
    return '<bg color="'..color..'" />'..text
end

function beautiful.markup.fg(color, text)
    return '<span color="'..color..'">'..text..'</span>'
end

function beautiful.markup.font(font, text)
    return '<span font_desc="'..font..'">'..text..'</span>'
end

function beautiful.markup.title(t)
    return t
end

function beautiful.markup.title_normal(t)
    return beautiful.title(t)
end

function beautiful.markup.title_focus(t)
    return beautiful.markup.bg(beautiful.bg_focus, beautiful.markup.fg(beautiful.fg_focus, beautiful.markup.title(t)))
end

function beautiful.markup.title_urgent(t)
    return beautiful.markup.bg(beautiful.bg_urgent, beautiful.markup.fg(beautiful.fg_urgent, beautiful.markup.title(t)))
end

function beautiful.markup.bold(text)
    return '<b>'..text..'</b>'
end

function beautiful.markup.heading(text)
    return beautiful.markup.fg(beautiful.fg_focus, text)
end

-- }}}

-- {{{
-- Settings
settings = {}
settings.apps = {}
settings.apps.terminal = "urxvtc"
settings.apps.locker = "gnome-screensaver-command -l"
settings.apps.browser = "firefox"
settings.apps.irc = "~/bin/irc"
settings.apps.im = "~/bin/im"
settings.widget_spacer = "\ "
settings.widget_separator = beautiful.markup.heading(" | ")
--
-- Check what widget mode to use
if io.open(os.getenv("HOME").."/.laptop_mode") then
    -- Special file exists, display widgets I want
    -- on my laptop
    settings.mode = 'laptop'
else 
    settings.mode = 'desktop'
end

settings.email = {}
if settings.mode == 'laptop' then
    settings.email.screen = 1
    settings.email.tag = 4
else
    settings.email.screen = 2
    settings.email.tag = 1
end


-- Default modkey.
modkey = "Mod1" -- Left Alt

layouts =
{
    "tile",
    "tilebottom",
    "fairh",
    "max",
    "floating"
}

floatapps =
{
    -- by class
    ["MPlayer"] = true,
    ["gimp"] = true,
    -- by instance
    ["Downloads"] = true,
    ["Extension"] = true,
    -- by icon_name
    ["Add URL(s)"] = true,
    ["glxgears"] = true,
}

apptags =
{
    -- by class
    ["claws-mail"] = { screen = settings.email.screen, tag = settings.email.tag },
    ["pidgin"] = { screen = 1, tag = 3 },
    ["irc"] = { screen = 1, tag = 3 },
    ["im"] = { screen = 1, tag = 3 },
    -- by instance
}

use_titlebar = true

-- {{{ Tags
tags = {}
tags[1] = {}
tags[1][1] = tag({ name = "web", layout = layouts[1], mwfact = 0.70 })
tags[1][2] = tag({ name = "term", layout = layouts[3] })
tags[1][3] = tag({ name = "comms", layout = layouts[1] })
if screen.count() > 1 then
    tags[1][4] = tag({ name = "misc", layout = layouts[1] })
    tags[2] = {}
    tags[2][1] = tag({ name = "email", layout = layouts[4] })
    tags[2][2] = tag({ name = "misc", layout = layouts[1] })
    tags[2][1].screen = 2
    tags[2][2].screen = 2
    tags[2][1].selected = true
else
    tags[1][4] = tag({ name = "email", layout = layouts[4] })
end

for tagnumber = 1, 4 do
    -- Add tags to screen one by one
    tags[1][tagnumber].screen = 1
end


-- I'm sure you want to see at least one tag.
tags[1][1].selected = true
-- }}}

-- {{{ Wibox
-- Create a taglist widget
mytaglist = widget({ type = "taglist", name = "mytaglist" })
mytaglist:buttons({
    button({ }, 1, function (object, tag) awful.tag.viewonly(tag) end),
    button({ modkey }, 1, function (object, tag) awful.client.movetotag(tag) end),
    button({ }, 3, function (object, tag) tag.selected = not tag.selected end),
    button({ modkey }, 3, function (object, tag) awful.client.toggletag(tag) end),
    button({ }, 4, awful.tag.viewnext),
    button({ }, 5, awful.tag.viewprev)
})
mytaglist.label = awful.widget.taglist.label.all

-- Create a tasklist widget
mytasklist = widget({ type = "tasklist", name = "mytasklist" })
mytasklist:buttons({
    button({ }, 1, function (object, c) client.focus = c; c:raise() end),
    button({ }, 4, function () awful.client.focusbyidx(1) end),
    button({ }, 5, function () awful.client.focusbyidx(-1) end)
})
mytasklist.label = awful.widget.tasklist.label.currenttags

-- Create a textbox widget
mytextbox = widget({ type = "textbox", name = "mytextbox", align = "right" })
-- Set the default text in textbox
mytextbox.text = "<b><small> " .. AWESOME_RELEASE .. " </small></b>"
mypromptbox = widget({ type = "textbox", name = "mypromptbox", align = "left" })

-- Create a laucher widget
mylauncher = awful.widget.launcher({ name = "mylauncher",
                                     image = "/usr/share/awesome/icons/awesome16.png",
                                     command = settings.apps.terminal .. " -e man awesome",
                                     align = "left", })

-- Create a systray
mysystray = widget({ type = "systray", name = "mysystray", align = "right" })

-- Create an iconbox widget which will contains an icon indicating which layout we're using.
-- We need one layoutbox per screen.
mylayoutbox = {}
for s = 1, screen.count() do
    mylayoutbox[s] = widget({ type = "imagebox", name = "mylayoutbox", align = "left" })
    mylayoutbox[s]:buttons({
        button({ }, 1, function () awful.layout.inc(layouts, 1) end),
        button({ }, 3, function () awful.layout.inc(layouts, -1) end),
        button({ }, 4, function () awful.layout.inc(layouts, 1) end),
        button({ }, 5, function () awful.layout.inc(layouts, -1) end)
    })
    mylayoutbox[s].image = image("/usr/share/awesome/icons/layouts/tilew.png")
end

separator = widget({
    type = 'textbox',
    name = 'separator'
})
separator.text = settings.widget_spacer..settings.widget_separator..settings.widget_spacer

if settings.mode == 'laptop' then
-- {{{ Battery Widget
batterywidget = widget({
    type = 'textbox',
    name = 'batterywidget',
    align = 'right'
})

function read_battery_temp(format)
    local f = io.open('/tmp/battery-temp')

    if f == nil then 
        return {'n/a'}
    end

    local n = f:read()

    if n == nil then
        f:close()
        return {'n/a'}
    end

    return {awful.escape(n)}
end

wicked.register(batterywidget, read_battery_temp,
        settings.widget_spacer..beautiful.markup.heading('bat')..': $1'..settings.widget_spacer..settings.widget_separator,
30)

-- Start timer to read the temp file
awful.hooks.timer.register(60, function ()
    -- Call battery script to get batt%
    command = "battery"
    os.execute(command..' > /tmp/battery-temp &')
end, true)

-- }}}
end

datewidget = widget({
    type = 'textbox',
    name = 'datewidget',
    align = 'right'
})

wicked.register(datewidget, 'date',
    settings.widget_separator..'%D\ %H:%M')

cpuwidget = widget({
    type = 'textbox',
    name = 'cpuwidget',
    align = 'right'
})

wicked.register(cpuwidget, wicked.widgets.cpu,
    settings.widget_separator..beautiful.markup.heading('cpu: ')..'$1%\ ')

cpugraphwidget1 = widget({
    type = 'graph',
    name = 'cpugraphwidget1',
    align = 'right'
})

cpugraphwidget1.height = 0.85
cpugraphwidget1.width = 40
cpugraphwidget1.bg = '#333333'
cpugraphwidget1.border_color = '#000000'
-- cpugraphwidget1.border_color = '#0a0a0a'
cpugraphwidget1.grow = 'left'

cpugraphwidget1:plot_properties_set('cpu', {
    fg = '#AEC6D8',
    fg_center = '#285577',
    fg_end = '#285577',
    vertical_gradient = false
})

wicked.register(cpugraphwidget1, wicked.widgets.cpu, '$2', 1, 'cpu')

cpugraphwidget2 = widget({
    type = 'graph',
    name = 'cpugraphwidget2',
    align = 'right'
})

cpugraphwidget2.height = 0.85
cpugraphwidget2.width = 40
cpugraphwidget2.bg = '#333333'
cpugraphwidget2.border_color = '#000000'
cpugraphwidget2.grow = 'left'

cpugraphwidget2:plot_properties_set('cpu', {
    fg = '#AEC6D8',
    fg_center = '#285577',
    fg_end = '#285577',
    vertical_gradient = false
})

wicked.register(cpugraphwidget2, wicked.widgets.cpu, '$3', 1, 'cpu')

memwidget = widget({
    type = 'textbox',
    name = 'memwidget',
    align = 'right'
})

wicked.register(memwidget, wicked.widgets.mem,
    settings.widget_separator..beautiful.markup.heading('mem: ')..'$1%\ '..settings.widget_spacer)


membarwidget = widget({
    type = 'graph',
    name = 'membarwidget',
    align = 'right'
})


membarwidget.height = 0.85
membarwidget.width = 40
membarwidget.bg = '#333333'
membarwidget.border_color = '#0a0a0a'
membarwidget.grow = 'left'

membarwidget:plot_properties_set('mem', {
    fg = '#AEC6D8',
    fg_center = '#285577',
    fg_end = '#285577',
    vertical_gradient = false
})

wicked.register(membarwidget, wicked.widgets.mem, '$1', 1, 'mem')

netwidget = widget({
    type = 'textbox',
    name = 'netwidget',
    align = 'right',
})

wicked.register(netwidget, wicked.widgets.net, 
    beautiful.markup.heading('net: ')..'${eth0 down}'..beautiful.markup.heading(' / ')..'${eth0 up}',
nil, nil, 3)

mpdwidget = widget({
    type = 'textbox',
    name = 'mpdwidget',
    align = 'left'
})

wicked.register(mpdwidget, wicked.widgets.mpd, 
    function (widget, args)
       if args[1]:find("volume:") == nil then
          return settings.widget_spacer..beautiful.markup.heading('now playing: ')..args[1]
       else
          return ''
       end
    end
)


-- Create a statusbar for each screen and add it
mywibox = {}
for s = 1, screen.count() do
    mywibox[s] = wibox({ position = "top", name = "mywibox" .. s,
                             fg = beautiful.fg_normal, bg = beautiful.bg_normal })
    -- Add widgets to the wibox - order matters
    mywibox[s]:widgets({
        mytaglist,
        mylayoutbox[s],
        --mytasklist,
        mylauncher,
        mypromptbox,
        mpdwidget,
        settings.mode == 'laptop' and batterywidget or nil,
        netwidget,
        cpuwidget,
        cpugraphwidget1,
        cpugraphwidget2,
        memwidget,
        membarwidget,
        s == 1 and mysystray or nil,
        datewidget
    })
    mywibox[s].screen = s
end
-- }}}

-- {{{ Mouse bindings
awesome.buttons({
    button({ }, 3, function () awful.spawn(terminal) end),
    button({ }, 4, awful.tag.viewnext),
    button({ }, 5, awful.tag.viewprev)
})
-- }}}

-- {{{ Key bindings

-- Bind keyboard digits
-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

for i = 1, keynumber do
    keybinding({ modkey }, i,
                   function ()
                       local screen = mouse.screen
                       if tags[screen][i] then
                           awful.tag.viewonly(tags[screen][i])
                       end
                   end):add()
    keybinding({ modkey, "Control" }, i,
                   function ()
                       local screen = mouse.screen
                       if tags[screen][i] then
                           tags[screen][i].selected = not tags[screen][i].selected
                       end
                   end):add()
    keybinding({ modkey, "Shift" }, i,
                   function ()
                       if client.focus then
                           if tags[client.focus.screen][i] then
                               awful.client.movetotag(tags[client.focus.screen][i])
                           end
                       end
                   end):add()
    keybinding({ modkey, "Control", "Shift" }, i,
                   function ()
                       if client.focus then
                           if tags[client.focus.screen][i] then
                               awful.client.toggletag(tags[client.focus.screen][i])
                           end
                       end
                   end):add()
end

keybinding({ modkey }, "Left", awful.tag.viewprev):add()
keybinding({ modkey }, "Right", awful.tag.viewnext):add()
keybinding({ modkey }, "Escape", awful.tag.history.restore):add()

-- Standard program
keybinding({ modkey }, "Return", function () awful.spawn(settings.apps.terminal) end):add()
keybinding({ modkey }, "f", function () awful.spawn(settings.apps.browser) end):add()
keybinding({ modkey }, "i", function () awful.spawn(settings.apps.irc) end):add()
keybinding({ modkey }, "m", function () awful.spawn(settings.apps.im) end):add()
keybinding({ modkey, "Shift" }, "F12", function () awful.spawn(settings.apps.locker) end):add()
keybinding({ modkey, "Shift" }, "m", function () awful.tag.setmwfact(0.705) end):add()

keybinding({ modkey, "Control" }, "r", awesome.restart):add()
keybinding({ modkey, "Shift" }, "q", awesome.quit):add()

-- Client manipulation
--keybinding({ modkey }, "m", awful.client.maximize):add()
--keybinding({ modkey, "Shift" }, "m", awful.client_maximize_clean):add()
keybinding({ modkey, "Shift" }, "c", function () client.focus:kill() end):add()
keybinding({ modkey }, "j", function () awful.client.focusbyidx(1); client.focus:raise() end):add()
keybinding({ modkey }, "k", function () awful.client.focusbyidx(-1);  client.focus:raise() end):add()
keybinding({ modkey, "Shift" }, "j", function () awful.client.swap(1) end):add()
keybinding({ modkey, "Shift" }, "k", function () awful.client.swap(-1) end):add()
keybinding({ modkey, "Control" }, "j", function () awful.screen.focus(1) end):add()
keybinding({ modkey, "Control" }, "k", function () awful.screen.focus(-1) end):add()
keybinding({ modkey, "Control" }, "space", awful.client.togglefloating):add()
keybinding({ modkey, "Control" }, "Return", function () client.focus:swap(awful.client.master()) end):add()
keybinding({ modkey }, "o", awful.client.movetoscreen):add()
keybinding({ modkey }, "Tab", awful.client.focus.history.previous):add()
keybinding({ modkey }, "u", awful.client.urgent.jumpto):add()
keybinding({ modkey, "Shift" }, "r", function () client.focus:redraw() end):add()

-- Layout manipulation
keybinding({ modkey }, "l", function () awful.tag.incmwfact(0.05) end):add()
keybinding({ modkey }, "h", function () awful.tag.incmwfact(-0.05) end):add()
keybinding({ modkey, "Shift" }, "h", function () awful.tag.incnmaster(1) end):add()
keybinding({ modkey, "Shift" }, "l", function () awful.tag.incnmaster(-1) end):add()
keybinding({ modkey, "Control" }, "h", function () awful.tag.incncol(1) end):add()
keybinding({ modkey, "Control" }, "l", function () awful.tag.incncol(-1) end):add()
keybinding({ modkey }, "space", function () awful.layout.inc(layouts, 1) end):add()
keybinding({ modkey, "Shift" }, "space", function () awful.layout.inc(layouts, -1) end):add()

-- Prompt
keybinding({ modkey }, "F1", function ()
                                 awful.prompt.run({ prompt = "Run: " }, mypromptbox, awful.spawn, awful.completion.bash,
os.getenv("HOME") .. "/.cache/awesome/history") end):add()
keybinding({ modkey }, "F4", function ()
                                 awful.prompt.run({ prompt = "Run Lua code: " }, mypromptbox, awful.eval, awful.prompt.bash,
os.getenv("HOME") .. "/.cache/awesome/history_eval") end):add()
keybinding({ modkey, "Ctrl" }, "i", function ()
                                        if mypromptbox.text then
                                            mypromptbox.text = nil
                                        else
                                            mypromptbox.text = nil
                                            if client.focus.class then
                                                mypromptbox.text = "Class: " .. client.focus.class .. " "
                                            end
                                            if client.focus.instance then
                                                mypromptbox.text = mypromptbox.text .. "Instance: ".. client.focus.instance .. " "
                                            end
                                            if client.focus.role then
                                                mypromptbox.text = mypromptbox.text .. "Role: ".. client.focus.role
                                            end
                                        end
                                    end):add()

-- Client awful tagging: this is useful to tag some clients and then do stuff like move to tag on them
keybinding({ modkey }, "t", awful.client.togglemarked):add()

for i = 1, keynumber do
    keybinding({ modkey, "Shift" }, "F" .. i,
                   function ()
                       local screen = mouse.screen
                       if tags[screen][i] then
                           for k, c in pairs(awful.client.getmarked()) do
                               awful.client.movetotag(tags[screen][i], c)
                           end
                       end
                   end):add()
end
-- }}}

-- {{{ Hooks
-- Hook function to execute when focusing a client.
awful.hooks.focus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_focus
    end
end)

-- Hook function to execute when unfocusing a client.
awful.hooks.unfocus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_normal
    end
end)

-- Hook function to execute when marking a client
awful.hooks.marked.register(function (c)
    c.border_color = beautiful.border_marked
end)

-- Hook function to execute when unmarking a client
awful.hooks.unmarked.register(function (c)
    c.border_color = beautiful.border_focus
end)

-- Hook function to execute when the mouse is over a client.
awful.hooks.mouse_enter.register(function (c)
    -- Sloppy focus, but disabled for magnifier layout
    if awful.layout.get(c.screen) ~= "magnifier"
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

-- Hook function to execute when a new client appears.
awful.hooks.manage.register(function (c)
    if use_titlebar then
        -- Add a titlebar
        awful.titlebar.add(c, { modkey = modkey })
    end
    -- Add mouse bindings
    c:buttons({
        button({ }, 1, function (c) client.focus = c; c:raise() end),
        button({ modkey }, 1, function (c) c:mouse_move() end),
        button({ modkey }, 3, function (c) c:mouse_resize() end)
    })
    -- New client may not receive focus
    -- if they're not focusable, so set border anyway.
    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_normal
    client.focus = c

    -- Check if the application should be floating.
    local cls = c.class
    local inst = c.instance
    if floatapps[cls] then
        c.floating = floatapps[cls]
    elseif floatapps[inst] then
        c.floating = floatapps[inst]
    end

    -- Check application->screen/tag mappings.
    local target
    if apptags[cls] then
        target = apptags[cls]
    elseif apptags[inst] then
        target = apptags[inst]
    end
    if target then
        c.screen = target.screen
        awful.client.movetotag(tags[target.screen][target.tag], c)
    end

    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    awful.client.setslave(c)

    -- Honor size hints: if you want to drop the gaps between windows, set this to false.
    -- c.honorsizehints = false
end)

-- Hook function to execute when arranging the screen
-- (tag switch, new client, etc)
awful.hooks.arrange.register(function (screen)
    local layout = awful.layout.get(screen)
    if layout then
        mylayoutbox[screen].image = image("/usr/share/awesome/icons/layouts/" .. layout .. "w.png")
    else
        mylayoutbox[screen].image = nil
    end

    -- Give focus to the latest client in history if no window has focus
    -- or if the current window is a desktop or a dock one.
    if not client.focus then
        local c = awful.client.focus.history.get(screen, 0)
        if c then client.focus = c end
    end

    -- Uncomment if you want mouse warping
    --[[
    if client.focus then
        local c_c = client.focus:coords()
        local m_c = mouse.coords()

        if m_c.x < c_c.x or m_c.x >= c_c.x + c_c.width or
            m_c.y < c_c.y or m_c.y >= c_c.y + c_c.height then
            if table.maxn(m_c.buttons) == 0 then
                mouse.coords({ x = c_c.x + 5, y = c_c.y + 5})
            end
        end
    end
    ]]
end)

-- Hook called every second
awful.hooks.timer.register(1, function ()
    -- For unix time_t lovers
    -- mytextbox.text = " " .. os.time() .. " time_t "
    -- Otherwise use:
    -- mytextbox.text = " " .. os.date("%D\ %k:%m") .. " "
end)
-- }}}
