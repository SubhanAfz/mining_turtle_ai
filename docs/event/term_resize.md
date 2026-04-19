# term_resize

The [`term_resize`](term_resize.md) event is fired when the main terminal is resized. For instance:

- When a the tab bar is shown or hidden in [`multishell`](../module/multishell.md).
- When the terminal is redirected to a monitor via the "monitor" program and the monitor is resized.

When this event fires, some parts of the terminal may have been moved or deleted. Simple terminal programs (those
not using [`term.setCursorPos`](../module/term.md#v:setCursorPos)) can ignore this event, but more complex GUI programs should redraw the entire screen.

## Return values

1. [`string`](https://www.lua.org/manual/5.1/manual.html#5.4): The event name.

## Example

Print a message each time the terminal is resized.

```
while true do
[  os.pullEvent](../module/os.md#v:pullEvent)("term_resize")
  local w, h = [term.getSize](../module/term.md#v:getSize)()
  print("The term was resized to (" .. w .. ", " .. h .. ")")
end
```

Last updated on 2026-04-07
