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
    return buffer.fromstring("\x03\x0b\x00\x00\x00"..user)
end

local COMMANDS = {
    ["GiveStatus"] = buffer.fromstring("\x03\x0a\x00\x00\x00GiveStatus"),--bufferFromBytes({3, 10, 0, 0, 0, 71, 105, 118, 101, 83, 116, 97, 116, 117, 115}),
    ["KillPlayer"] = buffer.fromstring("\x03\x0a\x00\x00\x00KillPlayer"),--bufferFromBytes({3, 10, 0, 0, 0, 75, 105, 108, 108, 80, 108, 97, 121, 101, 114}),
    ["ToggleTimer"] = buffer.fromstring("\x03\x0b\x00\x00\x00ToggleTimer"),--bufferFromBytes({3, 11, 0, 0, 0, 84, 111, 103, 103, 108, 101, 84, 105, 109, 101, 114}),
}
local STATUSTYPE = {
    ["Vulnerable"] = buffer.fromstring("\x03\x0a\x00\x00\x00Vulnerable"),--bufferFromBytes({3, 10, 0, 0, 0, 86, 117, 108, 110, 101, 114, 97, 98, 108, 101}),
    ["Resistance"] = buffer.fromstring(""),--bufferFromBytes({}),
    ["Speed"] = buffer.fromstring(""),--bufferFromBytes({}),
    ["Slowness"] = buffer.fromstring(""),--bufferFromBytes({}),
    ["Invisibility"] = buffer.fromstring(""),--bufferFromBytes({}),
}
local STATUSLEVEL = {
    ["1l"] = buffer.fromstring("\x02\x00\x00\x00\x00\x00\x00\xF0?"),--bufferFromBytes({2, 0, 0, 0, 0, 0, 0, 240, 63}),
    ["2l"] = buffer.fromstring(""),--bufferFromBytes({}),
    ["3l"] = buffer.fromstring(""),--bufferFromBytes({}),
    ["4l"] = buffer.fromstring(""),--bufferFromBytes({}),
    ["5l"] = buffer.fromstring(""),--bufferFromBytes({}),
    ["6l"] = buffer.fromstring(""),--bufferFromBytes({}),
    ["7l"] = buffer.fromstring(""),--bufferFromBytes({}),
    ["8l"] = buffer.fromstring(""),--bufferFromBytes({}),
    ["9l"] = buffer.fromstring(""),--bufferFromBytes({}),
    ["10l"] = buffer.fromstring(""),--bufferFromBytes({}),
}
local STATUSLEN = {
    ["5s"] = buffer.fromstring("\x02\x00\x00\x00\x00\x00\x00\x14@"),--bufferFromBytes({2, 0, 0, 0, 0, 0, 0, 20, 64}),
    ["10s"] = buffer.fromstring(""),--bufferFromBytes({}),
    ["15s"] = buffer.fromstring(""),--bufferFromBytes({}),
    ["20s"] = buffer.fromstring(""),--bufferFromBytes({}),
    ["30s"] = buffer.fromstring("\x02\x00\x00\x00\x00\x00\x00>@"),--bufferFromBytes({2, 0, 0, 0, 0, 0, 0, 62, 64}),
    ["60s"] = buffer.fromstring("\x02\x00\x00\x00\x00\x00\x00N@"),--bufferFromBytes({2, 0, 0, 0, 0, 0, 0, 78, 64}),
    ["90s"] = buffer.fromstring(""),--bufferFromBytes({}),
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

giveStatus(TARGETALL, STATUSTYPE["Vulnerable"], STATUSLEVEL["1l"], STATUSLEN["30s"])
