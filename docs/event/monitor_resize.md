# monitor_resize

The [`monitor_resize`](monitor_resize.md) event is fired when an adjacent or networked [monitor's](../peripheral/monitor.md) size is changed.

## Return Values

1. [`string`](https://www.lua.org/manual/5.1/manual.html#5.4): The event name.
2. [`string`](https://www.lua.org/manual/5.1/manual.html#5.4): The side or network ID of the monitor that was resized.

## Example

Prints a message when a monitor is resized:

```
while true do
  local event, side = [os.pullEvent](../module/os.md#v:pullEvent)("monitor_resize")
  print("The monitor on side " .. side .. " was resized.")
end
```

Last updated on 2026-04-07
