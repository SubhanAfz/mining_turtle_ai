# gps

Use [modems](../peripheral/modem.md) to locate the position of the current turtle or
computers.

This works by communicating with other computers (called GPS hosts) that already
know their position, finding the distance to those computers (with
[`modem_message`](../event/modem_message.md)), and using that to derive its position from theirs (with a
process known as [trilateration](https://en.wikipedia.org/wiki/Trilateration).

### See also

- **[`Setting up GPS`](../guide/gps_setup.md)**

### Changes

- **New in version 1.31**

[CHANNEL_GPS = 65534](#v:CHANNEL_GPS)  The channel which GPS requests and responses are broadcast on. 

[locate([timeout=2 [, debug=false]])](#v:locate)  Tries to retrieve the computer or turtles own location. 

[](#v:CHANNEL_GPS)CHANNEL_GPS = 65534[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/resources/data/computercraft/lua/rom/apis/gps.lua#L21)

The channel which GPS requests and responses are broadcast on.

[](#v:locate)locate([timeout=2 [, debug=false]])[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/resources/data/computercraft/lua/rom/apis/gps.lua#L86)

Tries to retrieve the computer or turtles own location.

### Parameters

1. timeout?`number` = `2` The maximum time in seconds taken to establish our
position.
2. debug?`boolean` = `false` Print debugging messages

### Returns

1. `number` This computer's `x` position.
2. `number` This computer's `y` position.
3. `number` This computer's `z` position.

#### Or

1. nil If the position could not be established.

Last updated on 2026-04-07
