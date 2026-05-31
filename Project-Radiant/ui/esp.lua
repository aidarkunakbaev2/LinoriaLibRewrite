--[[
    ESP TAB | ESP CONFIGURATION
    Handles all ESP-related UI elements (boxes, text, health, tracers, fade)
]]

local Module = {}

function Module.Init(tab, esplib)
    local Library = getgenv().ProjectRadiant.Library
    
    -- ============================================================
    -- BOX SETTINGS GROUP
    -- ============================================================
    local BoxGroup = tab:AddLeftGroupbox("Box Settings")
    
    BoxGroup:AddToggle("BoxEnabled", { 
        Text = "Show Box", 
        Default = true, 
        Callback = function(v) esplib.box.enabled = v end 
    })
    BoxGroup:AddDropdown("BoxType", { 
        Text = "Style", 
        Values = {"normal","corner"}, 
        Default = 1, 
        Callback = function(v) esplib.box.type = v end 
    })
    BoxGroup:AddSlider("BoxPadding", { 
        Text = "Padding", 
        Default = 1.15, 
        Min = 0.5, Max = 2.0, Rounding = 2, Compact = true, 
        Callback = function(v) esplib.box.padding = v end 
    })
    BoxGroup:AddLabel("Box Fill Color"):AddColorPicker("BoxFillColor", { 
        Default = Color3.new(1,1,1), 
        Callback = function(v) esplib.box.fill = v end 
    })
    BoxGroup:AddLabel("Box Outline Color"):AddColorPicker("BoxOutlineColor", { 
        Default = Color3.new(0,0,0), 
        Callback = function(v) esplib.box.outline = v end 
    })
    
    -- ============================================================
    -- TEXT & INFO GROUP
    -- ============================================================
    local TextGroup = tab:AddLeftGroupbox("Text & Info")
    
    TextGroup:AddToggle("NameEnabled", { 
        Text = "Show Names", 
        Default = true, 
        Callback = function(v) esplib.name.enabled = v end 
    })
    TextGroup:AddToggle("ShowHealth", { 
        Text = "Include Health in Name", 
        Default = true, 
        Callback = function(v) esplib.name.show_health = v end 
    })
    TextGroup:AddSlider("NameSize", { 
        Text = "Name Size", 
        Default = 13, Min = 8, Max = 24, Rounding = 0, Compact = true, 
        Callback = function(v) esplib.name.size = v end 
    })
    TextGroup:AddLabel("Name Color"):AddColorPicker("NameColor", { 
        Default = Color3.new(1,1,1), 
        Callback = function(v) esplib.name.fill = v end 
    })
    
    TextGroup:AddDivider()
    
    TextGroup:AddToggle("DistanceEnabled", { 
        Text = "Show Distance", 
        Default = true, 
        Callback = function(v) esplib.distance.enabled = v end 
    })
    TextGroup:AddSlider("DistanceSize", { 
        Text = "Distance Size", 
        Default = 13, Min = 8, Max = 24, Rounding = 0, Compact = true, 
        Callback = function(v) esplib.distance.size = v end 
    })
    TextGroup:AddLabel("Distance Color"):AddColorPicker("DistanceColor", { 
        Default = Color3.new(1,1,1), 
        Callback = function(v) esplib.distance.fill = v end 
    })
    
    -- ============================================================
    -- HEALTH SETTINGS GROUP
    -- ============================================================
    local HealthGroup = tab:AddRightGroupbox("Health Settings")
    
    HealthGroup:AddToggle("HealthEnabled", { 
        Text = "Show Healthbar", 
        Default = true, 
        Callback = function(v) esplib.healthbar.enabled = v end 
    })
    HealthGroup:AddDropdown("HealthPosition", { 
        Text = "Bar Position", 
        Values = {"left","right","bottom"}, 
        Default = 1, 
        Callback = function(v) esplib.healthbar.position = v end 
    })
    HealthGroup:AddToggle("HealthGradient", { 
        Text = "Use Gradient", 
        Default = true, 
        Callback = function(v) esplib.healthbar.gradient = v end 
    })
    HealthGroup:AddLabel("Low HP Color"):AddColorPicker("HealthLowColor", { 
        Default = Color3.new(1,0,0), 
        Callback = function(v) esplib.healthbar.low_color = v end 
    })
    HealthGroup:AddLabel("High HP Color"):AddColorPicker("HealthHighColor", { 
        Default = Color3.new(0,1,0), 
        Callback = function(v) esplib.healthbar.high_color = v end 
    })
    
    -- ============================================================
    -- TRACERS GROUP
    -- ============================================================
    local TracerGroup = tab:AddRightGroupbox("Tracers")
    
    TracerGroup:AddToggle("TracerEnabled", { 
        Text = "Show Tracers", 
        Default = true, 
        Callback = function(v) esplib.tracer.enabled = v end 
    })
    TracerGroup:AddDropdown("TracerFrom", { 
        Text = "Tracer Origin", 
        Values = {"bottom","center","top","mouse","head"}, 
        Default = 1, 
        Callback = function(v) esplib.tracer.from = v end 
    })
    TracerGroup:AddLabel("Tracer Color"):AddColorPicker("TracerColor", { 
        Default = Color3.new(1,1,1), 
        Callback = function(v) esplib.tracer.fill = v end 
    })
    TracerGroup:AddLabel("Outline Color"):AddColorPicker("TracerOutlineColor", { 
        Default = Color3.new(0,0,0), 
        Callback = function(v) esplib.tracer.outline = v end 
    })
    
    -- ============================================================
    -- DISTANCE FADE GROUP
    -- ============================================================
    local FadeGroup = tab:AddRightGroupbox("Distance Fade")
    
    FadeGroup:AddToggle("FadeEnabled", { 
        Text = "Enable Fade", 
        Default = true, 
        Callback = function(v) esplib.fade.enabled = v end 
    })
    FadeGroup:AddSlider("FadeDistance", { 
        Text = "Max Detail Distance", 
        Default = 400, Min = 100, Max = 1000, Rounding = 0, Suffix = "m", Compact = true, 
        Callback = function(v) esplib.fade.max_distance = v end 
    })
    FadeGroup:AddSlider("MinTransparency", { 
        Text = "Minimum Alpha", 
        Default = 0.3, Min = 0.0, Max = 1.0, Rounding = 2, Compact = true, 
        Callback = function(v) esplib.fade.min_transparency = v end 
    })
    
    FadeGroup:AddDivider()
    
    FadeGroup:AddToggle("HoverEnabled", { 
        Text = "Mouse Highlight", 
        Default = true, 
        Callback = function(v) esplib.fade.hover_enabled = v end 
    })
    FadeGroup:AddSlider("HoverRadius", { 
        Text = "Highlight Radius", 
        Default = 200, Min = 50, Max = 500, Rounding = 0, Suffix = "px", Compact = true, 
        Callback = function(v) esplib.fade.hover_radius = v end 
    })
    FadeGroup:AddSlider("FadeAnimSpeed", { 
        Text = "Animation Speed", 
        Default = 0.25, Min = 0.05, Max = 1.0, Rounding = 2, Compact = true, 
        Callback = function(v) esplib.fade.animation_speed = v end 
    })
end

return Module
