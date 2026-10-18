
--[[
    ROOT | UI/Components.lua
    Composants réutilisables pour l'interface ROOT.
    Compatible Roblox Studio / Luau.
]]

local Components = {}

local COLORS = {
    Background = Color3.fromRGB(17, 19, 27),
    Surface = Color3.fromRGB(25, 29, 41),
    SurfaceHover = Color3.fromRGB(35, 41, 57),
    Accent = Color3.fromRGB(116, 153, 255),
    Text = Color3.fromRGB(240, 243, 250),
    Muted = Color3.fromRGB(145, 154, 174),
    Border = Color3.fromRGB(49, 57, 77),
    Success = Color3.fromRGB(89, 210, 155),
}

Components.Colors = COLORS

local function create(className, properties, parent)
    local object = Instance.new(className)

    for property, value in pairs(properties or {}) do
        object[property] = value
    end

    object.Parent = parent
    return object
end

local function addCorner(object, radius)
    create("UICorner", {
        CornerRadius = UDim.new(0, radius or 8),
    }, object)
end

local function addStroke(object, color, thickness)
    return create("UIStroke", {
        Color = color or COLORS.Border,
        Thickness = thickness or 1,
        Transparency = 0,
    }, object)
end

-- Crée un titre de section.
function Components.CreateSection(parent, text, order)
    local section = create("TextLabel", {
        Name = "Section_" .. text:gsub("%W", ""),
        Size = UDim2.new(1, -4, 0, 28),
        BackgroundTransparency = 1,
        Text = string.upper(text),
        TextColor3 = COLORS.Accent,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = order or 0,
    }, parent)

    return section
end

-- Crée un bouton standard.
function Components.CreateButton(parent, text, callback, order)
    local button = create("TextButton", {
        Name = "Button_" .. text:gsub("%W", ""),
        Size = UDim2.new(1, -4, 0, 38),
        BackgroundColor3 = COLORS.Surface,
        BorderSizePixel = 0,
        Text = text,
        TextColor3 = COLORS.Text,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false,
        LayoutOrder = order or 0,
    }, parent)

    addCorner(button, 7)
    addStroke(button, COLORS.Border, 1)

    create("UIPadding", {
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
    }, button)

    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = COLORS.SurfaceHover
    end)

    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = COLORS.Surface
    end)

    if callback then
        button.Activated:Connect(callback)
    end

    return button
end

-- Crée un interrupteur ON/OFF.
function Components.CreateToggle(parent, text, defaultValue, callback, order)
    local state = defaultValue == true

    local button = create("TextButton", {
        Name = "Toggle_" .. text:gsub("%W", ""),
        Size = UDim2.new(1, -4, 0, 42),
        BackgroundColor3 = COLORS.Surface,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        LayoutOrder = order or 0,
    }, parent)

    addCorner(button, 7)
    addStroke(button, COLORS.Border, 1)

    local label = create("TextLabel", {
        Name = "Label",
        Position = UDim2.fromOffset(12, 0),
        Size = UDim2.new(1, -70, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = COLORS.Text,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, button)

    local track = create("Frame", {
        Name = "Track",
        Size = UDim2.fromOffset(36, 20),
        Position = UDim2.new(1, -48, 0.5, -10),
        BackgroundColor3 = state and COLORS.Accent
            or Color3.fromRGB(65, 69, 84),
        BorderSizePixel = 0,
    }, button)

    addCorner(track, 10)

    local knob = create("Frame", {
        Name = "Knob",
        Size = UDim2.fromOffset(14, 14),
        Position = state
            and UDim2.new(1, -17, 0.5, -7)
            or UDim2.new(0, 3, 0.5, -7),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
    }, track)

    addCorner(knob, 7)

    local function render()
        track.BackgroundColor3 = state and COLORS.Accent
            or Color3.fromRGB(65, 69, 84)

        knob.Position = state
            and UDim2.new(1, -17, 0.5, -7)
            or UDim2.new(0, 3, 0.5, -7)
    end

    button.Activated:Connect(function()
        state = not state
        render()

        if callback then
            callback(state)
        end
    end)

    return {
        Instance = button,
        GetValue = function()
            return state
        end,
        SetValue = function(value)
            state = value == true
            render()

            if callback then
                callback(state)
            end
        end,
    }
end

-- Crée un texte descriptif.
function Components.CreateLabel(parent, text, height, order)
    return create("TextLabel", {
        Name = "Description",
        Size = UDim2.new(1, -4, 0, height or 30),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = COLORS.Muted,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        LayoutOrder = order or 0,
    }, parent)
end

-- Crée une zone de contenu avec défilement automatique.
function Components.CreateList(parent, name)
    local list = create("ScrollingFrame", {
        Name = name or "ComponentList",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = COLORS.Accent,
        CanvasSize = UDim2.fromOffset(0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
    }, parent)

    create("UIPadding", {
        PaddingTop = UDim.new(0, 5),
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 10),
    }, list)

    create("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, list)

    return list
end

-- Crée une carte d'information.
function Components.CreateCard(parent, titleText, descriptionText, order)
    local card = create("Frame", {
        Name = "Card_" .. titleText:gsub("%W", ""),
        Size = UDim2.new(1, -4, 0, 78),
        BackgroundColor3 = COLORS.Surface,
        BorderSizePixel = 0,
        LayoutOrder = order or 0,
    }, parent)

    addCorner(card, 8)
    addStroke(card, COLORS.Border, 1)

    create("TextLabel", {
        Name = "CardTitle",
        Position = UDim2.fromOffset(12, 10),
        Size = UDim2.new(1, -24, 0, 22),
        BackgroundTransparency = 1,
        Text = titleText,
        TextColor3 = COLORS.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, card)

    create("TextLabel", {
        Name = "CardDescription",
        Position = UDim2.fromOffset(12, 35),
        Size = UDim2.new(1, -24, 0, 30),
        BackgroundTransparency = 1,
        Text = descriptionText,
        TextColor3 = COLORS.Muted,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, card)

    return card
end

return Components
