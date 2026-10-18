
local Players = game:GetService("Players")

local PlayerList = {}

function PlayerList.Create(parent, onSelect)
    local list = Instance.new("ScrollingFrame")
    list.Name = "ROOT_PlayerList"
    list.Size = UDim2.new(1, 0, 1, 0)
    list.BackgroundTransparency = 1
    list.BorderSizePixel = 0
    list.ScrollBarThickness = 4
    list.AutomaticCanvasSize = Enum.AutomaticSize.Y
    list.CanvasSize = UDim2.new(0, 0, 0, 0)
    list.Parent = parent

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.Parent = list

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.Name
    layout.Parent = list

    local connections = {}
    local rows = {}

    local function refresh()
        for _, row in pairs(rows) do
            row:Destroy()
        end
        table.clear(rows)

        for _, player in ipairs(Players:GetPlayers()) do
            local button = Instance.new("TextButton")
            button.Name = "Player_" .. player.UserId
            button.Size = UDim2.new(1, -8, 0, 42)
            button.BackgroundColor3 = Color3.fromRGB(31, 33, 44)
            button.TextColor3 = Color3.fromRGB(240, 240, 248)
            button.Font = Enum.Font.GothamMedium
            button.TextSize = 13
            button.Text = player.DisplayName .. "  (@" .. player.Name .. ")"
            button.TextTruncate = Enum.TextTruncate.AtEnd
            button.Parent = list

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 7)
            corner.Parent = button

            button.Activated:Connect(function()
                if onSelect then
                    onSelect(player)
                end
            end)

            table.insert(rows, button)
        end
    end

    table.insert(connections, Players.PlayerAdded:Connect(refresh))
    table.insert(connections, Players.PlayerRemoving:Connect(refresh))

    refresh()

    return {
        Frame = list,

        Refresh = refresh,

        Destroy = function()
            for _, connection in ipairs(connections) do
                connection:Disconnect()
            end

            list:Destroy()
        end
    }
end

return PlayerList

