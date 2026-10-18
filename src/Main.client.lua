
--[[
    ROOT | Main.client.lua
    Point d'entrée de l'interface.
    Environnement : Roblox Studio.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local CONFIG = {
    Name = "ROOT",
    Version = "0.1.0",
    ToggleKey = Enum.KeyCode.Insert,
}

-- Évite de créer plusieurs interfaces.
local existingGui = playerGui:FindFirstChild("ROOT_Interface")
if existingGui then
    existingGui:Destroy()
end

-- Interface principale.
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ROOT_Interface"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainWindow"
mainFrame.Size = UDim2.fromOffset(720, 460)
mainFrame.Position = UDim2.new(0.5, -360, 0.5, -230)
mainFrame.BackgroundColor3 = Color3.fromRGB(17, 19, 27)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(48, 55, 76)
mainStroke.Thickness = 1
mainStroke.Parent = mainFrame

-- Barre supérieure.
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 58)
topBar.BackgroundColor3 = Color3.fromRGB(23, 26, 37)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 12)
topCorner.Parent = topBar

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Position = UDim2.fromOffset(20, 8)
title.Size = UDim2.fromOffset(180, 25)
title.BackgroundTransparency = 1
title.Text = CONFIG.Name
title.TextColor3 = Color3.fromRGB(116, 153, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

local subtitle = Instance.new("TextLabel")
subtitle.Name = "Subtitle"
subtitle.Position = UDim2.fromOffset(21, 33)
subtitle.Size = UDim2.fromOffset(220, 15)
subtitle.BackgroundTransparency = 1
subtitle.Text = "CONTROL CENTER  /  " .. CONFIG.Version
subtitle.TextColor3 = Color3.fromRGB(140, 148, 168)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 10
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = topBar

-- Bouton de fermeture.
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.fromOffset(34, 30)
closeButton.Position = UDim2.new(1, -46, 0, 14)
closeButton.BackgroundColor3 = Color3.fromRGB(42, 45, 59)
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(240, 242, 248)
closeButton.TextSize = 22
closeButton.Font = Enum.Font.Gotham
closeButton.BorderSizePixel = 0
closeButton.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 7)
closeCorner.Parent = closeButton

-- Zone de navigation.
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Position = UDim2.fromOffset(12, 70)
sidebar.Size = UDim2.new(0, 160, 1, -82)
sidebar.BackgroundColor3 = Color3.fromRGB(22, 25, 35)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 9)
sidebarCorner.Parent = sidebar

-- Zone de contenu.
local content = Instance.new("Frame")
content.Name = "Content"
content.Position = UDim2.fromOffset(184, 70)
content.Size = UDim2.new(1, -196, 1, -82)
content.BackgroundTransparency = 1
content.Parent = mainFrame

local pageTitle = Instance.new("TextLabel")
pageTitle.Name = "PageTitle"
pageTitle.Size = UDim2.new(1, -10, 0, 32)
pageTitle.BackgroundTransparency = 1
pageTitle.Text = "Dashboard"
pageTitle.TextColor3 = Color3.fromRGB(242, 244, 250)
pageTitle.Font = Enum.Font.GothamBold
pageTitle.TextSize = 20
pageTitle.TextXAlignment = Enum.TextXAlignment.Left
pageTitle.Parent = content

local pageDescription = Instance.new("TextLabel")
pageDescription.Name = "PageDescription"
pageDescription.Position = UDim2.fromOffset(0, 34)
pageDescription.Size = UDim2.new(1, -10, 0, 24)
pageDescription.BackgroundTransparency = 1
pageDescription.Text = "Welcome to ROOT Control Center."
pageDescription.TextColor3 = Color3.fromRGB(151, 159, 179)
pageDescription.Font = Enum.Font.Gotham
pageDescription.TextSize = 12
pageDescription.TextXAlignment = Enum.TextXAlignment.Left
pageDescription.Parent = content

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "Status"
statusLabel.Position = UDim2.fromOffset(0, 78)
statusLabel.Size = UDim2.new(1, -10, 0, 62)
statusLabel.BackgroundColor3 = Color3.fromRGB(25, 30, 44)
statusLabel.BorderSizePixel = 0
statusLabel.Text = "ROOT is running\nInterface initialized successfully."
statusLabel.TextColor3 = Color3.fromRGB(190, 204, 232)
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.TextSize = 14
statusLabel.Parent = content

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 8)
statusCorner.Parent = statusLabel

-- État de l'interface.
local isVisible = true

local function setVisible(value)
    isVisible = value
    mainFrame.Visible = value
end

closeButton.Activated:Connect(function()
    setVisible(false)
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then
        return
    end

    if input.KeyCode == CONFIG.ToggleKey then
        setVisible(not isVisible)
    end
end)

-- Déplacement de la fenêtre avec la barre supérieure.
local dragging = false
local dragStart
local startPosition

topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPosition = mainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart

        mainFrame.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

print("[ROOT] Initialized — version " .. CONFIG.Version)
