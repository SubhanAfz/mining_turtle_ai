# paintutils

Utilities for drawing more complex graphics, such as pixels, lines and
images.

### Changes

- **New in version 1.45**

[parseImage(image)](#v:parseImage)  Parses an image from a multi-line string 

[loadImage(path)](#v:loadImage)  Loads an image from a file. 

[drawPixel(xPos, yPos [, colour])](#v:drawPixel)  Draws a single pixel to the current term at the specified position. 

[drawLine(startX, startY, endX, endY [, colour])](#v:drawLine)  Draws a straight line from the start to end position. 

[drawBox(startX, startY, endX, endY [, colour])](#v:drawBox)  Draws the outline of a box on the current term from the specified start position to the specified end position. 

[drawFilledBox(startX, startY, endX, endY [, colour])](#v:drawFilledBox)  Draws a filled box on the current term from the specified start position to the specified end position. 

[drawImage(image, xPos, yPos)](#v:drawImage)  Draw an image loaded by [`paintutils.parseImage`](paintutils.md#v:parseImage) or [`paintutils.loadImage`](paintutils.md#v:loadImage). 

[](#v:parseImage)parseImage(image)[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/resources/data/computercraft/lua/rom/apis/paintutils.lua#L66)

Parses an image from a multi-line string

### Parameters

1. image[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The string containing the raw-image data.

### Returns

1. [`table`](https://www.lua.org/manual/5.1/manual.html#5.5) The parsed image data, suitable for use with [`paintutils.drawImage`](paintutils.md#v:drawImage).

### Usage

- 

Parse an image from a string, and draw it.

```
local image = [paintutils.parseImage](paintutils.md#v:parseImage)([[
 e  e

e    e
 eeee
]])
[paintutils.drawImage](paintutils.md#v:drawImage)(image, [term.getCursorPos](term.md#v:getCursorPos)())
```

### Changes

- **New in version 1.80pr1**

[](#v:loadImage)loadImage(path)[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/resources/data/computercraft/lua/rom/apis/paintutils.lua#L89)

Loads an image from a file.

You can create a file suitable for being loaded using the `paint` program.

### Parameters

1. path[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The file to load.

### Returns

1. [`table`](https://www.lua.org/manual/5.1/manual.html#5.5) | nil The parsed image data, suitable for use with
[`paintutils.drawImage`](paintutils.md#v:drawImage), or `nil` if the file does not exist.

### Usage

- 

Load an image and draw it.

```
local image = [paintutils.loadImage](paintutils.md#v:loadImage)("data/example.nfp")
[paintutils.drawImage](paintutils.md#v:drawImage)(image, [term.getCursorPos](term.md#v:getCursorPos)())
```

[](#v:drawPixel)drawPixel(xPos, yPos [, colour])[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/resources/data/computercraft/lua/rom/apis/paintutils.lua#L112)

Draws a single pixel to the current term at the specified position.

##### ⚠ warning

This function may change the position of the cursor and the current
background colour. You should not expect either to be preserved.

### Parameters

1. xPos`number` The x position to draw at, where 1 is the far left.
2. yPos`number` The y position to draw at, where 1 is the very top.
3. colour?`number` The [color](colors.md) of this pixel. This will be
the current background colour if not specified.

[](#v:drawLine)drawLine(startX, startY, endX, endY [, colour])[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/resources/data/computercraft/lua/rom/apis/paintutils.lua#L138)

Draws a straight line from the start to end position.

##### ⚠ warning

This function may change the position of the cursor and the current
background colour. You should not expect either to be preserved.

### Parameters

1. startX`number` The starting x position of the line.
2. startY`number` The starting y position of the line.
3. endX`number` The end x position of the line.
4. endY`number` The end y position of the line.
5. colour?`number` The [color](colors.md) of this pixel. This will be
the current background colour if not specified.

### Usage

- 

```
[paintutils.drawLine](paintutils.md#v:drawLine)(2, 3, 30, 7, [colors.red](colors.md#v:red))
```

[](#v:drawBox)drawBox(startX, startY, endX, endY [, colour])[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/resources/data/computercraft/lua/rom/apis/paintutils.lua#L215)

Draws the outline of a box on the current term from the specified start
position to the specified end position.

##### ⚠ warning

This function may change the position of the cursor and the current
background colour. You should not expect either to be preserved.

### Parameters

1. startX`number` The starting x position of the line.
2. startY`number` The starting y position of the line.
3. endX`number` The end x position of the line.
4. endY`number` The end y position of the line.
5. colour?`number` The [color](colors.md) of this pixel. This will be
the current background colour if not specified.

### Usage

- 

```
[paintutils.drawBox](paintutils.md#v:drawBox)(2, 3, 30, 7, [colors.red](colors.md#v:red))
```

[](#v:drawFilledBox)drawFilledBox(startX, startY, endX, endY [, colour])[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/resources/data/computercraft/lua/rom/apis/paintutils.lua#L271)

Draws a filled box on the current term from the specified start position to
the specified end position.

##### ⚠ warning

This function may change the position of the cursor and the current
background colour. You should not expect either to be preserved.

### Parameters

1. startX`number` The starting x position of the line.
2. startY`number` The starting y position of the line.
3. endX`number` The end x position of the line.
4. endY`number` The end y position of the line.
5. colour?`number` The [color](colors.md) of this pixel. This will be
the current background colour if not specified.

### Usage

- 

```
[paintutils.drawFilledBox](paintutils.md#v:drawFilledBox)(2, 3, 30, 7, [colors.red](colors.md#v:red))
```

[](#v:drawImage)drawImage(image, xPos, yPos)[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/resources/data/computercraft/lua/rom/apis/paintutils.lua#L319)

Draw an image loaded by [`paintutils.parseImage`](paintutils.md#v:parseImage) or [`paintutils.loadImage`](paintutils.md#v:loadImage).

##### ⚠ warning

This function may change the position of the cursor and the current
background colour. You should not expect either to be preserved.

### Parameters

1. image[`table`](https://www.lua.org/manual/5.1/manual.html#5.5) The parsed image data.
2. xPos`number` The x position to start drawing at.
3. yPos`number` The y position to start drawing at.

### Usage

- 

Load an image and draw it.

```
local image = [paintutils.loadImage](paintutils.md#v:loadImage)("data/example.nfp")
[paintutils.drawImage](paintutils.md#v:drawImage)(image, [term.getCursorPos](term.md#v:getCursorPos)())
```

Last updated on 2026-04-07
