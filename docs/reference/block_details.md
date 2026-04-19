# Block details

Several functions in CC: Tweaked, such as [`turtle.inspect`](../module/turtle.md#v:inspect) and [`commands.getBlockInfo`](../module/commands.md#v:getBlockInfo) provide a way to get
information about a block in the world. This page details information about blocks that CC: Tweaked may return.

## Basic information

Block information will *always* contain:

- `name: string`: The namespaced ID for this block, e.g. `minecraft:dirt`. See [the Minecraft wiki](https://minecraft.wiki/w/Java_Edition_data_values#Blocks) for a
list of vanilla block IDs.
- `state: { [string] = any}`: A table containing the block state of the block.

### Example

A fully hydrated block of farmland:

```
{
    name = "minecraft:farmland",
    state = {
        moisture = 7
    }
}
```

An extended piston, facing upwards:

```
{
    name = "minecraft:piston",
    state = {
        facing = "up",
        extended = true
    }
}
```

## Block tags

The [tags](https://minecraft.wiki/w/Block_tag_%28Java_Edition%29) a block has.

- `tags: { [string] = boolean }`: The set of tags for this block. This is a mapping of tag name to `true`.

While the representation of tags is a little more complicated then a single list, this makes it very easy to check if a
block has a certain tag:

```
--- Check if the block in front of the turtle is a log.
local function is_log()
    local ok, block = [turtle.inspect](../module/turtle.md#v:inspect)()
    return ok and block.tags["minecraft:logs"]
end
```

### Example

A fully hydrated block of farmland:

```
{
    name = "minecraft:farmland",
    state = { ... },
    tags = {
        ["minecraft:mineable/shovel"] = true,
    }
}
```

## Map colour

The colour the block will appear on the map, if specified.

- `mapColour?: number`: The colour of the block, as an RGB hex value.
- `mapColor?: number`: The color of the block, as an RGB hex value.

The map colour is just returned as a plain number (e.g. `9923917` for farmland). It can either be displayed in hex with
[`string.format`](https://www.lua.org/manual/5.1/manual.html#pdf-string.format), or converted to individual RGB values with [`colors.unpackRGB`](../module/colors.md#v:unpackRGB).

### Example

A fully hydrated block of farmland:

```
{
    name = "minecraft:farmland",
    state = { ... },
    mapColour = 9923917,
    mapColor = 9923917,
}
```

### Changes

- **New in version 1.64**
- **Changed in version 1.76:** Added block state.
- **Changed in version 1.117.0:** Added map colour.

Last updated on 2026-04-07
