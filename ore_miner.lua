local args = { ... }

if not turtle then
    error("This program must run on a turtle.")
end

local safetyBuffer = 16

if args[1] ~= nil then
    local parsed = tonumber(args[1])
    if not parsed or parsed < 0 then
        print("Usage: ore_miner [safety_buffer]")
        return
    end

    safetyBuffer = math.floor(parsed)
end

local state = {
    x = 0,
    y = 0,
    z = 0,
    facing = 0,
    mode = "tunnel",
    lastAction = "starting",
    blocksMined = 0,
    veinsMined = 0,
    stepsFromStart = 0,
    stopReason = nil,
}

local history = {}
local visitedOre = {}

local facingNames = {
    [0] = "start",
    [1] = "right",
    [2] = "back",
    [3] = "left",
}

local scanDirections = { "front", "left", "right", "up", "down", "back" }

local function pushHistory(action)
    history[#history + 1] = action
end

local function popHistory()
    local action = history[#history]
    history[#history] = nil
    return action
end

local function getFuelLevel()
    return turtle.getFuelLevel()
end

local function isUnlimitedFuel(level)
    return level == "unlimited"
end

local function fuelNeededToGetHome()
    return state.stepsFromStart
end

local function reserveFuelNeeded()
    return fuelNeededToGetHome() + safetyBuffer
end

local function getFilledSlots()
    local filled = 0

    for slot = 1, 16 do
        if turtle.getItemCount(slot) > 0 then
            filled = filled + 1
        end
    end

    return filled
end

local function hasInventorySpace()
    for slot = 1, 16 do
        if turtle.getItemSpace(slot) > 0 then
            return true
        end
    end

    return false
end

local function clampLine(text, width)
    if #text <= width then
        return text
    end

    if width <= 3 then
        return text:sub(1, width)
    end

    return text:sub(1, width - 3) .. "..."
end

local function drawStatus()
    local width, height = term.getSize()
    local fuel = getFuelLevel()
    local fuelText = isUnlimitedFuel(fuel) and "unlimited" or tostring(fuel)

    local lines = {
        "Ore Miner",
        "Mode: " .. state.mode,
        string.format("Pos: %d,%d,%d", state.x, state.y, state.z),
        "Facing: " .. facingNames[state.facing],
        "Fuel: " .. fuelText,
        "Need: " .. tostring(reserveFuelNeeded()),
        string.format("Inv: %d/16", getFilledSlots()),
        string.format("Blocks: %d", state.blocksMined),
        string.format("Veins: %d", state.veinsMined),
        "Action: " .. state.lastAction,
    }

    term.clear()

    for line = 1, height do
        term.setCursorPos(1, line)
        term.clearLine()

        if lines[line] then
            term.write(clampLine(lines[line], width))
        end
    end

    term.setCursorPos(1, math.min(#lines + 1, height))
end

local function setAction(text, mode)
    if mode then
        state.mode = mode
    end

    state.lastAction = text
    drawStatus()
end

local function positionKey(x, y, z)
    return tostring(x) .. "," .. tostring(y) .. "," .. tostring(z)
end

local function currentPositionKey()
    return positionKey(state.x, state.y, state.z)
end

local function deltaForFacing(facing)
    if facing == 0 then
        return 0, 0, 1
    elseif facing == 1 then
        return 1, 0, 0
    elseif facing == 2 then
        return 0, 0, -1
    else
        return -1, 0, 0
    end
end

local function adjacentPosition(direction)
    local dx, dy, dz

    if direction == "front" then
        dx, dy, dz = deltaForFacing(state.facing)
    elseif direction == "back" then
        dx, dy, dz = deltaForFacing((state.facing + 2) % 4)
    elseif direction == "left" then
        dx, dy, dz = deltaForFacing((state.facing + 3) % 4)
    elseif direction == "right" then
        dx, dy, dz = deltaForFacing((state.facing + 1) % 4)
    elseif direction == "up" then
        dx, dy, dz = 0, 1, 0
    else
        dx, dy, dz = 0, -1, 0
    end

    return state.x + dx, state.y + dy, state.z + dz
end

local function tryRefuelFromInventory()
    local level = getFuelLevel()
    if isUnlimitedFuel(level) then
        return true
    end

    local selected = turtle.getSelectedSlot()

    for slot = 1, 16 do
        if turtle.getItemCount(slot) > 0 then
            turtle.select(slot)

            local ok = turtle.refuel(0)
            if ok then
                turtle.refuel()
                turtle.select(selected)
                setAction("refuel slot " .. tostring(slot))
                return true
            end
        end
    end

    turtle.select(selected)
    return false
end

local function canSpendFuelMove()
    local level = getFuelLevel()
    if isUnlimitedFuel(level) then
        return true
    end

    if level >= reserveFuelNeeded() + 2 then
        return true
    end

    tryRefuelFromInventory()

    level = getFuelLevel()
    return isUnlimitedFuel(level) or level >= reserveFuelNeeded() + 2
end

local function canReturnHomeNow()
    local level = getFuelLevel()
    if isUnlimitedFuel(level) then
        return true
    end

    if level >= fuelNeededToGetHome() then
        return true
    end

    tryRefuelFromInventory()

    level = getFuelLevel()
    return isUnlimitedFuel(level) or level >= fuelNeededToGetHome()
end

local function markStop(reason)
    state.stopReason = reason
    setAction(reason, "stopped")
end

local function recordForwardStep()
    local dx, _, dz = deltaForFacing(state.facing)
    state.x = state.x + dx
    state.z = state.z + dz
    state.stepsFromStart = state.stepsFromStart + 1
end

local function turnLeft(record)
    local ok, err = turtle.turnLeft()
    if not ok then
        return false, err or "could not turn left"
    end

    state.facing = (state.facing + 3) % 4

    if record ~= false then
        pushHistory("turnLeft")
    end

    return true
end

local function turnRight(record)
    local ok, err = turtle.turnRight()
    if not ok then
        return false, err or "could not turn right"
    end

    state.facing = (state.facing + 1) % 4

    if record ~= false then
        pushHistory("turnRight")
    end

    return true
end

local function turnAround(record)
    local ok, err = turnLeft(record)
    if not ok then
        return false, err
    end

    return turnLeft(record)
end

local function tryClearForward()
    if turtle.detect() then
        local dug, err = turtle.dig()
        if dug then
            state.blocksMined = state.blocksMined + 1
            setAction("dig front")
            return true, true
        end

        return false, err or "front blocked"
    end

    turtle.attack()
    sleep(0.2)
    return true, false
end

local function tryClearUp()
    if turtle.detectUp() then
        local dug, err = turtle.digUp()
        if dug then
            state.blocksMined = state.blocksMined + 1
            setAction("dig up")
            return true, true
        end

        return false, err or "up blocked"
    end

    turtle.attackUp()
    sleep(0.2)
    return true, false
end

local function tryClearDown()
    if turtle.detectDown() then
        local dug, err = turtle.digDown()
        if dug then
            state.blocksMined = state.blocksMined + 1
            setAction("dig down")
            return true, true
        end

        return false, err or "down blocked"
    end

    turtle.attackDown()
    sleep(0.2)
    return true, false
end

local function moveForward(record, checkReserve)
    if checkReserve ~= false and not canSpendFuelMove() then
        return false, "fuel reserve reached"
    end

    for _ = 1, 20 do
        local moved, err = turtle.forward()
        if moved then
            recordForwardStep()

            if record ~= false then
                pushHistory("forward")
            end

            setAction("move forward")
            return true
        end

        if err == "Out of fuel" then
            if not tryRefuelFromInventory() then
                return false, "out of fuel"
            end
        else
            local cleared, clearErr = tryClearForward()
            if not cleared then
                return false, clearErr
            end
        end
    end

    return false, "could not move forward"
end

local function moveUp(record, checkReserve)
    if checkReserve ~= false and not canSpendFuelMove() then
        return false, "fuel reserve reached"
    end

    for _ = 1, 20 do
        local moved, err = turtle.up()
        if moved then
            state.y = state.y + 1
            state.stepsFromStart = state.stepsFromStart + 1

            if record ~= false then
                pushHistory("up")
            end

            setAction("move up")
            return true
        end

        if err == "Out of fuel" then
            if not tryRefuelFromInventory() then
                return false, "out of fuel"
            end
        else
            local cleared, clearErr = tryClearUp()
            if not cleared then
                return false, clearErr
            end
        end
    end

    return false, "could not move up"
end

local function moveDown(record, checkReserve)
    if checkReserve ~= false and not canSpendFuelMove() then
        return false, "fuel reserve reached"
    end

    for _ = 1, 20 do
        local moved, err = turtle.down()
        if moved then
            state.y = state.y - 1
            state.stepsFromStart = state.stepsFromStart + 1

            if record ~= false then
                pushHistory("down")
            end

            setAction("move down")
            return true
        end

        if err == "Out of fuel" then
            if not tryRefuelFromInventory() then
                return false, "out of fuel"
            end
        else
            local cleared, clearErr = tryClearDown()
            if not cleared then
                return false, clearErr
            end
        end
    end

    return false, "could not move down"
end

local function undoAction(action)
    if action == "turnLeft" then
        return turnRight(false)
    elseif action == "turnRight" then
        return turnLeft(false)
    elseif action == "forward" then
        local ok, err = turnAround(false)
        if not ok then
            return false, err
        end

        ok, err = moveForward(false, false)
        if not ok then
            return false, err
        end

        state.stepsFromStart = state.stepsFromStart - 2

        return turnAround(false)
    elseif action == "up" then
        local ok, err = moveDown(false, false)
        if not ok then
            return false, err
        end

        state.stepsFromStart = state.stepsFromStart - 2
        return true
    elseif action == "down" then
        local ok, err = moveUp(false, false)
        if not ok then
            return false, err
        end

        state.stepsFromStart = state.stepsFromStart - 2
        return true
    end

    return false, "unknown history action: " .. tostring(action)
end

local function undoToSize(targetSize, mode)
    while #history > targetSize do
        if not canReturnHomeNow() then
            return false, "not enough fuel to retrace path"
        end

        local action = history[#history]
        setAction("return step", mode or "returning")

        local ok, err = undoAction(action)
        if not ok then
            return false, err
        end

        popHistory()
    end

    return true
end

local function inspectFront()
    return turtle.inspect()
end

local function inspectUp()
    return turtle.inspectUp()
end

local function inspectDown()
    return turtle.inspectDown()
end

local function inspectRelative(direction)
    if direction == "front" then
        return inspectFront()
    elseif direction == "up" then
        return inspectUp()
    elseif direction == "down" then
        return inspectDown()
    elseif direction == "left" then
        local ok, err = turnLeft(false)
        if not ok then
            return false, err
        end

        local hasBlock, data = inspectFront()
        turnRight(false)
        return hasBlock, data
    elseif direction == "right" then
        local ok, err = turnRight(false)
        if not ok then
            return false, err
        end

        local hasBlock, data = inspectFront()
        turnLeft(false)
        return hasBlock, data
    else
        local ok, err = turnAround(false)
        if not ok then
            return false, err
        end

        local hasBlock, data = inspectFront()
        turnAround(false)
        return hasBlock, data
    end
end

local function isOreBlock(block)
    if not block or not block.name then
        return false
    end

    if block.name == "minecraft:ancient_debris" then
        return true
    end

    if block.name:match("_ore$") then
        return true
    end

    if block.tags then
        for tag in pairs(block.tags) do
            if tag:match("_ores$") or tag:match(":ores$") then
                return true
            end
        end
    end

    return false
end

local function enterDirection(direction)
    local checkpoint = #history
    local ok, err

    if direction == "front" then
        ok, err = moveForward(true, true)
    elseif direction == "left" then
        ok, err = turnLeft(true)
        if ok then
            ok, err = moveForward(true, true)
        end
    elseif direction == "right" then
        ok, err = turnRight(true)
        if ok then
            ok, err = moveForward(true, true)
        end
    elseif direction == "back" then
        ok, err = turnAround(true)
        if ok then
            ok, err = moveForward(true, true)
        end
    elseif direction == "up" then
        ok, err = moveUp(true, true)
    else
        ok, err = moveDown(true, true)
    end

    if ok then
        return true
    end

    undoToSize(checkpoint, state.mode)
    return false, err
end

local function dfsMineOre()
    visitedOre[currentPositionKey()] = true

    for _, direction in ipairs(scanDirections) do
        if not hasInventorySpace() then
            return false, "inventory full"
        end

        local hasBlock, data = inspectRelative(direction)
        if hasBlock and isOreBlock(data) then
            local x, y, z = adjacentPosition(direction)
            local key = positionKey(x, y, z)

            if not visitedOre[key] then
                visitedOre[key] = true

                local checkpoint = #history
                setAction("mine ore " .. direction, "vein")

                local ok, err = enterDirection(direction)
                if not ok then
                    return false, err
                end

                ok, err = dfsMineOre()
                if not ok then
                    return false, err
                end

                ok, err = undoToSize(checkpoint, "vein")
                if not ok then
                    return false, err
                end
            end
        end
    end

    return true
end

local function mineAdjacentVeins()
    for _, direction in ipairs(scanDirections) do
        if not hasInventorySpace() then
            return false, "inventory full"
        end

        local hasBlock, data = inspectRelative(direction)
        if hasBlock and isOreBlock(data) then
            local x, y, z = adjacentPosition(direction)
            local key = positionKey(x, y, z)

            if not visitedOre[key] then
                visitedOre[key] = true
                state.veinsMined = state.veinsMined + 1

                local checkpoint = #history
                setAction("found ore " .. direction, "vein")

                local ok, err = enterDirection(direction)
                if not ok then
                    return false, err
                end

                ok, err = dfsMineOre()
                if not ok then
                    return false, err
                end

                ok, err = undoToSize(checkpoint, "tunnel")
                if not ok then
                    return false, err
                end

                state.mode = "tunnel"
                setAction("resume tunnel", "tunnel")
            end
        end
    end

    return true
end

local function returnHome()
    setAction("returning home", "returning")

    local ok, err = undoToSize(0, "returning")
    if not ok then
        markStop("return failed: " .. err)
        return false
    end

    while state.facing ~= 0 do
        ok, err = turnLeft(false)
        if not ok then
            markStop("turn failed: " .. err)
            return false
        end
    end

    state.mode = "stopped"
    state.lastAction = state.stopReason or "home"
    drawStatus()
    return true
end

local function mineTunnel()
    local ok, err = mineAdjacentVeins()
    if not ok then
        return false, err
    end

    while true do
        if not hasInventorySpace() then
            return false, "inventory full"
        end

        if not canSpendFuelMove() then
            return false, "fuel reserve reached"
        end

        setAction("tunnel forward", "tunnel")
        ok, err = moveForward(true, true)
        if not ok then
            return false, err
        end

        ok, err = mineAdjacentVeins()
        if not ok then
            return false, err
        end
    end
end

local function main()
    drawStatus()

    local ok, err = mineTunnel()
    if not ok then
        markStop(err)
    else
        markStop("finished")
    end

    returnHome()
end

local ok, err = pcall(main)

if not ok then
    markStop("error: " .. tostring(err))
    returnHome()

    if printError then
        printError(err)
    else
        print(err)
    end
end
