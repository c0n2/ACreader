local Device = require("device")
local WidgetContainer = require("ui/widget/container/widgetcontainer")

local ACFullRefresh = WidgetContainer:extend{
    name = "acfullrefresh",
}

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

    -- Reuse KOReader's own menu table instead of duplicating any refresh logic.
    -- This keeps Never / Every page / Every 6 pages / Custom / chapter options
    -- exactly in sync with the built-in E-Ink settings menu.
    local item = dofile("frontend/ui/elements/refresh_menu_table.lua")

    -- Put it directly in the first level of the Settings (gear) tab.
    item.sorting_hint = "setting"
    menu_items.ac_full_refresh = item
end

return ACFullRefresh
