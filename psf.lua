local networker = game.ReplicatedStorage.Modules.Network.Network.RemoteEvent

function bufferFromBytes(bytes)
    local b = buffer.create(#bytes)
    for i = 1, #bytes do
        buffer.writeu8(b, i - 1, bytes[i])
    end
    return b
end

function execCommand(buffertable)
    networker:FireServer(
        "ExecuteCommand",
        buffertable
    )
end

local TARGETALL = bufferFromBytes({3, 3, 0, 0, 0, 65, 108, 108})
function userToBuf(user)
    local bytes = {3, 11, 0, 0, 0}
    for _, char in pairs(user) do
        table.insert(bytes, string.byte(char))
    end
    return bufferFromBytes(bytes)
end

local COMMANDS = {
    ["GiveStatus"] = bufferFromBytes({3, 10, 0, 0, 0, 71, 105, 118, 101, 83, 116, 97, 116, 117, 115}),
    ["KillPlayer"] = bufferFromBytes({3, 10, 0, 0, 0, 75, 105, 108, 108, 80, 108, 97, 121, 101, 114}),
    ["ToggleTimer"] = bufferFromBytes({3, 11, 0, 0, 0, 84, 111, 103, 103, 108, 101, 84, 105, 109, 101, 114}),
}
local STATUSTYPE = {
    ["Vulnerable"] = bufferFromBytes({3, 10, 0, 0, 0, 86, 117, 108, 110, 101, 114, 97, 98, 108, 101}),
    ["Resistance"] = bufferFromBytes({}),
    ["Speed"] = bufferFromBytes({}),
    ["Slowness"] = bufferFromBytes({}),
    ["Invisibility"] = bufferFromBytes({}),
}
local STATUSLEVEL = {
    ["1l"] = bufferFromBytes({2, 0, 0, 0, 0, 0, 0, 240, 63}),
    ["2l"] = bufferFromBytes({}),
    ["3l"] = bufferFromBytes({}),
    ["4l"] = bufferFromBytes({}),
    ["5l"] = bufferFromBytes({}),
    ["6l"] = bufferFromBytes({}),
    ["7l"] = bufferFromBytes({}),
    ["8l"] = bufferFromBytes({}),
    ["9l"] = bufferFromBytes({}),
    ["10l"] = bufferFromBytes({}),
}
local STATUSLEN = {
    ["5s"] = bufferFromBytes({2, 0, 0, 0, 0, 0, 0, 20, 64}),
    ["10s"] = bufferFromBytes({}),
    ["15s"] = bufferFromBytes({}),
    ["20s"] = bufferFromBytes({}),
    ["30s"] = bufferFromBytes({2, 0, 0, 0, 0, 0, 0, 62, 64}),
    ["60s"] = bufferFromBytes({2, 0, 0, 0, 0, 0, 0, 78, 64}),
    ["90s"] = bufferFromBytes({}),
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
