--[[
https://www.roblox.com/share?code=c947bd6f9524044eb7524850a33fa41b&type=Server
loadstring(game:HttpGet(("https://raw.githubusercontent.com/SomVanTeam/sripx/refs/heads/main/psf.lua")))()
]]

------------------- LOGIC -------------------

local networker = game.ReplicatedStorage.Modules.Network.Network.RemoteEvent

function execCommand(buffertable)
    networker:FireServer(
        "ExecuteCommand",
        buffertable
    )
end

local TARGETALL = buffer.fromstring("\x03\x03\x00\x00\x00All")
function strToBuf(s)
    local b = buffer.fromstring("\x03\x00\x00\x00\x00"..s)
    buffer.writeu8(b, 1, string.len(s))
    return b
end

function numToBuf(n)
    -- 02 00 00 00 00 00 00 0B 40
    local b = buffer.create(9)
    buffer.writeu8(b, 0, 2)
    buffer.writef64(b, 1, n)
    return b
end

local COMMANDS = {
    ["GiveStatus"] = buffer.fromstring("\x03\x0A\x00\x00\x00GiveStatus"),
    ["KillPlayer"] = buffer.fromstring("\x03\x0A\x00\x00\x00KillPlayer"),
    ["ToggleTimer"] = buffer.fromstring("\x03\x0B\x00\x00\x00ToggleTimer"),
    ["ForceNextKiller"] = buffer.fromstring("\x03\x0F\x00\x00\x00ForceNextKiller"),
    ["ForceRoundEnd"] = buffer.fromstring("\x03\r\x00\x00\x00ForceRoundEnd"),
    ["ForceIntermissionEnd"] = buffer.fromstring("\x03\x14\x00\x00\x00ForceIntermissionEnd"),
    ["SendAnnouncement"] = buffer.fromstring("\x03\x10\x00\x00\x00SendAnnouncement")
}
local STATUSTYPE = {
    ["Speed"] = buffer.fromstring("\x03\x05\x00\x00\x00Speed"),
    ["Nausea"] = buffer.fromstring("\x03\x06\x00\x00\x00Nausea"),
    ["Strength"] = buffer.fromstring("\x03\x08\x00\x00\x00Strength"),
    ["Weakness"] = buffer.fromstring("\x03\x08\x00\x00\x00Weakness"),
    ["Slowness"] = buffer.fromstring("\x03\x08\x00\x00\x00Slowness"),
    ["Helpless"] = buffer.fromstring("\x03\x08\x00\x00\x00Helpless"),
    ["Slateskin"] = buffer.fromstring("\x03\x09\x00\x00\x00Slateskin"),
    ["Blindness"] = buffer.fromstring("\x03\x09\x00\x00\x00Blindness"),
    ["Subspaced"] = buffer.fromstring("\x03\x09\x00\x00\x00Subspaced"),
    ["Confusion"] = buffer.fromstring("\x03\x09\x00\x00\x00Confusion"),
    ["Exhausted"] = buffer.fromstring("\x03\x09\x00\x00\x00Exhausted"),
    ["Vulnerable"] = buffer.fromstring("\x03\x0A\x00\x00\x00Vulnerable"),
    ["Resistance"] = buffer.fromstring("\x03\x0A\x00\x00\x00Resistance"),
    ["Regeneration"] = buffer.fromstring("\x03\x0B\x00\x00\x00Regeneration"),
    ["Invisibility"] = buffer.fromstring("\x03\x0B\x00\x00\x00Invisibility"),
}
--[[
1 = 240 63 = 11110000 00111111
2  = 0  64 = 00000000 01000000
3  = 11 64 = 00001011 01000000
4  = 16 64 = 00010000 01000000
5  = 20 64 = 00010100 01000000
6  = 24 64 = 00011000 01000000
7  = 28 64 = 00011100 01000000
8  = 32 64 = 00100000 01000000
9  = 34 64 = 00100010 01000000
10 = 36 64 = 00100100 01000000
15 = 46 64 = 00101110 01000000
20 = 52 64 = 00110100 01000000
30 = 62 64 = 00111110 01000000
60 = 78 64 = 01001110 01000000
90 = 86 64 = 01010110 01000000
00 00 00 00 00 00 0B 40
]]

