# redstone

Get and set redstone signals adjacent to this computer.

The [`redstone`](redstone.md) library exposes three "types" of redstone control:

- Binary input/output ([`setOutput`](redstone.md#v:setOutput)/[`getInput`](redstone.md#v:getInput)): These simply check if a redstone wire has any input or
output. A signal strength of 1 and 15 are treated the same.
- Analogue input/output ([`setAnalogOutput`](redstone.md#v:setAnalogOutput)/[`getAnalogInput`](redstone.md#v:getAnalogInput)): These work with the actual signal
strength of the redstone wired, from 0 to 15.
- Bundled cables ([`setBundledOutput`](redstone.md#v:setBundledOutput)/[`getBundledInput`](redstone.md#v:getBundledInput)): These interact with "bundled" cables, such
as those from Project:Red. These allow you to send 16 separate on/off signals. Each channel corresponds to a
colour, with the first being [`colors.white`](colors.md#v:white) and the last [`colors.black`](colors.md#v:black).

Whenever a redstone input changes, a [`redstone`](../event/redstone.md) event will be fired. This may be used instead of repeativly
polling.

This module may also be referred to as `rs`. For example, one may call `rs.getSides()` instead of
[`getSides`](redstone.md#v:getSides).

### Usage

- 

Toggle the redstone signal above the computer every 0.5 seconds.

```
while true do
[ redstone.setOutput](redstone.md#v:setOutput)("top", not [redstone.getOutput](redstone.md#v:getOutput)("top"))
 sleep(0.5)
end
```

- 

Mimic a redstone comparator in [subtraction mode](https://minecraft.wiki/w/Redstone_Comparator#Subtract_signal_strength).

```
while true do
 local rear = rs.getAnalogueInput("back")
 local sides = math.max(rs.getAnalogueInput("left"), rs.getAnalogueInput("right"))
 rs.setAnalogueOutput("front", math.max(rear - sides, 0))
[
 os.pullEvent](os.md#v:pullEvent)("redstone") -- Wait for a change to inputs.
end
```

[getSides()](#v:getSides)  Returns a table containing the six sides of the computer. 

[setOutput(side, on)](#v:setOutput)  Turn the redstone signal of a specific side on or off. 

[getOutput(side)](#v:getOutput)  Get the current redstone output of a specific side. 

[getInput(side)](#v:getInput)  Get the current redstone input of a specific side. 

[setAnalogOutput(side, value)](#v:setAnalogOutput)  Set the redstone signal strength for a specific side. 

[setAnalogueOutput(side, value)](#v:setAnalogueOutput)  Set the redstone signal strength for a specific side. 

[getAnalogOutput(side)](#v:getAnalogOutput)  Get the redstone output signal strength for a specific side. 

[getAnalogueOutput(side)](#v:getAnalogueOutput)  Get the redstone output signal strength for a specific side. 

[getAnalogInput(side)](#v:getAnalogInput)  Get the redstone input signal strength for a specific side. 

[getAnalogueInput(side)](#v:getAnalogueInput)  Get the redstone input signal strength for a specific side. 

[setBundledOutput(side, output)](#v:setBundledOutput)  Set the bundled cable output for a specific side. 

[getBundledOutput(side)](#v:getBundledOutput)  Get the bundled cable output for a specific side. 

[getBundledInput(side)](#v:getBundledInput)  Get the bundled cable input for a specific side. 

[testBundledInput(side, mask)](#v:testBundledInput)  Determine if a specific combination of colours are on for the given side. 

[](#v:getSides)getSides()[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/java/dan200/computercraft/core/apis/RedstoneAPI.java#L73)

Returns a table containing the six sides of the computer. Namely, "top", "bottom", "left", "right", "front" and
"back".

### Returns

1. { [`string`](https://www.lua.org/manual/5.1/manual.html#5.4)... } A table of valid sides.

### Changes

- **New in version 1.2**

[](#v:setOutput)setOutput(side, on)[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/java/dan200/computercraft/core/apis/RedstoneMethods.java#L27)

Turn the redstone signal of a specific side on or off.

### Parameters

1. side[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The side to set.
2. on`boolean` Whether the redstone signal should be on or off. When on, a signal strength of 15 is emitted.

[](#v:getOutput)getOutput(side)[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/java/dan200/computercraft/core/apis/RedstoneMethods.java#L39)

Get the current redstone output of a specific side.

### Parameters

1. side[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The side to get.

### Returns

1. `boolean` Whether the redstone output is on or off.

### See also

- **[`setOutput`](redstone.md#v:setOutput)**

[](#v:getInput)getInput(side)[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/java/dan200/computercraft/core/apis/RedstoneMethods.java#L50)

Get the current redstone input of a specific side.

### Parameters

1. side[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The side to get.

### Returns

1. `boolean` Whether the redstone input is on or off.

[](#v:setAnalogOutput)setAnalogOutput(side, value)[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/java/dan200/computercraft/core/apis/RedstoneMethods.java#L63)

Set the redstone signal strength for a specific side.

### Parameters

1. side[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The side to set.
2. value`number` The signal strength between 0 and 15.

### Throws

- 

If `value` is not between 0 and 15.

### Changes

- **New in version 1.51**

[](#v:setAnalogueOutput)setAnalogueOutput(side, value)[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/java/dan200/computercraft/core/apis/RedstoneMethods.java#L63)

Set the redstone signal strength for a specific side.

### Parameters

1. side[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The side to set.
2. value`number` The signal strength between 0 and 15.

### Throws

- 

If `value` is not between 0 and 15.

### Changes

- **New in version 1.51**

[](#v:getAnalogOutput)getAnalogOutput(side)[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/java/dan200/computercraft/core/apis/RedstoneMethods.java#L77)

Get the redstone output signal strength for a specific side.

### Parameters

1. side[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The side to get.

### Returns

1. `number` The output signal strength, between 0 and 15.

### See also

- **[`setAnalogOutput`](redstone.md#v:setAnalogOutput)**

### Changes

- **New in version 1.51**

[](#v:getAnalogueOutput)getAnalogueOutput(side)[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/java/dan200/computercraft/core/apis/RedstoneMethods.java#L77)

Get the redstone output signal strength for a specific side.

### Parameters

1. side[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The side to get.

### Returns

1. `number` The output signal strength, between 0 and 15.

### See also

- **[`setAnalogOutput`](redstone.md#v:setAnalogOutput)**

### Changes

- **New in version 1.51**

[](#v:getAnalogInput)getAnalogInput(side)[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/java/dan200/computercraft/core/apis/RedstoneMethods.java#L89)

Get the redstone input signal strength for a specific side.

### Parameters

1. side[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The side to get.

### Returns

1. `number` The input signal strength, between 0 and 15.

### Changes

- **New in version 1.51**

[](#v:getAnalogueInput)getAnalogueInput(side)[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/java/dan200/computercraft/core/apis/RedstoneMethods.java#L89)

Get the redstone input signal strength for a specific side.

### Parameters

1. side[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The side to get.

### Returns

1. `number` The input signal strength, between 0 and 15.

### Changes

- **New in version 1.51**

[](#v:setBundledOutput)setBundledOutput(side, output)[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/java/dan200/computercraft/core/apis/RedstoneMethods.java#L102)

Set the bundled cable output for a specific side.

### Parameters

1. side[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The side to set.
2. output`number` The colour bitmask to set.

### See also

- **[`colors.subtract`](colors.md#v:subtract)** For removing a colour from the bitmask.
- **[`colors.combine`](colors.md#v:combine)** For adding a color to the bitmask.

[](#v:getBundledOutput)getBundledOutput(side)[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/java/dan200/computercraft/core/apis/RedstoneMethods.java#L113)

Get the bundled cable output for a specific side.

### Parameters

1. side[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The side to get.

### Returns

1. `number` The bundle cable's output.

[](#v:getBundledInput)getBundledInput(side)[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/java/dan200/computercraft/core/apis/RedstoneMethods.java#L125)

Get the bundled cable input for a specific side.

### Parameters

1. side[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The side to get.

### Returns

1. `number` The bundle cable's input.

### See also

- **[`testBundledInput`](redstone.md#v:testBundledInput)** To determine if a specific colour is set.

[](#v:testBundledInput)testBundledInput(side, mask)[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/java/dan200/computercraft/core/apis/RedstoneMethods.java#L142)

Determine if a specific combination of colours are on for the given side.

### Parameters

1. side[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The side to test.
2. mask`number` The mask to test.

### Returns

1. `boolean` If the colours are on.

### Usage

- 

Check if [`colors.white`](colors.md#v:white) and [`colors.black`](colors.md#v:black) are on above this block.

```
print([redstone.testBundledInput](redstone.md#v:testBundledInput)("top", [colors.combine](colors.md#v:combine)([colors.white](colors.md#v:white), [colors.black](colors.md#v:black))))
```

### See also

- **[`getBundledInput`](redstone.md#v:getBundledInput)**

Last updated on 2026-04-07
