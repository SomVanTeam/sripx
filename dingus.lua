--loadstring(game:HttpGet(("https://raw.githubusercontent.com/SomVanTeam/sripx/refs/heads/main/dingus.lua")))()
local pathfindingService = game:GetService("PathfindingService")
local player = game.Players.LocalPlayer
local floatName = "FLOATPART"

function simpleESP(target:Instance, fillcolor:Color3)
    print("Highlighting "..target.Name)
    local highlight = Instance.new("Highlight")
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.OutlineTransparency = 0
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.25
    highlight.FillColor = fillcolor
    highlight.Enabled = true
    --highlight.Adornee = target
    highlight.Parent = target
end

function getCurrentMap():Model
    return workspace:FindFirstChild("CliffsideV2")
        or workspace:FindFirstChild("OldBeach")
        or workspace:FindFirstChild("LegacyWildWest")
        or workspace:FindFirstChild("BeachRedux")
end

function getCurrentCollidersFolder():Folder
    local map = getCurrentMap()
    local collidersFolder = map:FindFirstChild("InvisibleBoxes") or map:FindFirstChild("Colliders")
    return collidersFolder
end

local pathfinding
function attemptPathfindTo(target:Vector3):nil
    if pathfinding then
        task.cancel(pathfinding)
    end
    pathfinding = task.spawn(function()
        local path = PathfindingService:CreatePath({
            AgentCanClimb = false,
            AgentCanJump = false,
            Costs = { -- AccessOnly DislikeWalk NoPathfind Passable
                NoPathfind = math.huge, DislikeWalk = 20, AccessOnly = -10
            }
        })
        path:ComputeAsync(player.Character.HumanoidRootPart.Position, target)
        local waypoints = path:GetWaypoints()
        for _, waypoint in pairs(waypoints) do
            local centertarget = Instance.new("Part")
            centertarget.CanCollide = false
            centertarget.Anchored = true
            centertarget.Position = waypoint.Position
            centertarget.Parent = workspace
            player.Character.Humanoid:MoveTo(waypoint.Position, centertarget)
            player.Character.Humanoid.MoveToFinished:Wait()
            centertarget:Destroy()
        end
    end)
end

-- function pushPart(dir:Vector3, pushinto)
--     local map = getCurrentMap()
--     local collidersFolder = map:FindFirstChild("InvisibleBoxes")
--     -- :IsDescendantOf(collidersFolder)
-- end

local orion = loadstring(game:HttpGet(("https://raw.githubusercontent.com/jensonhirst/Orion/main/source")))()

function mainloop()
    if player.Character ~= nil then
        local noclip = orion.Flags["noclip"].Value
        for _, child in pairs(player.Character:GetChildren()) do
            if child:IsA("BasePart") and child.CanCollide == noclip and child.Name ~= floatName then
                child.CanCollide = not noclip
            end
        end
    end
end

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
	Callback = function(Value) end
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

maintab:AddToggle({
	Name = "Show Colliders",
    Default = false,
	Callback = function(Value)
        for _, part in pairs(getCurrentCollidersFolder():GetDescendants()) do
            if part:IsA("Part") then
                if Value then
                    part.Transparency = 0
                else
                    part.Transparency = 1
                end
            end
        end
    end
})

maintab:AddToggle({
	Name = "Auto Walk Test",
    Default = false,
    Flag = "autowalking",
	Callback = function(Value)
        if Value then
            
        else
            if pathfinding then
                task.cancel(pathfinding)
            end
            pathfinding = nil
        end
    end
})

orion:Init()
game:GetService("RunService").Stepped:Connect(mainloop)
print("--------------------------------- DINGUS TH INIT -------------------------------")
