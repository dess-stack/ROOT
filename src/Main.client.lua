
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local Settings = require(
    ReplicatedStorage:WaitForChild("ROOT")
        :WaitForChild("Config")
        :WaitForChild("Settings")
)

local Components = require(
    ReplicatedStorage:WaitForChild("ROOT")
        :WaitForChild("UI")
        :WaitForChild("Components")
)

local Window = require(
    ReplicatedStorage:WaitForChild("ROOT")
        :WaitForChild("UI")
        :WaitForChild("Window")
)

local Sidebar = require(
    ReplicatedStorage:WaitForChild("ROOT")
        :WaitForChild("UI")
        :WaitForChild("Sidebar")
)

local PlayerList = require(
    ReplicatedStorage:WaitForChild("ROOT")
        :WaitForChild("Players")
        :WaitForChild("PlayerList")
)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ROOT_GUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local window = Window.Create(screenGui, {
    Title = Settings.App.Name,
    Width = Settings.UI.Width,
    Height = Settings.UI.Height,
})

local dashboard = window:AddPage("Dashboard", "⌂")
local playersPage = window:AddPage("Players", "♙")
local visualsPage = window:AddPage("Visuals", "◉")
local settingsPage = window:AddPage("Settings", "⚙")

local sidebar = Sidebar.Create(
    window.Main,
    Settings.Pages,
    function(pageName)
        window:SelectPage(pageName)
        sidebar:SetActive(pageName)
    end
)

sidebar:SetActive("Dashboard")

Components.CreateCard(
    dashboard,
    "Welcome to ROOT",
    "Your personal Roblox development toolkit.",
    1
)

Components.CreateLabel(
    dashboard,
    "Version: " .. Settings.App.Version,
    30,
    2
)

local playerList = PlayerList.Create(playersPage, function(selectedPlayer)
    print("[ROOT] Selected player:", selectedPlayer.Name)
end)

Components.CreateLabel(
    visualsPage,
    "Visual previews for your own Roblox experience.",
    36,
    1
)

Components.CreateLabel(
    settingsPage,
    "ROOT configuration",
    30,
    1
)

local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then
        return
    end

    if input.KeyCode == Settings.Input.ToggleKey then
        window:SetVisible(not window.Frame.Visible)
    end
end)

script.Destroying:Connect(function()
    playerList.Destroy()
    sidebar.Destroy()
    window:Destroy()
    screenGui:Destroy()
end)
