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

-- WINDOW PLACER APP
--
local W_LEFT = -1
local W_RIGHT = 1

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

local zero_or = function(num)
    if num ~= nil then
        return num
    else
        return 0
    end
end

local center_of = function(rect)
    return {
        x=zero_or(rect.x) + rect.w / 2,
        y=zero_or(rect.y) + rect.h / 2
    }
end

local get_section = function(screen_rect, count, num_section)
    print(num_section)
    return {
        x=(screen_rect.w / count) * num_section,
        y=0,
        h=(screen_rect.h),
        w=(screen_rect.w / count)
    }
end

local is_left_of = function(a, b)
    -- if point a is left of point b
    -- need to round up
    return math.ceil(a.x) < math.ceil(b.x)
end

local is_near = function(a, b)
    local dist = math.abs(a.x - b.x)
    return dist < 5
end


local get_frames_thirds = function(screen_rect, window, section_count, dir)
    print('getting window center')
    local center = center_of(window:frame())
    print('getting screen center')
    local screen_center = center_of(screen_rect)
    print("center and screen " .. center.x .. " " .. screen_center.x)
    -- TODO: send to the second closest target. rounding to the nearest pixel
    -- breaks this, so instead send to the nearest reasonable target.  if you
    -- are already close to a target, user probably doesn't want to go there. if
    -- they do, they can always tap the key to recenter.
    if dir == W_LEFT then
        print('left')
        if is_near(center, screen_center) then
            print('going to left')
            return get_section(screen_rect, section_count, 0)
        elseif is_left_of(center, screen_center) then
            print('going to left')
            return get_section(screen_rect, section_count, 0)
        else
            print('going to mid')
            return get_section(screen_rect, section_count, 1)
        end
    else
        print('right')
        if is_near(center, screen_center) then
            print('going to right')
            return get_section(screen_rect, section_count, 2)
        elseif is_left_of(center, screen_center) then
            print('going to mid')
            return get_section(screen_rect, section_count, 1)
        else
            print('going to right')
            return get_section(screen_rect, section_count, 2)
        end
    end
end

local get_frames_halves = function(screen_rect, window, section_count, dir)
    if dir == W_LEFT then
        return get_section(screen_rect, section_count, 0)
    else
        return get_section(screen_rect, section_count, 1)
    end
end


local get_next_frame = function(screen_rect, window, section_count, dir)
    -- 0, 30
    -- (0, 10), (10, 20), (20, 30)
    -- 5, 15, 25
    -- find the section center in the direction relative
    -- to the current window
    -- pick it, set it
    if section_count == 3 then
        return get_frames_thirds(screen_rect, window, section_count, dir)
    else
        return get_frames_halves(screen_rect, window, section_count, dir)
    end
end

local establish_window_placer = function(number_of_sections)

    hs.hotkey.bind(usual, "H", function()
        local current = hs.window.focusedWindow()
        local section_width = get_next_frame(current:screen():currentMode(), current, number_of_sections, W_LEFT)
        current:setFrame(section_width)
    end)

    hs.hotkey.bind(usual, "L", function()
        local current = hs.window.focusedWindow()
        local section_width = get_next_frame(current:screen():currentMode(), current, number_of_sections, W_RIGHT)
        current:setFrame(section_width)
    end)

end

establish_window_placer(2)

hs.hotkey.bind(usual, "2", function()
    establish_window_placer(2)
    hs.alert.show("setting 2-tiler")
end)

hs.hotkey.bind(usual, "3", function()
    establish_window_placer(3)
    hs.alert.show("setting 3-tiler")
end)



-- / WINDOW PLACER APP

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
