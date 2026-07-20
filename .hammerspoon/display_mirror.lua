-- toggle display mirroring using coregraphics directly (hs.screen), with no
-- system settings window and no ui scripting.
--
-- usage (from init.lua):
--   require("display_mirror").setup({ mods = usual, key = "m" })
--
-- the sd script config/sd/bin/display/toggle-mirror calls M.toggle() over the
-- `hs` cli, so this module is the single source of truth for the behaviour.

local M = {}

local function builtinScreen(screens)
    for _, s in ipairs(screens) do
        if s:name():match("Built%-in") then return s end
    end
    return nil
end

-- toggle mirroring on the external display(s). when extended, mirror every
-- external onto the built-in; when already mirrored (or no external present),
-- stop mirroring. returns a short status string.
function M.toggle()
    local screens = hs.screen.allScreens()
    if #screens >= 2 then
        local builtin = builtinScreen(screens)
        if not builtin then return "no built-in display found" end
        for _, s in ipairs(screens) do
            if s:id() ~= builtin:id() then s:mirrorOf(builtin) end
        end
        return "mirroring on"
    else
        -- one logical screen: mirrored, or nothing external plugged in
        for _, s in ipairs(screens) do s:mirrorStop() end
        return "mirroring off"
    end
end

-- bind a hotkey to the toggle. `mods` is a modifier table (e.g. the `usual`
-- constant from init.lua) and `key` is the key name.
function M.setup(config)
    config = config or {}
    if config.mods and config.key then
        hs.hotkey.bind(config.mods, config.key, function()
            hs.alert.show(M.toggle())
        end)
    else
        hs.alert.show("display_mirror: no mods/key configured")
    end
    return M
end

return M
