# printer

The printer peripheral allows printing text onto pages. These pages can then be crafted together into printed pages
or books.

Printers require ink (one of the coloured dyes) and paper in order to function. Once loaded, a new page can be
started with [`newPage`](printer.md#v:newPage). Then the printer can be used similarly to a normal terminal; [text can be written](printer.md#v:write), and [the cursor moved](printer.md#v:setCursorPos). Once all text has
been printed, [`endPage`](printer.md#v:endPage) should be called to finally print the page.

## Recipes

**Printer**

![Stone](https://tweaked.cc/images/items/minecraft/stone.png)

![Stone](https://tweaked.cc/images/items/minecraft/stone.png)

![Stone](https://tweaked.cc/images/items/minecraft/stone.png)

![Stone](https://tweaked.cc/images/items/minecraft/stone.png)

![Redstone Dust](https://tweaked.cc/images/items/minecraft/redstone.png)

![Stone](https://tweaked.cc/images/items/minecraft/stone.png)

![Stone](https://tweaked.cc/images/items/minecraft/stone.png)

![Black Dye](https://tweaked.cc/images/items/minecraft/black_dye.png)

![Stone](https://tweaked.cc/images/items/minecraft/stone.png)

![Printer](https://tweaked.cc/images/items/computercraft/printer.png)

**Printed Pages**

![Printed Page](https://tweaked.cc/images/items/computercraft/printed_page.png)

![Printed Page](https://tweaked.cc/images/items/computercraft/printed_page.png)

![String](https://tweaked.cc/images/items/minecraft/string.png)

![Printed Pages](https://tweaked.cc/images/items/computercraft/printed_pages.png)

**Printed Book**

![Leather](https://tweaked.cc/images/items/minecraft/leather.png)

![Printed Page](https://tweaked.cc/images/items/computercraft/printed_page.png)

![String](https://tweaked.cc/images/items/minecraft/string.png)

![Printed Book](https://tweaked.cc/images/items/computercraft/printed_book.png)

### Usage

- 

Print a page titled "Hello" with a small message on it.

```
local printer = [peripheral.find](../module/peripheral.md#v:find)("printer")

-- Start a new page, or print an error.
if not printer.newPage() then
 error("Cannot start a new page. Do you have ink and paper?")
end

-- Write to the page
printer.setPageTitle("Hello")
printer.write("This is my first page")
printer.setCursorPos(1, 3)
printer.write("This is two lines below.")

-- And finally print the page!
if not printer.endPage() then
 error("Cannot end the page. Is there enough space?")
end
```

### See also

- **[`cc.strings.wrap`](../library/cc.strings.md#v:wrap)** To wrap text before printing it.

[write(text)](#v:write)  Writes text to the current page. 

[getCursorPos()](#v:getCursorPos)  Returns the current position of the cursor on the page. 

[setCursorPos(x, y)](#v:setCursorPos)  Sets the position of the cursor on the page. 

[getPageSize()](#v:getPageSize)  Returns the size of the current page. 

[newPage()](#v:newPage)  Starts printing a new page. 

[endPage()](#v:endPage)  Finalizes printing of the current page and outputs it to the tray. 

[setPageTitle([title])](#v:setPageTitle)  Sets the title of the current page. 

[getInkLevel()](#v:getInkLevel)  Returns the amount of ink left in the printer. 

[getPaperLevel()](#v:getPaperLevel)  Returns the amount of paper left in the printer. 

[](#v:write)write(text)[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/common/src/main/java/dan200/computercraft/shared/peripheral/printer/PrinterPeripheral.java#L81)

Writes text to the current page.

### Parameters

1. text[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The value to write to the page.

### Throws

- 

If any values couldn't be converted to a string, or if no page is started.

[](#v:getCursorPos)getCursorPos()[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/common/src/main/java/dan200/computercraft/shared/peripheral/printer/PrinterPeripheral.java#L97)

Returns the current position of the cursor on the page.

### Returns

1. `number` The X position of the cursor.
2. `number` The Y position of the cursor.

### Throws

- 

If a page isn't being printed.

[](#v:setCursorPos)setCursorPos(x, y)[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/common/src/main/java/dan200/computercraft/shared/peripheral/printer/PrinterPeripheral.java#L112)

Sets the position of the cursor on the page.

### Parameters

1. x`number` The X coordinate to set the cursor at.
2. y`number` The Y coordinate to set the cursor at.

### Throws

- 

If a page isn't being printed.

[](#v:getPageSize)getPageSize()[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/common/src/main/java/dan200/computercraft/shared/peripheral/printer/PrinterPeripheral.java#L126)

Returns the size of the current page.

### Returns

1. `number` The width of the page.
2. `number` The height of the page.

### Throws

- 

If a page isn't being printed.

[](#v:newPage)newPage()[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/common/src/main/java/dan200/computercraft/shared/peripheral/printer/PrinterPeripheral.java#L139)

Starts printing a new page.

### Returns

1. `boolean` Whether a new page could be started.

[](#v:endPage)endPage()[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/common/src/main/java/dan200/computercraft/shared/peripheral/printer/PrinterPeripheral.java#L150)

Finalizes printing of the current page and outputs it to the tray.

### Returns

1. `boolean` Whether the page could be successfully finished.

### Throws

- 

If a page isn't being printed.

[](#v:setPageTitle)setPageTitle([title])[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/common/src/main/java/dan200/computercraft/shared/peripheral/printer/PrinterPeripheral.java#L162)

Sets the title of the current page.

### Parameters

1. title?[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The title to set for the page.

### Throws

- 

If a page isn't being printed.

[](#v:getInkLevel)getInkLevel()[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/common/src/main/java/dan200/computercraft/shared/peripheral/printer/PrinterPeripheral.java#L173)

Returns the amount of ink left in the printer.

### Returns

1. `number` The amount of ink available to print with.

[](#v:getPaperLevel)getPaperLevel()[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/common/src/main/java/dan200/computercraft/shared/peripheral/printer/PrinterPeripheral.java#L183)

Returns the amount of paper left in the printer.

### Returns

1. `number` The amount of paper available to print with.

Last updated on 2026-04-07
