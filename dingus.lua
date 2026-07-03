--loadstring(game:HttpGet(("https://raw.githubusercontent.com/SomVanTeam/sripx/refs/heads/main/dingus.lua")))()

function simpleESP(target:Instance, fillcolor:Color3)
    print("Highlighting "..target.Name)
    local highlight = Instance.new("Highlight")
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.OutlineTransparency = 0
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.FillColor = fillcolor
    highlight.Enabled = true
    --highlight.Adornee = target
    highlight.Parent = target
end

local orion = loadstring(game:HttpGet(("https://raw.githubusercontent.com/jensonhirst/Orion/main/source")))()

local window = orion:MakeWindow({Name = "Dingus TH Vladimir", HidePremium = true, SaveConfig = false, ConfigFolder = "OrionTest", IntroText = "EBANATI2"})

local maintab = window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local function addesp()
    for _, h in pairs(workspace:GetDescendants()) do
        if h and h:IsA("Highlight") then
            h:Destroy()
        end
    end
	for _, p in pairs(game.Players:GetPlayers()) do
        local m = workspace:FindFirstChild(p.Name) or p.Character or nil
        if not m then
            print(p.Name.." Not Found")
            continue
        end
        local highlightTag = m:GetAttribute("HighlightTag")
        if highlightTag == "Hunter" or highlightTag == "HordeTracker" then
            simpleESP(m, orion.Flags["huntercolor"].Value)
        else
            simpleESP(m, orion.Flags["hidercolor"].Value)
        end
    end
end

maintab:AddToggle({
	Name = "Noclip",
    Default = false,
    Flag = "noclip",
	Callback = function(Value)

    end
})

maintab:AddButton({
	Name = "ESP",
	Callback = addesp
})

maintab:AddColorpicker({
	Name = "Hunters ESP",
	Default = Color3.fromRGB(32, 32, 32),
	Flag = "huntercolor"
})

maintab:AddColorpicker({
	Name = "Hiders ESP",
	Default = Color3.fromRGB(200, 16, 64),
	Flag = "hidercolor"
})

orion:Init()
print("--------------------------------- INIT -------------------------------")
