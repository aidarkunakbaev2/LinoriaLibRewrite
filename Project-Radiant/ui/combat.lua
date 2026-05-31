--[[
    COMBAT TAB | AIMBOT CONFIGURATION
    Handles all combat-related UI elements
]]

local Module = {}

function Module.Init(tab, AimbotEnv)
    local AimSettings = AimbotEnv.Settings
    local AimFOV = AimbotEnv.FOVSettings
    local Library = getgenv().ProjectRadiant.Library
    
    -- ============================================================
    -- TARGET SELECTION GROUP
    -- ============================================================
    local AimTargetGroupBox = tab:AddLeftGroupbox("Target Selection")
    
    AimTargetGroupBox:AddToggle("AimEnabled", { 
        Text = "Enable System", 
        Default = AimSettings.Enabled, 
        Tooltip = "Tip: Main switch for the Aimbot.",
        Callback = function(v) AimSettings.Enabled = v end 
    }):AddKeyPicker("AimEnabledKey", { 
        Default = "None", 
        SyncToggleState = true, 
        Mode = "Toggle", 
        Text = "Aimbot Toggle" 
    })
    
    AimTargetGroupBox:AddDropdown("AimLockPart", { 
        Text = "Target Bone", 
        Values = {"Head", "HumanoidRootPart", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}, 
        Default = AimSettings.LockPart, 
        Tooltip = "Tip: The part of the character to track.",
        Callback = function(v) AimSettings.LockPart = v end 
    })
    
    AimTargetGroupBox:AddDropdown("AimLockMode", { 
        Text = "Lock Method", 
        Values = {"CFrame", "Mouse"}, 
        Default = AimSettings.LockMode == 1 and "CFrame" or "Mouse", 
        Callback = function(v) AimSettings.LockMode = (v == "CFrame" and 1 or 2) end 
    })
    
    AimTargetGroupBox:AddDivider()
    AimTargetGroupBox:AddToggle("AimTeamCheck", { 
        Text = "Team Check", 
        Default = AimSettings.TeamCheck, 
        Callback = function(v) AimSettings.TeamCheck = v end 
    })
    AimTargetGroupBox:AddToggle("AimWallCheck", { 
        Text = "Wall Check", 
        Default = AimSettings.WallCheck, 
        Callback = function(v) AimSettings.WallCheck = v end 
    })
    AimTargetGroupBox:AddToggle("AimAliveCheck", { 
        Text = "Alive Check", 
        Default = AimSettings.AliveCheck, 
        Callback = function(v) AimSettings.AliveCheck = v end 
    })
    
    -- ============================================================
    -- TRIGGER SETUP GROUP
    -- ============================================================
    local AimTriggerGroupBox = tab:AddLeftGroupbox("Trigger Setup")
    
    AimTriggerGroupBox:AddToggle("AimSilent", { 
        Text = "Universal Silent Aim", 
        Default = AimSettings.SilentAim,
        Tooltip = "Bends bullets to the target silently.",
        Callback = function(v) AimSettings.SilentAim = v end 
    }):AddKeyPicker("AimSilentKey", { 
        Default = "None", 
        SyncToggleState = true,
        Mode = "Toggle",
        Text = "Silent Aim Toggle" 
    })
    
    AimTriggerGroupBox:AddToggle("AimCamera", { 
        Text = "Camera Follow (Aimbot)", 
        Default = AimSettings.CameraAim,
        Tooltip = "Moves your camera or mouse to the target.",
        Callback = function(v) AimSettings.CameraAim = v end 
    }):AddKeyPicker("AimCameraKey", { 
        Default = "RightClick", 
        SyncToggleState = true,
        Mode = "Hold",
        Text = "Camera Follow Toggle" 
    })
    
    -- ============================================================
    -- PERFORMANCE GROUP
    -- ============================================================
    local AimRefineGroup = tab:AddRightGroupbox("Performance")
    
    AimRefineGroup:AddSlider("AimSmoothing", { 
        Text = "Smoothing", 
        Default = AimSettings.Sensitivity, 
        Min = 0, Max = 1, Rounding = 2, Compact = true, 
        Callback = function(v) AimSettings.Sensitivity = v end 
    })
    
    AimRefineGroup:AddSlider("AimMouseSens", { 
        Text = "Mouse Sens", 
        Default = AimSettings.Sensitivity2, 
        Min = 1, Max = 10, Rounding = 1, Compact = true, 
        Callback = function(v) AimSettings.Sensitivity2 = v end 
    })
    
    AimRefineGroup:AddDivider()
    AimRefineGroup:AddToggle("AimPrediction", { 
        Text = "Prediction", 
        Default = AimSettings.Prediction, 
        Callback = function(v) AimSettings.Prediction = v end 
    })
    AimRefineGroup:AddSlider("AimPredAmount", { 
        Text = "Pred Strength", 
        Default = AimSettings.PredictionAmount, 
        Min = 0.05, Max = 0.5, Rounding = 3, Compact = true, 
        Callback = function(v) AimSettings.PredictionAmount = v end 
    })
    
    -- ============================================================
    -- FOV VISUALS GROUP
    -- ============================================================
    local AimFOVGroup = tab:AddRightGroupbox("FOV Visuals")
    
    AimFOVGroup:AddToggle("AimFovEnabled", { 
        Text = "Enabled", 
        Default = AimFOV.Enabled, 
        Callback = function(v) AimFOV.Enabled = v end 
    })
    AimFOVGroup:AddToggle("AimFovVisible", { 
        Text = "Show Circle", 
        Default = AimFOV.Visible, 
        Callback = function(v) AimFOV.Visible = v end 
    })
    AimFOVGroup:AddToggle("AimFovDynamic", { 
        Text = "Dynamic Spread", 
        Default = AimFOV.Dynamic, 
        Callback = function(v) AimFOV.Dynamic = v end 
    })
    AimFOVGroup:AddToggle("AimFovFilled", { 
        Text = "Fill", 
        Default = AimFOV.Filled, 
        Callback = function(v) AimFOV.Filled = v end 
    })
    
    AimFOVGroup:AddSlider("AimFovBaseR", { 
        Text = "Base Radius (Standing)", 
        Default = AimFOV.BaseRadius, 
        Min = 10, Max = 800, Rounding = 0, Compact = true, 
        Callback = function(v) AimFOV.BaseRadius = v end 
    })
    AimFOVGroup:AddSlider("AimFovRunR", { 
        Text = "Run Radius", 
        Default = AimFOV.RunRadius, 
        Min = 10, Max = 800, Rounding = 0, Compact = true, 
        Callback = function(v) AimFOV.RunRadius = v end 
    })
    AimFOVGroup:AddSlider("AimFovJumpR", { 
        Text = "Jump Radius", 
        Default = AimFOV.JumpRadius, 
        Min = 10, Max = 800, Rounding = 0, Compact = true, 
        Callback = function(v) AimFOV.JumpRadius = v end 
    })
    
    AimFOVGroup:AddSlider("AimFovSides", { 
        Text = "Segments", 
        Default = AimFOV.NumSides, 
        Min = 3, Max = 100, Rounding = 0, Compact = true, 
        Callback = function(v) AimFOV.NumSides = v end 
    })
    AimFOVGroup:AddSlider("AimFovThickness", { 
        Text = "Thickness", 
        Default = AimFOV.Thickness, 
        Min = 1, Max = 10, Rounding = 1, Compact = true, 
        Callback = function(v) AimFOV.Thickness = v end 
    })
    AimFOVGroup:AddSlider("AimFovTrans", { 
        Text = "Opacity", 
        Default = AimFOV.Transparency, 
        Min = 0.1, Max = 1.0, Rounding = 2, Compact = true, 
        Callback = function(v) AimFOV.Transparency = v end 
    })
    
    -- ============================================================
    -- COLORS GROUP
    -- ============================================================
    local AimColorsGroup = tab:AddRightGroupbox("Colors")
    
    AimColorsGroup:AddLabel("Primary"):AddColorPicker("AimFovColor", { 
        Default = AimFOV.Color, 
        Callback = function(v) AimFOV.Color = v end 
    })
    AimColorsGroup:AddLabel("Locked"):AddColorPicker("AimFovLockedColor", { 
        Default = AimFOV.LockedColor, 
        Callback = function(v) AimFOV.LockedColor = v end 
    })
    AimColorsGroup:AddToggle("AimFovRainbow", { 
        Text = "Rainbow", 
        Default = AimFOV.RainbowColor, 
        Callback = function(v) AimFOV.RainbowColor = v end 
    })
    
    -- Enable global trigger
    AimbotEnv.TriggerActive = true
end

return Module
