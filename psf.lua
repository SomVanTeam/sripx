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

local TARGETALL = buffer.fromstring("\x03\x03\x00\x00\x00All")--bufferFromBytes({3, 3, 0, 0, 0, 65, 108, 108})
function userToBuf(user)
    -- local bytes = {3, 11, 0, 0, 0}
    -- for _, char in pairs(user) do
    --     table.insert(bytes, string.byte(char))
    -- end
    -- return bufferFromBytes(bytes)
    return buffer.fromstring("\x03\x0B\x00\x00\x00"..user)
end

local COMMANDS = {
    ["GiveStatus"] = buffer.fromstring("\x03\x0A\x00\x00\x00GiveStatus"),
    ["KillPlayer"] = buffer.fromstring("\x03\x0A\x00\x00\x00KillPlayer"),
    ["ToggleTimer"] = buffer.fromstring("\x03\x0B\x00\x00\x00ToggleTimer"),
    ["ForceNextKiller"] = buffer.fromstring("\x03\x0F\x00\x00\x00ForceNextKiller"),
    ["ForceRoundEnd"] = buffer.fromstring("\x03\r\x00\x00\x00ForceRoundEnd"),
    ["ForceIntermissionEnd"] = buffer.fromstring("\x03\x14\x00\x00\x00ForceIntermissionEnd"),
}
local STATUSTYPE = {
    ["Vulnerable"] = buffer.fromstring("\x03\x0A\x00\x00\x00Vulnerable"),
    ["Resistance"] = buffer.fromstring(""),
    ["Speed"] = buffer.fromstring(""),
    ["Slowness"] = buffer.fromstring(""),
    ["Invisibility"] = buffer.fromstring(""),
    ["Stunned"] = buffer.fromstring("\x03\a\x00\x00\x00Stunned"),
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
    ["10l"] = buffer.fromstring(""),
}
local STATUSLEN = {
    ["5s"] = buffer.fromstring("\x02\x00\x00\x00\x00\x00\x00\x14@"),
    ["10s"] = buffer.fromstring(""),
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
        COMMANDS["ForceNextKiler"],
        targetbuf
    })
end

forceNextKiller(userToBuf("th_vladaimir"))
forceIntermissionEnd()
toggleTimer()
task.wait(5)
giveStatus(TARGETALL, STATUSTYPE["Stunned"], STATUSLEVEL["1l"], STATUSLEN["5s"])
