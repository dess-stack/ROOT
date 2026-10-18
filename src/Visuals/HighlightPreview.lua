
local HighlightPreview = {}

local activeHighlight

function HighlightPreview.Apply(target, color)
    if not target or not target:IsA("Model") then
        warn("[ROOT] La cible doit être un Model.")
        return nil
    end

    HighlightPreview.Clear()

    local highlight = Instance.new("Highlight")
    highlight.Name = "ROOT_HighlightPreview"
    highlight.Adornee = target
    highlight.FillColor = color or Color3.fromRGB(130, 80, 255)
    highlight.OutlineColor = Color3.fromRGB(235, 235, 255)
    highlight.FillTransparency = 0.65
    highlight.OutlineTransparency = 0.1
    highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    highlight.Parent = target

    activeHighlight = highlight
    return highlight
end

function HighlightPreview.Clear()
    if activeHighlight then
        activeHighlight:Destroy()
        activeHighlight = nil
    end
end

return HighlightPreview

