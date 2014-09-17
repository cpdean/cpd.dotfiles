local application = require "mjolnir.application"
local hotkey = require "mjolnir.hotkey"
local window = require "mjolnir.window"
local fnutils = require "mjolnir.fnutils"
local alert = require "mjolnir.alert"

local intense = {"ctrl", "shift", "alt"}
local usual = {"ctrl", "shift"}

hotkey.bind(intense, "r", function() mjolnir.reload(); mjolnir.openconsole() end)

hotkey.bind(intense, "p", function()
    alert.show(important, 1)
end)

local create_mjm_switcher = function(key_register)
    local this_id = 0 -- store window id
    local this_previous = 0  -- store window before switching focus

    -- create app binding at runtime
    hotkey.bind(intense, key_register, function()
        this_id = window.focusedwindow():id()
        alert.show("setting new '" .. key_register .. "' binding", 2)
        alert.show(window.windowforid(this_id):id(), 2)
        alert.show(window.windowforid(this_id):title(), 2)
    end)

    hotkey.bind(usual, key_register, function()
        local current = window.focusedwindow():id()
        if current == this_id then
            window.windowforid(this_previous):focus()
        else
            this_previous = current
            window.windowforid(this_id):focus()
        end
    end)

end

create_mjm_switcher("i")
create_mjm_switcher("u")
create_mjm_switcher("o")
