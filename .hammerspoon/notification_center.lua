-- keyboard control for the macos notification center.
-- reveal notification center, navigate notifications, and clear them without
-- the mouse. macos exposes no keyboard nav for notifications, so this drives
-- the accessibility tree directly.
--
-- usage (from init.lua):
--   local nc = require("notification_center")
--   nc.setup({
--     toggle = "ctrl+shift+n",     -- global chord that reveals NC + grabs keys
--     keys = {                     -- single-key actions while NC is open
--       next     = "j",
--       prev     = "k",
--       clear    = { "x", "d" },   -- a value may be one chord or a list
--       clearAll = "shift+c",
--       open     = "return",
--       close    = { "escape", "q" },
--     },
--   })
--
-- every binding is a chord string like "cmd+shift+k"; the last token is the
-- key, the rest are modifiers. keys you omit fall back to the defaults above.

local M = {}

-- ---------------------------------------------------------------------------
-- accessibility plumbing
-- ---------------------------------------------------------------------------

-- toggle notification center by pressing the menu bar clock. the clock lives
-- in the Control Center process on recent macos; its item is the menu bar
-- extra whose AXDescription is "Clock".
local function pressClock()
    local cc = hs.application.get("com.apple.controlcenter")
    if not cc then return false end
    local bar = hs.axuielement.applicationElement(cc):attributeValue("AXExtrasMenuBar")
    if not bar then return false end
    for _, item in ipairs(bar:attributeValue("AXChildren") or {}) do
        if item:attributeValue("AXDescription") == "Clock" then
            item:performAction("AXPress")
            return true
        end
    end
    return false
end

-- the notification center window element, or nil when it's closed
local function ncWindow()
    local nc = hs.application.get("com.apple.notificationcenterui")
    if not nc then return nil end
    return (hs.axuielement.applicationElement(nc):attributeValue("AXWindows") or {})[1]
end

-- the container group that holds the notification stack. found by the
-- "Notification Center" heading it contains; its AXGroup children are the
-- individual notifications. widgets (calendar/weather/clock) live in a
-- separate group and are deliberately skipped.
local function container()
    local win = ncWindow()
    if not win then return nil end
    local found
    local function walk(el, depth)
        if depth > 9 or found then return end
        if el:attributeValue("AXRole") == "AXGroup" then
            for _, c in ipairs(el:attributeValue("AXChildren") or {}) do
                if c:attributeValue("AXRole") == "AXHeading"
                    and c:attributeValue("AXDescription") == "Notification Center" then
                    found = el
                    return
                end
            end
        end
        for _, c in ipairs(el:attributeValue("AXChildren") or {}) do walk(c, depth + 1) end
    end
    walk(win, 0)
    return found
end

