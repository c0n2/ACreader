local Device = require("device")
local WidgetContainer = require("ui/widget/container/widgetcontainer")

local ACFullRefresh = WidgetContainer:extend{
    name = "acfullrefresh",
}

local MENU_ID = "ac_full_refresh"

local function putFirstInSettings()
    -- ReaderMenu loads plugins before sorting the menu, so we can safely
    -- promote our shortcut to the very first item in the Settings (gear) tab.
    local order = require("ui/elements/reader_menu_order")
    if not order or not order.setting then
        return
    end

    -- Avoid duplicates when KOReader rebuilds the menu during the same session.
    for i = #order.setting, 1, -1 do
        if order.setting[i] == MENU_ID then
            table.remove(order.setting, i)
        end
    end
    table.insert(order.setting, 1, MENU_ID)
end

function ACFullRefresh:init()
    -- This shortcut is useful only on E-Ink readers, and only in Reader UI.
    if not Device:hasEinkScreen() or not self.ui or not self.ui.view or not self.ui.menu then
        return
    end
    self.ui.menu:registerToMainMenu(self)
end

function ACFullRefresh:addToMainMenu(menu_items)
    if not Device:hasEinkScreen() or not self.ui or not self.ui.view then
        return
    end

    -- Reuse KOReader's own refresh menu instead of duplicating any logic.
    -- Never / Every page / Every 6 pages / Custom / chapter options therefore
    -- stay exactly in sync with KOReader's built-in E-Ink settings.
    menu_items[MENU_ID] = dofile("frontend/ui/elements/refresh_menu_table.lua")

    -- Put "Full refresh rate" above "Frontlight" as the first Settings item.
    putFirstInSettings()
end

return ACFullRefresh
