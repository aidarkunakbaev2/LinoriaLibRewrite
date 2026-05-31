--[[
    PROJECT RADIANT | MODULAR ARCHITECTURE
    Main Entry Point - Version 0.43
    
    Structure:
    /Project-Radiant/
        ├── main.lua (this file - initialization)
        ├── config/
        │   └── settings.lua (global config)
        ├── modules/
        │   ├── Combat/
        │   │   └── aimbot.lua
        │   ├── ESP/
        │   │   ├── box.lua
        │   │   ├── healthbar.lua
        │   │   ├── tracers.lua
        │   │   └── manager.lua
        │   ├── Visuals/
        │   │   ├── fov.lua
        │   │   ├── glow.lua
        │   │   └── animations.lua
        │   ├── Players/
        │   │   ├── friends.lua
        │   │   └── visibility.lua
        │   └── Utility/
        │       └── automation.lua
        └── ui/
            └── tabs.lua
]]

----Loading External Libraries----
local repo = "https://raw.githubusercontent.com/xXnikotosYTXx/LinoriaLibRewrite/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

-- Global Services
local TweenService = game:GetService("TweenService")
local camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Cleanup previous instances
if getgenv().current_esplib and getgenv().current_esplib.force_cleanup then
    getgenv().current_esplib.force_cleanup()
end

-- Load ESP Library
local esplib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xXnikotosYTXx/esp-lib.lua/refs/heads/main/source.lua"))()
getgenv().current_esplib = esplib

-- Load Aimbot
local aimbot_url = "https://raw.githubusercontent.com/xXnikotosYTXx/esp-lib.lua/refs/heads/main/aimsource.lua"
local AimbotEnvironment = loadstring(game:HttpGet(aimbot_url))()
AimbotEnvironment:Load()

----Window Setup----
local Window = Library:CreateWindow({
    Title = "Project | Radiant | 0.43",
    Center = true,
    AutoShow = true,
    Resizable = true,
    ShowCustomCursor = true,
    UnlockMouseWhileOpen = true,
    NotifySide = "Left",
    TabPadding = 8,
    MenuFadeTime = 0.2
})

-- Create Tabs
local Tabs = {
    Combat   = Window:AddTab("Combat"),
    ESP      = Window:AddTab("ESP"),
    Visuals  = Window:AddTab("Visuals"),
    Players  = Window:AddTab("Players"),
    Utility  = Window:AddTab("Utility"),
    Settings = Window:AddTab("Settings"),
}

-- Global References
getgenv().ProjectRadiant = {
    Window = Window,
    Tabs = Tabs,
    Library = Library,
    TweenService = TweenService,
    Camera = camera,
    ESPLib = esplib,
    AimbotEnv = AimbotEnvironment,
    Connections = {}
}

-- Load UI Modules
local CombatUI = loadstring(game:HttpGet(repo:gsub("main/$", "project-radiant-refactor/") .. "Project-Radiant/ui/combat.lua"))()
local ESPUI = loadstring(game:HttpGet(repo:gsub("main/$", "project-radiant-refactor/") .. "Project-Radiant/ui/esp.lua"))()
local VisualsUI = loadstring(game:HttpGet(repo:gsub("main/$", "project-radiant-refactor/") .. "Project-Radiant/ui/visuals.lua"))()
local PlayersUI = loadstring(game:HttpGet(repo:gsub("main/$", "project-radiant-refactor/") .. "Project-Radiant/ui/players.lua"))()
local UtilityUI = loadstring(game:HttpGet(repo:gsub("main/$", "project-radiant-refactor/") .. "Project-Radiant/ui/utility.lua"))()
local SettingsUI = loadstring(game:HttpGet(repo:gsub("main/$", "project-radiant-refactor/") .. "Project-Radiant/ui/settings.lua"))()

-- Initialize UI Tabs
CombatUI.Init(Tabs.Combat, AimbotEnvironment)
ESPUI.Init(Tabs.ESP, esplib)
VisualsUI.Init(Tabs.Visuals)
PlayersUI.Init(Tabs.Players, esplib)
UtilityUI.Init(Tabs.Utility, esplib)
SettingsUI.Init(Tabs.Settings, Library, Window)

----Auto ESP System----
local function addESPToChar(char)
    task.wait(0.2)
    pcall(function()
        esplib.add_box(char)
        esplib.add_healthbar(char)
        esplib.add_name(char)
        esplib.add_distance(char)
        esplib.add_tracer(char)
    end)
end

local function handlePlayer(plr)
    if plr == LocalPlayer then return end
    
    table.insert(getgenv().ProjectRadiant.Connections, plr.CharacterAdded:Connect(function(char)
        if Library.Toggles.AutoESP and Library.Toggles.AutoESP.Value then
            addESPToChar(char)
        end
    end))
    
    if plr.Character and Library.Toggles.AutoESP and Library.Toggles.AutoESP.Value then
        addESPToChar(plr.Character)
    end
end

for _, plr in ipairs(Players:GetPlayers()) do
    handlePlayer(plr)
end

table.insert(getgenv().ProjectRadiant.Connections, Players.PlayerAdded:Connect(function(plr)
    handlePlayer(plr)
end))

pcall(function()
    table.insert(getgenv().ProjectRadiant.Connections, workspace.Live.ChildAdded:Connect(function(child)
        if Library.Toggles.AutoESPDummy and Library.Toggles.AutoESPDummy.Value and child:FindFirstChildOfClass("Humanoid") then
            task.wait(0.5)
            addESPToChar(child)
        end
    end))
end)

----Save & Theme System----
Library.ToggleKeybind = Library.Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind", "AimSilentKey", "AimCameraKey" })
ThemeManager:SetFolder("Project-Radiant")
SaveManager:SetFolder("Project-Radiant/configs")
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)
SaveManager:LoadAutoloadConfig()

----Watermark----
Library:SetWatermark("ESP Cheat Ultimate", true)
Library:SetWatermarkVisibility(true)

----Unload Handler----
Library:OnUnload(function()
    pcall(function()
        for _, conn in ipairs(getgenv().ProjectRadiant.Connections) do
            if conn and conn.Disconnect then conn:Disconnect() end
        end
    end)
    
    pcall(function()
        if esplib and esplib.force_cleanup then esplib.force_cleanup() end
    end)
    
    pcall(function()
        if AimbotEnvironment and AimbotEnvironment.Exit then 
            AimbotEnvironment:Exit() 
        end
    end)
    
    pcall(function()
        if Library.Toggles.FOVEnabled and Library.Toggles.FOVEnabled.Value then
            TweenService:Create(camera, TweenInfo.new(0.4, Enum.EasingStyle.Sine), { FieldOfView = 70 }):Play()
        end
    end)
    
    pcall(function()
        getgenv().esplib = nil
        getgenv().current_esplib = nil
        getgenv().ProjectRadiant = nil
    end)
    
    Library:Notify("Cheat completely reset for re-injection", 3)
end)

Library:Notify("Project | Radiant | 0.43 | Loaded Successfully! | END to toggle", 5)
