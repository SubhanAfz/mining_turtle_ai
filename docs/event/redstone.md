# redstone

The [`redstone`](redstone.md) event is fired whenever any redstone inputs on the computer or [relay](../peripheral/redstone_relay.md) change.

## Return values

1. [`string`](https://www.lua.org/manual/5.1/manual.html#5.4): The event name.

## Example

Prints a message when a redstone input changes:

```
while true do
[  os.pullEvent](../module/os.md#v:pullEvent)("redstone")
  print("A redstone input has changed!")
end
```

## See also

- [The `redstone` API on computers](../module/redstone.md)
- [The `redstone_relay` peripheral](../peripheral/redstone_relay.md)

Last updated on 2026-04-07
