-- standard awesome libraries
gears           = require("gears")
awful           = require("awful")
awful.rules     = require("awful.rules")
awful.autofocus = require("awful.autofocus")
wibox           = require("wibox")
beautiful       = require("beautiful")
naughty         = require("naughty")
menubar         = require("menubar")

-- function to load additional LUA files from rc/ or lib/
function loadrc(name, mod)
    local success
    local result

    -- Which file? Type: rc or lib
    local path = awful.util.getdir("config") .. "/" ..
        (mod and "lib" or "rc") ..
        "/" .. name .. ".lua"

    -- don't load any module twice
    if mod and package.loaded[mod] then
        return package.loaded[mod]
    end

    -- execute the rc/lib file
    success, result = pcall(function() return dofile(path) end)
    if not success then
        naughty.notify({ title = "Error while loading an RC file",
                         text = "When loading `" .. name ..
                         "`, got the following error:\n" .. result,
                         preset = naughty.config.presets.critical
                      })
        return print("E: error loading RC file '" .. name .. "': " .. result)
    end

    -- is it a module?
    if mod then
        return package.loaded[mod]
    end
    return result
end -- function loadrc

--
-- Configurations
--

loadrc("errors") -- errors and debug stuff

-- Global configuration

modkey = "Mod4"
config = {}
config.terminal = "xfce4-terminal"
config.layouts = {
    awful.layout.suit.floating,        --  1
    awful.layout.suit.tile,            --  2
    awful.layout.suit.tile.left,       --  3
    awful.layout.suit.tile.bottom,     --  4
    awful.layout.suit.tile.top,        --  5
    awful.layout.suit.fair,            --  6
    awful.layout.suit.fair.horizontal, --  7
 -- awful.layout.suit.spiral,          -- --
 -- awful.layout.suit.spiral.dwindle.  -- --
    awful.layout.suit.max,             --  8
    awful.layout.suit.max.fullscreen,  --  9
    awful.layout.suit.magnifier        -- 10
}
config.hostname = awful.util.pread('uname -n'):gsub('\n', '')
config.browser = "google-chrome"

-- RCs
 -- loadrc("functions")
 -- loadrc("appearance")
 -- loadrc("start")
 -- loadrc("bindings")
 -- loadrc("wallpaper")
 -- loadrc("widgets")
loadrc("tags")
 -- loadrc("xlock")
 -- loadrc("signals")
 -- loadrc("rules")
 -- loadrc("xrandr")

root.keys(config.keys.global)