-- list notification group elements, top to bottom
local function notifications()
    local c = container()
    if not c then return {} end
    local notes = {}
    for _, child in ipairs(c:attributeValue("AXChildren") or {}) do
        if child:attributeValue("AXRole") == "AXGroup" then notes[#notes + 1] = child end
    end
    return notes
end

-- find a descendant button by its accessibility description
local function findButton(el, wanted, depth)
    depth = depth or 0
    if depth > 6 then return nil end
    if el:attributeValue("AXRole") == "AXButton" then
        local d = el:attributeValue("AXDescription")
        for _, w in ipairs(wanted) do if d == w then return el end end
    end
    for _, child in ipairs(el:attributeValue("AXChildren") or {}) do
        local hit = findButton(child, wanted, depth + 1)
        if hit then return hit end
    end
    return nil
end

-- ---------------------------------------------------------------------------
-- navigation state + actions
-- ---------------------------------------------------------------------------

local notes = {}
local sel = 1
local watchdog = nil
local mode = hs.hotkey.modal.new()

-- move the mouse over the selected notification. hovering is what highlights
-- it and reveals its clear/reply buttons in the tree.
local function hover()
    local n = notes[sel]
    if not n then return end
    local f = n:attributeValue("AXFrame")
    if f then hs.mouse.setAbsolutePosition({ x = f.x + f.w / 2, y = f.y + f.h / 2 }) end
end

local function refresh()
    notes = notifications()
    if sel > #notes then sel = #notes end
    if sel < 1 then sel = 1 end
end

local function exit()
    if watchdog then watchdog:stop(); watchdog = nil end
    mode:exit()
    if ncWindow() then pressClock() end
end
M.exit = exit

local function open()
    if not ncWindow() then pressClock() end
    -- give the window a beat to appear before grabbing the keyboard
    hs.timer.doAfter(0.35, function() mode:enter() end)
end
M.open = open

-- toggle: if we're already driving NC, close it; otherwise open + take over
function M.toggle()
    if watchdog then exit() else open() end
end

local function moveNext()
    if sel < #notes then sel = sel + 1 end
    hover()
end

local function movePrev()
    if sel > 1 then sel = sel - 1 end
    hover()
end

-- clear the selected notification: hover to reveal its button, then press it.
-- the button only exists in the tree once hovered, so this is staged on timers.
local function clearSelected()
    local n = notes[sel]
    if not n then return end
    hover()
    hs.timer.doAfter(0.15, function()
        local btn = findButton(n, { "Clear All", "Clear", "Close" })
        if btn then btn:performAction("AXPress") end
        hs.timer.doAfter(0.25, function()
            refresh()
            if #notes == 0 then exit() else hover() end
        end)
    end)
end

-- clear every notification via the container's top-level Clear All button
local function clearAll()
    local c = container()
    if c then
        for _, child in ipairs(c:attributeValue("AXChildren") or {}) do
            if child:attributeValue("AXRole") == "AXButton"
                and child:attributeValue("AXDescription") == "Clear All" then
                child:performAction("AXPress")
                break
            end
        end
    end
    hs.timer.doAfter(0.25, function()
        refresh()
        if #notes == 0 then exit() else hover() end
    end)
end

-- open / activate the selected notification, then close NC
local function openSelected()
    local n = notes[sel]
    if n then n:performAction("AXPress") end
    exit()
end

function mode:entered()
    refresh()
    if #notes == 0 then
        hs.alert.show("no notifications")
        exit()
        return
    end
    sel = 1
    hover()
    -- if the user dismisses NC some other way, stop eating keystrokes
    watchdog = hs.timer.doEvery(0.4, function()
        if not ncWindow() then exit() end
    end)
end

-- ---------------------------------------------------------------------------
-- setup
-- ---------------------------------------------------------------------------

local DEFAULT_KEYS = {
    next     = "j",
    prev     = "k",
    clear    = { "x", "d" },
    clearAll = "shift+c",
    open     = "return",
    close    = { "escape", "q" },
}

-- "cmd+shift+k" -> ({"cmd","shift"}, "k")
local function parseChord(chord)
    local mods, key = {}, nil
    for token in string.gmatch(chord, "[^+]+") do
        mods[#mods + 1] = token
        key = token
    end
    mods[#mods] = nil -- last token is the key, not a modifier
    return mods, key
end

-- a config value may be a single chord string or a list of them
local function asChords(value)
    if type(value) == "string" then return { value } end
    return value or {}
end

-- bind every chord for an action onto the modal
local function bindMode(value, fn)
    for _, chord in ipairs(asChords(value)) do
        local mods, key = parseChord(chord)
        mode:bind(mods, key, fn)
    end
end

function M.setup(config)
    config = config or {}
    local keys = setmetatable(config.keys or {}, { __index = DEFAULT_KEYS })

    bindMode(keys.next, moveNext)
    bindMode(keys.prev, movePrev)
    bindMode(keys.clear, clearSelected)
    bindMode(keys.clearAll, clearAll)
    bindMode(keys.open, openSelected)
    bindMode(keys.close, exit)

    if config.toggle then
        local mods, key = parseChord(config.toggle)
        hs.hotkey.bind(mods, key, M.toggle)
    else
        hs.alert.show("notification_center: no 'toggle' chord configured")
    end

    return M
end

return M
