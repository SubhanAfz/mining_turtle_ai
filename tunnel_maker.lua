local args = { ... }

if not turtle then
    error("This program must run on a turtle.")
end

local tunnelWidth = tonumber(args[1])
local tunnelHeight = tonumber(args[2])
local targetDistance = tonumber(args[3])
local safetyBuffer = 16
local serviceWebhookUrl = ""

if args[4] ~= nil then
    safetyBuffer = tonumber(args[4])
end

if not tunnelWidth or not tunnelHeight or not targetDistance or not safetyBuffer then
    print("Usage: tunnel_maker <width> <height> <distance> [safety_buffer]")
    return
end

tunnelWidth = math.floor(tunnelWidth)
tunnelHeight = math.floor(tunnelHeight)
targetDistance = math.floor(targetDistance)
safetyBuffer = math.floor(safetyBuffer)

if tunnelWidth < 1 or tunnelHeight < 1 or targetDistance < 0 or safetyBuffer < 0 then
    print("Usage: tunnel_maker <width> <height> <distance> [safety_buffer]")
    return
end

local state = {
    x = 0,
    y = 0,
    z = 0,
    facing = 0,
    mode = "tunnel",
    lastAction = "starting",
    blocksMined = 0,
    coalVeinsMined = 0,
    wallBlocksPlaced = 0,
    serviceTrips = 0,
    stepsFromStart = 0,
    distanceCompleted = 0,
    sliceComplete = true,
    stopReason = nil,
}

local history = {}
local visitedCoal = {}

