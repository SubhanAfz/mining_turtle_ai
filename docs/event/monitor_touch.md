# monitor_touch

The [`monitor_touch`](monitor_touch.md) event is fired when an adjacent or networked [Advanced Monitor](../peripheral/monitor.md) is right-clicked.

## Return Values

1. [`string`](https://www.lua.org/manual/5.1/manual.html#5.4): The event name.
2. [`string`](https://www.lua.org/manual/5.1/manual.html#5.4): The side or network ID of the monitor that was touched.
3. `number`: The X coordinate of the touch, in characters.
4. `number`: The Y coordinate of the touch, in characters.

## Example

Prints a message when a monitor is touched:

```
while true do
  local event, side, x, y = [os.pullEvent](../module/os.md#v:pullEvent)("monitor_touch")
  print("The monitor on side " .. side .. " was touched at (" .. x .. ", " .. y .. ")")
end
```

Last updated on 2026-04-07
