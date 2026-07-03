--loadstring(game:HttpGet(("https://raw.githubusercontent.com/SomVanTeam/sripx/refs/heads/main/dingus.lua")))()
local pathfindingService = game:GetService("PathfindingService")
local player = game.Players.LocalPlayer
local floatName = "8daGGgtdygg6TG688dh"

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

-- returns {{all tasks}, {active tasks}} DOESNT RETURN GREEN TASKS
function getTasks()
    local tasks = {}
    local activetasks = {}
    local map = getCurrentMap()
    for _, t in pairs(map:GetChildren()) do
        if t.Name == "PointTask" then
            if t.Base.Color == Color3.fromRGB(137, 255, 111) then
                continue
            end
            table.insert(tasks, t)
            local tr = t.Gradients.Outer.GradientUI.ActiveGradient.ImageTransparency
            if tr ~= 1 then
                print("active task")
                table.insert(activetasks, t)
            end
        end
    end
    return {tasks, activetasks}
end

function isRedTask(task:Model)
    return task.Base.Color == Color3.fromRGB(255, 83, 83)
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

local floatpart = nil
function mainloop()
    if player.Character ~= nil then
        local noclip = orion.Flags["noclip"].Value
        local float = orion.Flags["float"].Value

        for _, child in pairs(player.Character:GetDescendants()) do
            if child:IsA("BasePart") and child.CanCollide == noclip and child.Name ~= floatName then
                child.CanCollide = not noclip
            end
        end

        if float then
            if floatpart == nil then
                floatpart = Instance.new("Part")
                floatpart.Anchored = true
                floatpart.CanCollide = true
                floatpart.Size = Vector3.new(2, 0.1, 2)
                floatpart.Name = floatName
                floatpart.Parent = workspace
            end
            local humroot = player.Character:FindFirstChild("HumanoidRootPart") or player.Character.Rig:FindFirstChild("HumanoidRootPart")
            floatpart.Position = humroot.Position - Vector3.new(0, 2.45, 0)
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

maintab:AddButton({
	Name = "Test1",
	Callback = function()

    end
})

maintab:AddToggle({
	Name = "Float",
    Default = false,
    Flag = "float",
	Callback = function(Value) end
})

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
	Name = "Test2",
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
