
local Sidebar = {}

local Components = require(script.Parent.Components)

function Sidebar.Create(parent, pages, onSelect)
    local container = Instance.new("Frame")
    container.Name = "ROOT_Sidebar"
    container.Size = UDim2.new(0, 170, 1, -54)
    container.Position = UDim2.new(0, 0, 0, 54)
    container.BackgroundColor3 = Components.Colors.Panel
    container.BorderSizePixel = 0
    container.Parent = parent

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 12)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.Parent = container

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 7)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = container

    local buttons = {}

    for index, page in ipairs(pages) do
        local button = Instance.new("TextButton")
        button.Name = "Page_" .. page.Name
        button.Size = UDim2.new(1, 0, 0, 38)
        button.BackgroundColor3 = Components.Colors.Panel
        button.TextColor3 = Components.Colors.Text
        button.Font = Enum.Font.GothamMedium
        button.TextSize = 13
        button.Text = (page.Icon or "•") .. "  " .. page.Name
        button.TextXAlignment = Enum.TextXAlignment.Left
        button.AutoButtonColor = false
        button.LayoutOrder = index
        button.Parent = container

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 7)
        corner.Parent = button

        local buttonPadding = Instance.new("UIPadding")
        buttonPadding.PaddingLeft = UDim.new(0, 12)
        buttonPadding.Parent = button

        button.Activated:Connect(function()
            if onSelect then
                onSelect(page.Name)
            end
        end)

        buttons[page.Name] = button
    end

    function Sidebar.SetActive(name)
        for pageName, button in pairs(buttons) do
            local active = pageName == name

            button.BackgroundColor3 = active
                and Components.Colors.Accent
                or Components.Colors.Panel

            button.TextColor3 = active
                and Color3.new(1, 1, 1)
                or Components.Colors.Text
        end
    end

    function Sidebar.Destroy()
        container:Destroy()
    end

    return {
        Frame = container,
        Buttons = buttons,
        SetActive = Sidebar.SetActive,
        Destroy = Sidebar.Destroy
    }
end

return Sidebar
