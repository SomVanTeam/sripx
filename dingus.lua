--[[
loadstring(game:HttpGet((
""
)))()
]]
local util = {}

function util.safeDestroy(target:Instance)
    pcall(function()
        target:Destroy()
    end)
end

util.canRemoveESPOnLimit = true
util.maxESP = 31
util.ESPHighlights = {}
function util.simpleESP(target:Instance)
    print("Highlighting "..target.Name)
    local highlight = Instance.new("Highlight")
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.OutlineTransparency = 0
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.Enabled = true
    table.insert(util.ESPHighlights, highlight)
    if #util.ESPHighlights > util.maxESP then
        if util.canRemoveESPOnLimit then
            local oldhighlight = util.ESPHighlights[1]
            oldhighlight:Destroy()
        end
    end
    --highlight.Adornee = target
    highlight.Parent = target
end

function util.clearESP()
    for _, esp in pairs(util.ESPHighlights) do
        if esp then
            esp:Destroy()
        end
    end
    table.clear(util.ESPHighlights)
end

local function updateESP()
    for _, h in pairs(workspace:GetDescendants()) do
        if h and h:IsA("Highlight") then
            h:Destroy()
        end
    end
    for _, p in pairs(game.Players:GetPlayers()) do
        local m = workspace:FindFirstChild(p.Name) or p.Character or nil
        if not m then
            --for _, cont in pairs(workspace:GetChildren()) do
            --    if cont.Name == "HighlightContainer" then
            --        m = cont:FindFirstChild(p.Name)
            --        if not m then
                        print(p.Name.." Not Found")
                        continue
            --        end
            --    end
            --end
        end
        if m ~= nil then
            util.simpleESP(m)
        end
    end
end

local roundStartedEvent = game.ReplicatedStorage.Remotes.RoundStarted

updateESP()
roundStartedEvent.OnClientEvent:Connect(function(...)
    print("ROUND STARTED EVENT")
    task.wait(2)
    updateESP()
end)

print("------------------------------------------------------------------------------")
