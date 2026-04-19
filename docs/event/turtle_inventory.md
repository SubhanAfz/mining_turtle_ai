# turtle_inventory

The [`turtle_inventory`](turtle_inventory.md) event is fired when a turtle's inventory is changed.

## Return values

1. [`string`](https://www.lua.org/manual/5.1/manual.html#5.4): The event name.

## Example

Prints a message when the inventory is changed:

```
while true do
[  os.pullEvent](../module/os.md#v:pullEvent)("turtle_inventory")
  print("The inventory was changed.")
end
```

Last updated on 2026-04-07
