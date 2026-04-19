# cc.completion

A collection of helper methods for working with input completion, such
as that require by [`_G.read`](../module/_G.md#v:read).

### See also

- **[`cc.shell.completion`](cc.shell.completion.md)** For additional helpers to use with
[`shell.setCompletionFunction`](../module/shell.md#v:setCompletionFunction).

### Changes

- **New in version 1.85.0**

[choice(text, choices [, add_space])](#v:choice)  Complete from a choice of one or more strings. 

[peripheral(text [, add_space])](#v:peripheral)  Complete the name of a currently attached peripheral. 

[side(text [, add_space])](#v:side)  Complete the side of a computer. 

[setting(text [, add_space])](#v:setting)  Complete a [setting](../module/settings.md). 

[command(text [, add_space])](#v:command)  Complete the name of a Minecraft [command](../module/commands.md). 

[](#v:choice)choice(text, choices [, add_space])[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/resources/data/computercraft/lua/rom/modules/main/cc/completion.lua#L42)

Complete from a choice of one or more strings.

### Parameters

1. text[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The input string to complete.
2. choices{ [`string`](https://www.lua.org/manual/5.1/manual.html#5.4)... } The list of choices to complete from.
3. add_space?`boolean` Whether to add a space after the completed item.

### Returns

1. { [`string`](https://www.lua.org/manual/5.1/manual.html#5.4)... } A list of suffixes of matching strings.

### Usage

- 

Call [`_G.read`](../module/_G.md#v:read), completing the names of various animals.

```
local [completion ](cc.completion.md)= require "cc.completion"
local animals = { "dog", "cat", "lion", "unicorn" }
read(nil, nil, function(text) return [completion.choice](cc.completion.md#v:choice)(text, animals) end)
```

[](#v:peripheral)peripheral(text [, add_space])[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/resources/data/computercraft/lua/rom/modules/main/cc/completion.lua#L57)

Complete the name of a currently attached peripheral.

### Parameters

1. text[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The input string to complete.
2. add_space?`boolean` Whether to add a space after the completed name.

### Returns

1. { [`string`](https://www.lua.org/manual/5.1/manual.html#5.4)... } A list of suffixes of matching peripherals.

### Usage

- 

```
local [completion ](cc.completion.md)= require "cc.completion"
read(nil, nil, [completion.peripheral](cc.completion.md#v:peripheral))
```

[](#v:side)side(text [, add_space])[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/resources/data/computercraft/lua/rom/modules/main/cc/completion.lua#L73)

Complete the side of a computer.

### Parameters

1. text[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The input string to complete.
2. add_space?`boolean` Whether to add a space after the completed side.

### Returns

1. { [`string`](https://www.lua.org/manual/5.1/manual.html#5.4)... } A list of suffixes of matching sides.

### Usage

- 

```
local [completion ](cc.completion.md)= require "cc.completion"
read(nil, nil, [completion.side](cc.completion.md#v:side))
```

[](#v:setting)setting(text [, add_space])[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/resources/data/computercraft/lua/rom/modules/main/cc/completion.lua#L87)

Complete a [setting](../module/settings.md).

### Parameters

1. text[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The input string to complete.
2. add_space?`boolean` Whether to add a space after the completed settings.

### Returns

1. { [`string`](https://www.lua.org/manual/5.1/manual.html#5.4)... } A list of suffixes of matching settings.

### Usage

- 

```
local [completion ](cc.completion.md)= require "cc.completion"
read(nil, nil, [completion.setting](cc.completion.md#v:setting))
```

[](#v:command)command(text [, add_space])[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/resources/data/computercraft/lua/rom/modules/main/cc/completion.lua#L103)

Complete the name of a Minecraft [command](../module/commands.md).

### Parameters

1. text[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The input string to complete.
2. add_space?`boolean` Whether to add a space after the completed command.

### Returns

1. { [`string`](https://www.lua.org/manual/5.1/manual.html#5.4)... } A list of suffixes of matching commands.

### Usage

- 

```
local [completion ](cc.completion.md)= require "cc.completion"
read(nil, nil, [completion.command](cc.completion.md#v:command))
```

Last updated on 2026-04-07