local facingNames = {
    [0] = "forward",
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
        "Tunnel Maker",
        string.format("Size: %dx%d", tunnelWidth, tunnelHeight),
        string.format("Dist: %d/%d", state.distanceCompleted, targetDistance),
        "Mode: " .. state.mode,
        string.format("Pos: %d,%d,%d", state.x, state.y, state.z),
        "Facing: " .. facingNames[state.facing],
        "Fuel: " .. fuelText,
        "Need: " .. tostring(reserveFuelNeeded()),
        string.format("Inv: %d/16", getFilledSlots()),
        string.format("Mined: %d", state.blocksMined),
        string.format("Coal: %d", state.coalVeinsMined),
        string.format("Walls: %d", state.wallBlocksPlaced),
        string.format("Trips: %d", state.serviceTrips),
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

local function isServiceReason(reason)
    return reason == "inventory full"
        or reason == "fuel reserve reached"
        or reason == "out of fuel"
end

local function slotIsFuel(slot)
    if turtle.getItemCount(slot) == 0 then
        return false
    end

    local selected = turtle.getSelectedSlot()
    turtle.select(slot)
    local ok = turtle.refuel(0)
    turtle.select(selected)
    return ok
end

local function tryRefuelFromInventory()
    local level = getFuelLevel()
    if isUnlimitedFuel(level) then
        return true
    end

    local selected = turtle.getSelectedSlot()
    local refueled = false

    for slot = 1, 16 do
        if turtle.getItemCount(slot) > 0 then
            turtle.select(slot)

            local ok = turtle.refuel(0)
            if ok then
                turtle.refuel()
                refueled = true
            end
        end
    end

    turtle.select(selected)

    if refueled then
        setAction("refuel inventory")
    end

    return refueled
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

local function requiredFuelAtBase()
    local level = getFuelLevel()
    if isUnlimitedFuel(level) then
        return 0
    end

    local extraWork = tunnelWidth + tunnelHeight + safetyBuffer + 4
    return (state.distanceCompleted * 2) + extraWork
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

local undoToSize

local function moveRight(record, checkReserve)
    local checkpoint = #history

    local ok, err = turnRight(record)
    if not ok then
        return false, err
    end

    ok, err = moveForward(record, checkReserve)
    if not ok then
        undoToSize(checkpoint, state.mode)
        return false, err
    end

    ok, err = turnLeft(record)
    if not ok then
        return false, err
    end

    return true
end

local function moveLeft(record, checkReserve)
    local checkpoint = #history

    local ok, err = turnLeft(record)
    if not ok then
        return false, err
    end

    ok, err = moveForward(record, checkReserve)
    if not ok then
        undoToSize(checkpoint, state.mode)
        return false, err
    end

    ok, err = turnRight(record)
    if not ok then
        return false, err
    end

    return true
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

undoToSize = function(targetSize, mode)
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

local function detectRelative(direction)
    if direction == "front" then
        return turtle.detect()
    elseif direction == "up" then
        return turtle.detectUp()
    elseif direction == "down" then
        return turtle.detectDown()
    elseif direction == "left" then
        local ok = turnLeft(false)
        if not ok then
            return true
        end

        local detected = turtle.detect()
        turnRight(false)
        return detected
    elseif direction == "right" then
        local ok = turnRight(false)
        if not ok then
            return true
        end

        local detected = turtle.detect()
        turnLeft(false)
        return detected
    else
        local ok = turnAround(false)
        if not ok then
            return true
        end

        local detected = turtle.detect()
        turnAround(false)
        return detected
    end
end

local function isCoalBlock(block)
    if not block or not block.name then
        return false
    end

    if block.name:match("coal_ore$") then
        return true
    end

    if block.tags then
        for tag in pairs(block.tags) do
            if tag:match("coal_ores$") or tag:match("/coal$") or tag:match(":ores/coal$") then
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

local function dfsMineCoal()
    visitedCoal[currentPositionKey()] = true

    for _, direction in ipairs(scanDirections) do
        if not hasInventorySpace() then
            return false, "inventory full"
        end

        local hasBlock, data = inspectRelative(direction)
        if hasBlock and isCoalBlock(data) then
            local x, y, z = adjacentPosition(direction)
            local key = positionKey(x, y, z)

            if not visitedCoal[key] then
                visitedCoal[key] = true

                local checkpoint = #history
                setAction("mine coal " .. direction, "coal")

                local ok, err = enterDirection(direction)
                if not ok then
                    return false, err
                end

                ok, err = dfsMineCoal()
                if not ok then
                    return false, err
                end

                ok, err = undoToSize(checkpoint, "coal")
                if not ok then
                    return false, err
                end
            end
        end
    end

    return true
end

local function mineAdjacentCoal()
    for _, direction in ipairs(scanDirections) do
        if not hasInventorySpace() then
            return false, "inventory full"
        end

        local hasBlock, data = inspectRelative(direction)
        if hasBlock and isCoalBlock(data) then
            local x, y, z = adjacentPosition(direction)
            local key = positionKey(x, y, z)

            if not visitedCoal[key] then
                visitedCoal[key] = true
                state.coalVeinsMined = state.coalVeinsMined + 1

                local checkpoint = #history
                setAction("found coal " .. direction, "coal")

                local ok, err = enterDirection(direction)
                if not ok then
                    return false, err
                end

                ok, err = dfsMineCoal()
                if not ok then
                    return false, err
                end

                ok, err = undoToSize(checkpoint, "tunnel")
                if not ok then
                    return false, err
                end

                tryRefuelFromInventory()
                setAction("resume tunnel", "tunnel")
            end
        end
    end

    return true
end

local function rawPlaceRelative(direction)
    if direction == "front" then
        return turtle.place()
    elseif direction == "up" then
        return turtle.placeUp()
    elseif direction == "down" then
        return turtle.placeDown()
    elseif direction == "left" then
        local ok, err = turnLeft(false)
        if not ok then
            return false, err
        end

        local placed, placeErr = turtle.place()
        turnRight(false)
        return placed, placeErr
    elseif direction == "right" then
        local ok, err = turnRight(false)
        if not ok then
            return false, err
        end

        local placed, placeErr = turtle.place()
        turnLeft(false)
        return placed, placeErr
    else
        local ok, err = turnAround(false)
        if not ok then
            return false, err
        end

        local placed, placeErr = turtle.place()
        turnAround(false)
        return placed, placeErr
    end
end

local function placeWallBlock(direction)
    local selected = turtle.getSelectedSlot()

    for slot = 1, 16 do
        if turtle.getItemCount(slot) > 0 and not slotIsFuel(slot) then
            turtle.select(slot)

            local ok, err = rawPlaceRelative(direction)
            if ok then
                turtle.select(selected)
                return true
            end
        end
    end

    turtle.select(selected)
    return false, "no wall blocks"
end

local function ensureWall(direction)
    if detectRelative(direction) then
        return true
    end

    local ok, err = placeWallBlock(direction)
    if not ok then
        return false, err
    end

    state.wallBlocksPlaced = state.wallBlocksPlaced + 1
    setAction("place wall " .. direction, "tunnel")
    return true
end

local function fillPerimeterAtOffset(offsetX, offsetY)
    if offsetY == 0 then
        local ok, err = ensureWall("down")
        if not ok then
            return false, err
        end
    end

    if offsetY == tunnelHeight - 1 then
        local ok, err = ensureWall("up")
        if not ok then
            return false, err
        end
    end

    if offsetX == 0 then
        local ok, err = ensureWall("left")
        if not ok then
            return false, err
        end
    end

    if offsetX == tunnelWidth - 1 then
        local ok, err = ensureWall("right")
        if not ok then
            return false, err
        end
    end

    return true
end

local function mineCurrentSlice()
    local anchorCheckpoint = #history
    local offsetX = 0
    local offsetY = 0

    local function goToOffset(targetX, targetY)
        local ok, err

        while offsetY < targetY do
            ok, err = moveUp(true, true)
            if not ok then
                return false, err
            end

            offsetY = offsetY + 1
        end

        while offsetY > targetY do
            ok, err = moveDown(true, true)
            if not ok then
                return false, err
            end

            offsetY = offsetY - 1
        end

        while offsetX < targetX do
            ok, err = moveRight(true, true)
            if not ok then
                return false, err
            end

            offsetX = offsetX + 1
        end

        while offsetX > targetX do
            ok, err = moveLeft(true, true)
            if not ok then
                return false, err
            end

            offsetX = offsetX - 1
        end

        return true
    end

    local function workCell()
        local ok, err = mineAdjacentCoal()
        if not ok then
            return false, err
        end

        return fillPerimeterAtOffset(offsetX, offsetY)
    end

    for y = 0, tunnelHeight - 1 do
        local startX = 0
        local endX = tunnelWidth - 1
        local step = 1

        if y % 2 == 1 then
            startX = tunnelWidth - 1
            endX = 0
            step = -1
        end

        local x = startX
        while true do
            local ok, err = goToOffset(x, y)
            if not ok then
                undoToSize(anchorCheckpoint, "tunnel")
                return false, err
            end

            ok, err = workCell()
            if not ok then
                undoToSize(anchorCheckpoint, "tunnel")
                return false, err
            end

            if x == endX then
                break
            end

            x = x + step
        end
    end

    local ok, err = goToOffset(0, 0)
    if not ok then
        undoToSize(anchorCheckpoint, "tunnel")
        return false, err
    end

    setAction("slice complete", "tunnel")
    return true
end

local function chooseReservedWallSlots(limit)
    local ranked = {}

    for slot = 1, 16 do
        if turtle.getItemCount(slot) > 0 and not slotIsFuel(slot) then
            local detail = turtle.getItemDetail(slot)
            ranked[#ranked + 1] = {
                slot = slot,
                count = detail and detail.count or turtle.getItemCount(slot),
            }
        end
    end

    table.sort(ranked, function(a, b)
        return a.count > b.count
    end)

    local reserved = {}

    for index = 1, math.min(limit, #ranked) do
        reserved[ranked[index].slot] = true
    end

    return reserved
end

local function dropItemsToBase(keepWallSlots)
    local selected = turtle.getSelectedSlot()
    local reserved = chooseReservedWallSlots(keepWallSlots or 0)

    for slot = 1, 16 do
        if turtle.getItemCount(slot) > 0 and not slotIsFuel(slot) and not reserved[slot] then
            turtle.select(slot)

            local ok, err = turtle.dropDown()
            if not ok then
                turtle.select(selected)
                return false, err or "base inventory unavailable"
            end
        end
    end

    turtle.select(selected)
    return true
end

local function pullFuelFromBase(maxPulls)
    local selected = turtle.getSelectedSlot()
    local pulls = 0

    while pulls < maxPulls and hasInventorySpace() do
        local targetSlot = nil

        for slot = 1, 16 do
            if turtle.getItemSpace(slot) > 0 then
                targetSlot = slot
                break
            end
        end

        if not targetSlot then
            break
        end

        turtle.select(targetSlot)
        local ok = turtle.suckDown()
        if not ok then
            break
        end

        pulls = pulls + 1
        setAction("pull from base", "servicing")
        tryRefuelFromInventory()
    end

    turtle.select(selected)
    return pulls > 0
end

local function sendServiceWebhook()
    if serviceWebhookUrl == "" then
        return false, "webhook not configured"
    end

    if not http or not http.post or not textutils or not textutils.serializeJSON then
        return false, "http unavailable"
    end

    local body = textutils.serializeJSON({ content = "need servicing" })
    local response, err = http.post(serviceWebhookUrl, body, {
        ["Content-Type"] = "application/json",
    })

    if response then
        response.close()
        return true
    end

    return false, err or "webhook failed"
end

local function retraceToOrigin(mode)
    setAction("returning home", mode or "returning")

    local ok, err = undoToSize(0, mode or "returning")
    if not ok then
        return false, err
    end

    while state.facing ~= 0 do
        ok, err = turnLeft(false)
        if not ok then
            return false, err
        end
    end

    setAction("at origin", mode or "servicing")
    return true
end

local function serviceBase(countTrip)
    if countTrip then
        state.serviceTrips = state.serviceTrips + 1
    end

    setAction("service base", "servicing")

    local ok, err = dropItemsToBase(2)
    if not ok then
        return false, "base unload failed: " .. err
    end

    tryRefuelFromInventory()
    local level = getFuelLevel()
    if not isUnlimitedFuel(level) and level < requiredFuelAtBase() then
        pullFuelFromBase(16)
        tryRefuelFromInventory()

        ok, err = dropItemsToBase(2)
        if not ok then
            return false, "base unload failed: " .. err
        end

        level = getFuelLevel()
        if level < requiredFuelAtBase() then
            pullFuelFromBase(16)
            tryRefuelFromInventory()

            ok, err = dropItemsToBase(2)
            if not ok then
                return false, "base unload failed: " .. err
            end

            level = getFuelLevel()
        end

        if level < requiredFuelAtBase() then
            return false, "not enough fuel from base"
        end
    end

    return true
end

local function unloadFinalInventory()
    setAction("final unload", "servicing")
    return dropItemsToBase(0)
end

local function returnToProgress()
    setAction("resume progress", "returning")

    for _ = 1, state.distanceCompleted do
        local ok, err = moveForward(true, true)
        if not ok then
            return false, err
        end
    end

    setAction("back at tunnel", "tunnel")
    return true
end

local function serviceAndResume()
    local ok, err = retraceToOrigin("returning")
    if not ok then
        return false, err
    end

    sendServiceWebhook()

    ok, err = serviceBase(true)
    if not ok then
        return false, err
    end

    if state.distanceCompleted > 0 then
        ok, err = returnToProgress()
        if not ok then
            return false, err
        end
    end

    return true
end

local function handleServiceReason(reason)
    if not isServiceReason(reason) then
        return false, reason
    end

    local ok, err = serviceAndResume()
    if not ok then
        return false, err
    end

    return true
end

local function runTunnel()
    local ok, err = serviceBase(false)
    if not ok then
        return false, err
    end

    while true do
        if state.sliceComplete and state.distanceCompleted >= targetDistance then
            return true, "finished"
        end

        if state.sliceComplete then
            ok, err = mineAdjacentCoal()
            if not ok then
                ok, err = handleServiceReason(err)
                if not ok then
                    return false, err
                end
            end

            if not hasInventorySpace() then
                ok, err = handleServiceReason("inventory full")
                if not ok then
                    return false, err
                end
            elseif not canSpendFuelMove() then
                ok, err = handleServiceReason("fuel reserve reached")
                if not ok then
                    return false, err
                end
            else
                setAction("advance tunnel", "tunnel")
                ok, err = moveForward(true, true)
                if not ok then
                    ok, err = handleServiceReason(err)
                    if not ok then
                        return false, err
                    end
                else
                    state.distanceCompleted = state.distanceCompleted + 1
                    state.sliceComplete = false
                end
            end
        else
            if not hasInventorySpace() then
                ok, err = handleServiceReason("inventory full")
                if not ok then
                    return false, err
                end
            elseif not canSpendFuelMove() then
                ok, err = handleServiceReason("fuel reserve reached")
                if not ok then
                    return false, err
                end
            else
                setAction("mine slice " .. tostring(state.distanceCompleted), "tunnel")
                ok, err = mineCurrentSlice()
                if not ok then
                    ok, err = handleServiceReason(err)
                    if not ok then
                        return false, err
                    end
                else
                    state.sliceComplete = true
                end
            end
        end
    end
end

local function main()
    drawStatus()

    local ok, reason = runTunnel()

    local returnOk, returnErr = retraceToOrigin("returning")
    if not returnOk then
        markStop("return failed: " .. tostring(returnErr))
        return false
    end

    local unloadOk, unloadErr = unloadFinalInventory()
    if not unloadOk then
        markStop("base unload failed: " .. tostring(unloadErr))
        return false
    end

    if ok then
        markStop(reason or "finished")
        return true
    end

    markStop(reason or "stopped")
    return false
end

local ok, err = pcall(main)

if not ok then
    markStop("error: " .. tostring(err))

    local returned = pcall(function()
        retraceToOrigin("returning")
        unloadFinalInventory()
    end)

    if not returned then
        drawStatus()
    end

    if printError then
        printError(err)
    else
        print(err)
    end
end
