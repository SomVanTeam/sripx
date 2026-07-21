--[[
loadstring(game:HttpGet(("https://raw.githubusercontent.com/SomVanTeam/sripx/refs/heads/main/psf.lua")))()
]]
local networker = game.ReplicatedStorage.Modules.Network.Network.RemoteEvent

-- function bufferFromBytes(bytes)
--     local b = buffer.create(#bytes)
--     for i = 1, #bytes do
--         buffer.writeu8(b, i - 1, bytes[i])
--     end
--     return b
-- end

function execCommand(buffertable)
    networker:FireServer(
        "ExecuteCommand",
        buffertable
    )
end

-- 15 -> \x0F
function decToHex(n)
    return string.format("\\0x%X", n)
end

local TARGETALL = buffer.fromstring("\x03\x03\x00\x00\x00All")
function userToBuf(user)
    local b = buffer.fromstring("\x03\x00\x00\x00\x00"..user)
    buffer.writeu8(b, 1, string.len(user))
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
    ["Slowness"] = buffer.fromstring(""),
    ["Invisibility"] = buffer.fromstring(""),
    ["Slowness"] = buffer.fromstring("\x03\b\x00\x00\x00Slowness"),
    ["Helpless"] = buffer.fromstring("\x03\b\x00\x00\x00Helpless"),
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

function sendAnnouncement(msg)
    execCommand({
        COMMANDS["SendAnnouncement"],
        buffer.fromstring("\x03\x02\x00\x00"..msg)
    })
end

function begin1v1(killeruser)
    toggleTimer()
    task.wait(1)
    forceNextKiller(userToBuf(killeruser))
    task.wait(1)
    forceIntermissionEnd()
    toggleTimer()
    task.wait(1)
    sendAnnouncement("STARTING IN 10 SECONDS")
    task.wait(10)
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

begin1v1("th_vladaimir")
task.wait(6)
endRound()