local STATUSLEVEL = {
    [1] = buffer.fromstring("\x02\x00\x00\x00\x00\x00\x00\xF0?"),
    [2] = buffer.fromstring("\x02\x00\x00\x00\x00\x00\x00\x00@"),
    [3] = buffer.fromstring("\x02\x00\x00\x00\x00\x00\x00\x0B@"),
    [4] = buffer.fromstring("\x02\x00\x00\x00\x00\x00\x00\x10@"),
    [5] = buffer.fromstring("\x02\x00\x00\x00\x00\x00\x00\x14@"),
    [6] = buffer.fromstring("\x02\x00\x00\x00\x00\x00\x00\x18@"),
    [7] = buffer.fromstring("\x02\x00\x00\x00\x00\x00\x00\x1C@"),
    [8] = buffer.fromstring("\x02\x00\x00\x00\x00\x00\x00\x20@"),
    [9] = buffer.fromstring("\x02\x00\x00\x00\x00\x00\x00\x22@"),
    [10] = buffer.fromstring("\x02\x00\x00\x00\x00\x00\x00$@"),
}
local STATUSLEN = {
    ["5s"] = buffer.fromstring("\x02\x00\x00\x00\x00\x00\x00\x14@"),
    ["10s"] = buffer.fromstring("\x02\x00\x00\x00\x00\x00\x00$@"),
    ["15s"] = buffer.fromstring("\x02\x00\x00\x00\x00\x00\x00.@"),
    ["20s"] = buffer.fromstring("\x02\x00\x00\x00\x00\x00\x004@"),
    ["30s"] = buffer.fromstring("\x02\x00\x00\x00\x00\x00\x00>@"),
    ["60s"] = buffer.fromstring("\x02\x00\x00\x00\x00\x00\x00N@"),
    ["90s"] = buffer.fromstring("\x02\x00\x00\x00\x00\x00\x00V@"),
}

local statusesMode = false
-- statustype = statuslevel
local survivorStatuses = {}
local killerStatuses = {}

function giveStatus(targetbuf, statustypebuf, statuslevelbuf, statuslenbuf)
    execCommand({
        COMMANDS["GiveStatus"],
        targetbuf,
        statustypebuf,
        statuslevelbuf,
        statuslenbuf
    })
end

function killPlayer(targetbuf)
    execCommand({
        COMMANDS["KillPlayer"],
        targetbuf
    })
end

local timerstopped = true
function toggleTimer()
    execCommand({
        COMMANDS["ToggleTimer"]
    })
    timerstopped = not timerstopped
end

function startTimer()
    if timerstopped then
        toggleTimer()
    end
end

function stopTimer()
    if not timerstopped then
        toggleTimer()
    end
end

function forceRoundEnd()
    execCommand({
        COMMANDS["ForceRoundEnd"]
    })
end

function forceIntermissionEnd()
    execCommand({
        COMMANDS["ForceIntermissionEnd"]
    })
end

function forceNextKiller(targetbuf)
    execCommand({
        COMMANDS["ForceNextKiller"],
        targetbuf
    })
end

-- broken and unnecessary
function sendAnnouncement(msg)
    -- execCommand({
    --     COMMANDS["SendAnnouncement"],
    --     strToBuf(msg)
    -- })
end

local roundSettingUp = false
local roundBegan = false
local roundBeganAt = 0

function beginWithKiller(killeruser, preptime)
    if #game.Players:GetPlayers() <= 1 then
        return
    end
    roundSettingUp = true
    startTimer()
    task.wait(1)
    forceNextKiller(strToBuf(killeruser))
    task.wait(1)
    forceIntermissionEnd()
    stopTimer()
    task.wait(preptime)
    giveStatus(TARGETALL, STATUSTYPE["Slowness"], STATUSLEVEL[10], numToBuf(5))--STATUSLEN["5s"])
    giveStatus(TARGETALL, STATUSTYPE["Helpless"], STATUSLEVEL[10], STATUSLEN["5s"])
    giveStatus(TARGETALL, STATUSTYPE["Resistance"], STATUSLEVEL[10], STATUSLEN["5s"])
    task.wait(5)
    roundBeganAt = os.time()
    roundBegan = true
    task.wait(1)
    roundSettingUp = false
end

