# terminate

The [`terminate`](terminate.md) event is fired when Ctrl-T is held down.

This event is normally handled by [`os.pullEvent`](../module/os.md#v:pullEvent), and will not be returned. However, [`os.pullEventRaw`](../module/os.md#v:pullEventRaw) will return this event when fired.

[`terminate`](terminate.md) will be sent even when a filter is provided to [`os.pullEventRaw`](../module/os.md#v:pullEventRaw). When using [`os.pullEventRaw`](../module/os.md#v:pullEventRaw) with a filter, make sure to check that the event is not [`terminate`](terminate.md).

## Return values

1. [`string`](https://www.lua.org/manual/5.1/manual.html#5.4): The event name.

## Example

Prints a message when Ctrl-T is held:

```
while true do
  local event = [os.pullEventRaw](../module/os.md#v:pullEventRaw)("terminate")
  if event == "terminate" then print("Terminate requested!") end
end
```

Exits when Ctrl-T is held:

```
while true do
[  os.pullEvent](../module/os.md#v:pullEvent)()
end
```

Last updated on 2026-04-07
