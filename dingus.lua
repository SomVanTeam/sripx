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

local window = orion:MakeWindow({Name = "Dingus TH Vladimir", HidePremium = true, SaveConfig = false, ConfigFolder = "OrionTest", IntroText = "EBANATI"})

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
        simpleESP(m, orion.Flags["hidercolor"].Value)
    end
end

maintab:AddButton({
	Name = "ESP",
	Callback = function(Value)
		addesp()
	end    
})

maintab:AddColorpicker({
	Name = "Hunters ESP",
	Default = Color3.fromRGB(32, 32, 32),
	Flag = "huntercolor"
})

maintab:AddColorpicker({
	Name = "Hiders ESP",
	Default = Color3.fromRGB(128, 16, 200),
	Flag = "hidercolor"
})

orion:Init()