function endRound()
    roundSettingUp = true
    startTimer()
    task.wait(1)
    forceRoundEnd()
    task.wait(1)
    stopTimer()
    task.wait(1)
    roundBegan = false
    roundSettingUp = false
    return os.time() - roundBeganAt
end

function canPlay(plr)
    -- for some insane reason this doesnt work
    -- if not plr:GetAttribute("Loaded") then
    --     return false
    -- end
    -- if plr.PlayerData.Settings.Game.AFK.Value then
    --     return false
    -- end
    return true
end

------------------- ORION -------------------

local orion = loadstring(game:HttpGet(("https://raw.githubusercontent.com/jensonhirst/Orion/main/source")))()

local window = orion:MakeWindow({Name = "PS Helper TH Vladimir", HidePremium = true, SaveConfig = false, ConfigFolder = "OrionTest", IntroText = "EBANATI2"})

local maintab = window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local survivorstatustab = window:MakeTab({
	Name = "Srv Statuses",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local killerstatustab = window:MakeTab({
	Name = "Klr Statuses",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

function createStatusSlider(tab, statustable, status)
    tab:AddSlider({
        Name = status,
        Min = 0,
        Max = 10,
        Default = 0,
        Color = Color3.fromRGB(255,255,255),
        Increment = 1,
        ValueName = "Level",
        Callback = function(Value)
            statustable[status] = Value
        end
    })
end

for statustype, statustypebuf in pairs(STATUSTYPE) do
    createStatusSlider(survivorstatustab, survivorStatuses, statustype)
    createStatusSlider(killerstatustab, killerStatuses, statustype)
end

local roundTimeLabel = maintab:AddLabel("---")

maintab:AddSlider({
	Name = "Preptime",
	Min = 5,
	Max = 60,
	Default = 15,
	Color = Color3.fromRGB(255,255,255),
	Increment = 5,
	ValueName = "Seconds",
    Flag = "preptime"
})

maintab:AddToggle({
	Name = "Give Statuses",
	Default = false,
    Flag = "givestatuses"
})

maintab:AddButton({
	Name = "Begin Round",
	Callback = function()
        if roundSettingUp or roundBegan then
            orion:MakeNotification({
                Name = "Error",
                Content = "Round has begun already",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
            return
        end
        beginWithKiller(orion.Flags["killer"].Value, orion.Flags["preptime"].Value)
    end
})

maintab:AddButton({
    Name = "End Round",
    Callback = function()
        if roundSettingUp or not roundBegan then
            orion:MakeNotification({
                Name = "Error",
                Content = "Round hasn't begun",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
            return
        end
        local roundTime = endRound()
        roundTimeLabel:Set(string.format("Last Round Lasted %02d:%02d", roundTime // 60, roundTime % 60))
    end
})

local killerdropdown = maintab:AddDropdown({
	Name = "Killer",
	Default = game.Players.LocalPlayer.Name,
	Options = {game.Players.LocalPlayer.Name},
	Flag = "killer"
})

function refreshDropdowns()
    local names = {}
    for _, plr in pairs(game.Players:GetPlayers()) do
        table.insert(names, plr.Name)
    end
    killerdropdown:Refresh(names,true)
    killerdropdown:Set(names[1])
end
refreshDropdowns()

local d = 0
function mainloop()
    if roundBegan then
        if orion.Flags["givestatuses"].Value then
            d += 1
            if d >= 120 then
                d = 0
                for _, plr in pairs(game.Players:GetPlayers()) do
                    if canPlay(plr) then
                        -- this is fucking cancerous
                        if plr.Name == orion.Flags["killer"].Value then
                            for statustype, statuslevelraw in pairs(killerStatuses) do
                                if statuslevelraw > 0 then
                                    giveStatus(strToBuf(plr.Name), STATUSTYPE[statustype], STATUSLEVEL[statuslevelraw], STATUSLEN["30s"])
                                end
                            end
                        else
                            for statustype, statuslevelraw in pairs(survivorStatuses) do
                                if statuslevelraw > 0 then
                                    giveStatus(strToBuf(plr.Name), STATUSTYPE[statustype], STATUSLEVEL[statuslevelraw], STATUSLEN["30s"])
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

game.Players.PlayerAdded:Connect(refreshDropdowns)
game.Players.PlayerRemoving:Connect(refreshDropdowns)
game:GetService("RunService").Heartbeat:Connect(mainloop)

orion:Init()
