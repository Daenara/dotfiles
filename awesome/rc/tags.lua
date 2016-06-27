-- Tags

local keydoc = loadrc("keydoc", "vbe/keydoc")
local layouts = config.layouts

config.tags = {
    names  = { "1⇋ Main", "2⇋ Terminal", "3⇋ Internet", "4⇋ ", "5⇋ ", "6⇋ Medien" ,"7⇋ ", "8⇋ Photos", "9⇋ Skype" },
    layout = { layouts[1], layouts[2], layouts[8], layouts[3], layouts[8], layouts[8], layouts[1], layouts[1], layouts[1] }
    }

    for s = 1, screen.count() do
        -- Each screen has its own tag table.
        config.tags[s] = awful.tag(config.tags.names, s, config.tags.layout)
    end
