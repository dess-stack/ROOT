
--[[
    ROOT | UI/Window.lua
    Fenêtre principale et navigation.
    Dépendance : UI/Components.lua
]]

local Window = {}

local TweenService = game:GetService("TweenService")

local Components = require(script.Parent.Components)
local COLORS = Components.Colors

local function create(className, properties, parent)
    local object = Instance.new(className)

    for property, value in pairs(properties or {}) do
        object[property] = value
    end

    object.Parent = parent
    return object
end

local function corner(object, radius)
    create("UICorner", {
        CornerRadius = UDim.new(0, radius or 8),
    }, object)
end

function Window.Create(parent, options)
    options = options or {}

    local self = {}

    self.Pages = {}
    self.NavigationButtons = {}
    self.CurrentPage = nil
    self.IsVisible = true

    local screen = create("Frame", {
        Name = "ROOT_Window",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible = true,
    }, parent)

    self.Screen = screen

    local main = create("Frame", {
        Name = "Main",
        Size = UDim2.fromOffset(
            options.Width or 760,
            options.Height or 490
        ),
        Position = UDim2.new(0.5, -(options.Width or 760) / 2,
            0.5, -(options.Height or 490) / 2),
        BackgroundColor3 = COLORS.Background,
        BorderSizePixel = 0,
    }, screen)

    corner(main, 12)

    create("UIStroke", {
        Color = COLORS.Border,
        Thickness = 1,
    }, main)

    self.Main = main

    -- En-tête
    local header = create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 62),
        BackgroundColor3 = Color3.fromRGB(23, 26, 37),
        BorderSizePixel = 0,
    }, main)

    corner(header, 12)

    create("TextLabel", {
        Name = "Brand",
        Position = UDim2.fromOffset(20, 9),
        Size = UDim2.fromOffset(200, 26),
        BackgroundTransparency = 1,
        Text = options.Title or "ROOT",
        TextColor3 = COLORS.Accent,
        TextSize = 22,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, header)

    create("TextLabel", {
        Name = "Subtitle",
        Position = UDim2.fromOffset(21, 36),
        Size = UDim2.fromOffset(300, 16),
        BackgroundTransparency = 1,
        Text = options.Subtitle or "CONTROL CENTER",
        TextColor3 = COLORS.Muted,
        TextSize = 10,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, header)

    local close = create("TextButton", {
        Name = "Close",
        Size = UDim2.fromOffset(34, 30),
        Position = UDim2.new(1, -46, 0, 16),
        BackgroundColor3 = COLORS.SurfaceHover,
        Text = "×",
        TextColor3 = COLORS.Text,
        TextSize = 22,
        Font = Enum.Font.Gotham,
        BorderSizePixel = 0,
    }, header)

    corner(close, 7)

    close.Activated:Connect(function()
        self:SetVisible(false)
    end)

    -- Barre latérale
    local sidebar = create("Frame", {
        Name = "Sidebar",
        Position = UDim2.fromOffset(12, 74),
        Size = UDim2.new(0, 174, 1, -86),
        BackgroundColor3 = Color3.fromRGB(22, 25, 35),
        BorderSizePixel = 0,
    }, main)

    corner(sidebar, 9)

    create("UIPadding", {
        PaddingTop = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 9),
        PaddingRight = UDim.new(0, 9),
    }, sidebar)

    create("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, sidebar)

    self.Sidebar = sidebar

    -- Zone principale des pages
    local content = create("Frame", {
        Name = "PageContainer",
        Position = UDim2.fromOffset(198, 74),
        Size = UDim2.new(1, -210, 1, -86),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
    }, main)

    self.Content = content

    -- Déplacement à la souris
    local dragging = false
    local dragInput
    local dragStart
    local startPosition

    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPosition = main.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart

            main.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)

    -- Crée une page
    function self:AddPage(name, icon)
        assert(type(name) == "string", "Page name must be a string")
        assert(not self.Pages[name], "Page already exists: " .. name)

        local page = create("ScrollingFrame", {
            Name = name .. "Page",
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = COLORS.Accent,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.fromOffset(0, 0),
            Visible = false,
        }, content)

        create("UIPadding", {
            PaddingTop = UDim.new(0, 6),
            PaddingLeft = UDim.new(0, 5),
            PaddingRight = UDim.new(0, 5),
            PaddingBottom = UDim.new(0, 12),
        }, page)

        create("UIListLayout", {
            Padding = UDim.new(0, 9),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, page)

        local button = create("TextButton", {
            Name = name .. "Navigation",
            Size = UDim2.new(1, 0, 0, 38),
            BackgroundColor3 = COLORS.Surface,
            Text = (icon and icon .. "   " or "") .. name,
            TextColor3 = COLORS.Muted,
            TextSize = 12,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            LayoutOrder = #self.NavigationButtons + 1,
        }, sidebar)

        corner(button, 7)

        create("UIPadding", {
            PaddingLeft = UDim.new(0, 10),
        }, button)

        self.Pages[name] = page
        self.NavigationButtons[name] = button

        button.Activated:Connect(function()
            self:SelectPage(name)
        end)

        return page
    end

    -- Change de page
    function self:SelectPage(name)
        local target = self.Pages[name]
        if not target then
            warn("[ROOT] Unknown page: " .. tostring(name))
            return
        end

        self.CurrentPage = name

        for pageName, page in pairs(self.Pages) do
            page.Visible = pageName == name
        end

        for pageName, button in pairs(self.NavigationButtons) do
            local selected = pageName == name

            button.BackgroundColor3 = selected
                and Color3.fromRGB(43, 57, 88)
                or COLORS.Surface

            button.TextColor3 = selected
                and COLORS.Accent
                or COLORS.Muted
        end
    end

    -- Affiche ou masque la fenêtre
    function self:SetVisible(value)
        self.IsVisible = value == true
        main.Visible = self.IsVisible
    end

    function self:Toggle()
        self:SetVisible(not self.IsVisible)
    end

    function self:Destroy()
        if screen then
            screen:Destroy()
        end
    end

    -- Animation d'apparition
    main.BackgroundTransparency = 1

    TweenService:Create(
        main,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundTransparency = 0}
    ):Play()

    return self
end

return Window
