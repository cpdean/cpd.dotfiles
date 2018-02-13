--hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
  --hs.alert.show("Hello World!")
--end)
--hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
  --hs.notify.new({title="Hammerspoon", informativeText="Hello World"}):send()
--end)


local intense = {"ctrl", "shift", "alt"}
local usual = {"ctrl", "shift"}

-- lock_screen
hs.hotkey.bind(usual, "\\", function()
    hs.caffeinate.startScreensaver()
end)

hs.hotkey.bind(usual, "K", function()
    local current = hs.window.focusedWindow()
    local screen = current:screen()
    current:setFrame({
        x=0,
        y=0,
        w=screen:currentMode().w,
        h=screen:currentMode().h
    })
end)

local half_width = function(screenMode, section_count)
    return {
        x=0,
        y=0,
        h=screenMode.h,
        w=screenMode.w / section_count
    }
end

hs.hotkey.bind(usual, "H", function()
    local current = hs.window.focusedWindow()
    local section_width = half_width(current:screen():currentMode(), 2)
    current:setFrame(section_width)
end)

hs.hotkey.bind(usual, "L", function()
    local current = hs.window.focusedWindow()
    local section_width = half_width(current:screen():currentMode(), 2)
    section_width = {
        x=section_width.x + section_width.w,
        y=section_width.y,
        w=section_width.w,
        h=section_width.h
    }
    current:setFrame(section_width)
end)

local center_cursor_on = function(win_obj)
    print("before centering cursor on this window::")
    print(win_obj)
    local f = win_obj:frame()
    print(f)
    local the_center =  { x=f.x + (f.w / 2), y=f.y + (f.h / 2) }
    print("got the center woo:::")
    print("x " .. the_center.x .. ", y " .. the_center.y)
    hs.mouse.setAbsolutePosition(the_center)
    print("just centered on the new thing")
end

local create_mjm_switcher = function(key_register)
    local this_id = 0 -- store window id
    local this_previous = 0  -- store window before switching focus

    -- create app binding at runtime
    hs.hotkey.bind(intense, key_register, function()
        this_id = hs.window.focusedWindow():id()
        print('binding new keybinding')
        hs.alert.show(
            "setting new '" .. key_register .. "' binding" .. "\n" ..
            hs.window.find(this_id):title() .. " ::: " ..
            hs.window.find(this_id):id()
        , 2)
    end)

    --
    hs.hotkey.bind(usual, key_register, function()
        local switcher = function()
            if this_id ~= 0 then
                local current = hs.window.focusedWindow()
                -- if theres a focused window, and it is the id
                if current ~= nil and current:id() == this_id then
                    print("have to switch to previous app: " .. this_previous)
                    hs.window.find(this_previous):focus()
                    print("going to center on previous app")
                    center_cursor_on(hs.window.find(this_previous))
                else
                    if current ~= nil then
                        print("switching to the saved app:"..current:id())
                        this_previous = current:id()
                    end
                    local w = hs.window.find(this_id)
                    print("window is::")
                    print(w)
                    print("yep")
                    w:focus()
                    center_cursor_on(w)
                end
            else
                hs.alert.show("'" .. key_register .. "' not yet bound")
            end
        end
        switcher()
    end)

end

--hs.osascript.applescript([[display dialog "Welcome to AppleScript."]])
--hs.osascript.applescript([[tell application "System Events" to get the {title, id} of every window of every process]])

--hs.osascript.applescript([[tell application "System Events" to get the {title, id} of every window of (every process whose visible is true)]])

create_mjm_switcher("y")
create_mjm_switcher("u")
create_mjm_switcher("i")
create_mjm_switcher("o")
create_mjm_switcher("p")
