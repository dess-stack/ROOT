
local Settings = {}

Settings.App = {
    Name = "ROOT",
    Version = "1.0.0",
    Subtitle = "Developer Toolkit",
}

Settings.UI = {
    Width = 720,
    Height = 460,
    HeaderHeight = 54,
    SidebarWidth = 170,
    CornerRadius = 10,
}

Settings.Colors = {
    Background = Color3.fromRGB(18, 19, 26),
    Panel = Color3.fromRGB(25, 27, 36),
    Card = Color3.fromRGB(31, 33, 44),
    Accent = Color3.fromRGB(135, 85, 255),
    Text = Color3.fromRGB(240, 240, 248),
    Muted = Color3.fromRGB(155, 158, 175),
    Border = Color3.fromRGB(49, 51, 65),
    Success = Color3.fromRGB(85, 210, 145),
    Warning = Color3.fromRGB(255, 190, 80),
}

Settings.Input = {
    ToggleKey = Enum.KeyCode.Insert,
}

Settings.Pages = {
    { Name = "Dashboard", Icon = "⌂" },
    { Name = "Players", Icon = "♙" },
    { Name = "Visuals", Icon = "◉" },
    { Name = "Settings", Icon = "⚙" },
}

return Settings

