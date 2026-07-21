--[[
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
    ["Vulnerable"] = buffer.fromstring("\x03\x0A\x00\x00\x00Vulnerable"),
    ["Resistance"] = buffer.fromstring(""),
    ["Speed"] = buffer.fromstring(""),
    ["Invisibility"] = buffer.fromstring(""),
    ["Slowness"] = buffer.fromstring("\x03\x08\x00\x00\x00Slowness"),
    ["Helpless"] = buffer.fromstring("\x03\x08\x00\x00\x00Helpless"),
}
local STATUSLEVEL = {
    ["1l"] = buffer.fromstring("\x02\x00\x00\x00\x00\x00\x00\xF0?"),
    ["2l"] = buffer.fromstring(""),
    ["3l"] = buffer.fromstring(""),
    ["4l"] = buffer.fromstring(""),
    ["5l"] = buffer.fromstring(""),
    ["6l"] = buffer.fromstring(""),
    ["7l"] = buffer.fromstring(""),
    ["8l"] = buffer.fromstring(""),
    ["9l"] = buffer.fromstring(""),
    ["10l"] = buffer.fromstring("\x02\x00\x00\x00\x00\x00\x00$@"),
}
local STATUSLEN = {
    ["5s"] = buffer.fromstring("\x02\x00\x00\x00\x00\x00\x00\x14@"),
    ["10s"] = buffer.fromstring("\x02\x00\x00\x00\x00\x00\x00$@"),
    ["15s"] = buffer.fromstring(""),
    ["20s"] = buffer.fromstring(""),
    ["30s"] = buffer.fromstring("\x02\x00\x00\x00\x00\x00\x00>@"),
    ["60s"] = buffer.fromstring("\x02\x00\x00\x00\x00\x00\x00N@"),
    ["90s"] = buffer.fromstring(""),
}

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

local timerstopped = false
function toggleTimer()
    execCommand({
        COMMANDS["ToggleTimer"]
    })
    timerstopped = not timerstopped
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

function begin1v1(killeruser, preptime)
    toggleTimer()
    task.wait(1)
    forceNextKiller(strToBuf(killeruser))
    task.wait(1)
    forceIntermissionEnd()
    toggleTimer()
    task.wait(preptime)
    giveStatus(TARGETALL, STATUSTYPE["Slowness"], STATUSLEVEL["10l"], STATUSLEN["5s"])
    giveStatus(TARGETALL, STATUSTYPE["Helpless"], STATUSLEVEL["10l"], STATUSLEN["5s"])
end

function endRound()
    toggleTimer()
    task.wait(1)
    forceRoundEnd()
    task.wait(1)
    toggleTimer()
end

------------------- ORION -------------------

local orion = loadstring(game:HttpGet(("https://raw.githubusercontent.com/jensonhirst/Orion/main/source")))()

local window = orion:MakeWindow({Name = "PS Helper TH Vladimir", HidePremium = true, SaveConfig = false, ConfigFolder = "OrionTest", IntroText = "EBANATI2"})

local maintab = window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

maintab:AddSlider({
	Name = "Preptime",
	Min = 5,
	Max = 45,
	Default = 10,
	Color = Color3.fromRGB(255,255,255),
	Increment = 5,
	ValueName = "Seconds",
    Flag = "preptime"
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

game.Players.PlayerAdded:Connect(refreshDropdowns)
game.Players.PlayerRemoving:Connect(refreshDropdowns)

maintab:AddButton({
	Name = "Begin 1v1",
	Callback = function()
        begin1v1(orion.Flags["killer"].Value, orion.Flags["preptime"].Value)
    end
})

maintab:AddButton({
    Name = "End Round",
    Callback = function()
        endRound()
    end
})

orion:Init()
