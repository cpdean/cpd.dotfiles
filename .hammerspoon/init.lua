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
    local frame = screen:frame()
    current:setFrame({
        x=frame.x,
        y=frame.y,
        w=screen:currentMode().w,
        h=screen:currentMode().h
    })
end)

local half_height = function(rect)
    return {
        x=rect.x,
        y=rect.y,
        h=rect.h / 2,
        w=rect.w
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

----------------
-- this is a tricky one.  takes in some numbers and figures out the rectangle
-- you want
-- section_width_to_fill lets you make something take up 2/3ds instead of 1/3rd
----------------
local get_section = function(screen_rect, screenFrame, count, num_section, section_width_to_fill)
    print(num_section)
    return {
        x=screenFrame.x + (screen_rect.w / count) * num_section,
        y=screenFrame.y + 0,
        h=(screen_rect.h),
        w=(screen_rect.w / count) * section_width_to_fill
    }
end

local is_left_of = function(a, b)
    -- if point a is left of point b
    -- need to round up
    return math.ceil(a.x) < math.ceil(b.x)
end

local is_near = function(a, b)
    -- see if the euclidean distance is small or not
    -- get difference of all the vector components
    local x = a.x - b.x
    local y = a.y - b.y
    -- square them
    local x_s = x * x
    local y_s = y * y
    -- add them up
    local total = x_s + y_s
    -- square root
    local dist = math.sqrt(total)
    return dist < 5
end


local get_frames_thirds = function(screen_rect, screenFrame, window, section_count, dir)
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
            return get_section(screen_rect, screenFrame, section_count, 0, 1)
        elseif is_left_of(center, screen_center) then
            print('going to left')
            local left_section = get_section(screen_rect, screenFrame, section_count, 0, 1)
            if is_near(center, center_of(left_section)) then
                print('ALREADY HERE so setting it to take up double-width')
                return get_section(screen_rect, screenFrame, section_count, 0, 2)
            end
            return get_section(screen_rect, screenFrame, section_count, 0, 1)
        else
            print('going to mid')
            return get_section(screen_rect, screenFrame, section_count, 1, 1)
        end
    else
        print('right')
        if is_near(center, screen_center) then
            print('going to right')
            return get_section(screen_rect, screenFrame, section_count, 2, 1)
        elseif is_left_of(center, screen_center) then
            print('going to mid')
            return get_section(screen_rect, screenFrame, section_count, 1, 1)
        else
            print('going to right')
            local right_section = get_section(screen_rect, section_count, 2, 1)
            if is_near(center, center_of(right_section)) then
                print('ALREADY HERE so setting it to take up double-width')
                return get_section(screen_rect, screenFrame, section_count, 1, 2)
            end
            return get_section(screen_rect, screenFrame, section_count, 2, 1)
        end
    end
end

local get_frames_halves = function(screen_rect, screenFrame, window, section_count, dir)
    if dir == W_LEFT then
        return get_section(screen_rect, screenFrame, section_count, 0, 1)
    else
        return get_section(screen_rect, screenFrame, section_count, 1, 1)
    end
end


local get_next_frame = function(screen_rect, screenFrame, window, section_count, dir)
    -- 0, 30
    -- (0, 10), (10, 20), (20, 30)
    -- 5, 15, 25
    -- find the section center in the direction relative
    -- to the current window
    -- pick it, set it
    if section_count == 3 then
        return get_frames_thirds(screen_rect, screenFrame, window, section_count, dir)
    else
        return get_frames_halves(screen_rect, screenFrame, window, section_count, dir)
    end
end

local establish_window_placer = function(number_of_sections)

    hs.hotkey.bind(usual, "H", function()
        local current = hs.window.focusedWindow()
        local screenFrame = current:screen():frame()
        local section_width = get_next_frame(current:screen():currentMode(), screenFrame, current, number_of_sections, W_LEFT)
        current:setFrame(section_width)
    end)

    hs.hotkey.bind(usual, "L", function()
        local current = hs.window.focusedWindow()
        local screenFrame = current:screen():frame()
        local section_width = get_next_frame(current:screen():currentMode(), screenFrame, current, number_of_sections, W_RIGHT)
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

-- move windows between monitors

hs.hotkey.bind(intense, "H", function()
    local current = hs.window.focusedWindow()
    current:moveOneScreenWest()
end)

hs.hotkey.bind(intense, "L", function()
    local current = hs.window.focusedWindow()
    current:moveOneScreenEast()
end)

hs.hotkey.bind(usual, "J", function()
    -- make current window half-height, floating it down at first,
    -- or up if it's already in the bottom half

    -- get the current app to move around
    local current_app = hs.window.focusedWindow()

    -- get the true bounding rectangle of the viewport that this application
    -- rests on
    -- 'screen' corresponds to the physical dimensions of a monitor's viewport
    local screen = current_app:screen()
    -- 'frame' corresponds to the location of the monitor viewport
    -- in the context of a multi-monitor layout, so it is needed for the x,y of
    -- the rect.
    -- this prevents us from trying to resize an app and having it move to a
    -- different monitor.
    local frame = screen:frame()

    local viewport_rect = {
        x=frame.x,
        y=frame.y,
        h=screen:currentMode().h,
        w=screen:currentMode().w
    }
    local top_half_viewport_rect = half_height(viewport_rect)
    local bottom_half_viewport_rect = {
        x=top_half_viewport_rect.x,
        y=top_half_viewport_rect.h,  -- make the y pos be the height so it starts halfway down
        h=top_half_viewport_rect.h,
        w=top_half_viewport_rect.w
    }

    -- by default we will use the bottom half, to line up with our mnemonic from
    -- vim, "j" means down
    -- however, if the window is already in the bottom-half, bounce it up
    local app_rect = {
        x=current_app:frame().x,
        y=current_app:frame().y,
        w=current_app:frame().w,
        h=current_app:frame().h,
    }
    print("about to decide top or bottom")
    if is_near(center_of(app_rect), center_of(bottom_half_viewport_rect)) then
        print("going to top")
        current_app:setFrame({
            x=top_half_viewport_rect.x,
            y=top_half_viewport_rect.y,
            w=top_half_viewport_rect.w,
            h=top_half_viewport_rect.h
        })
    else
        print("going to bottom")
        current_app:setFrame({
            x=bottom_half_viewport_rect.x,
            y=bottom_half_viewport_rect.y,
            w=bottom_half_viewport_rect.w,
            h=bottom_half_viewport_rect.h
        })
    end
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
