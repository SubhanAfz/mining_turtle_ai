# paste

The [`paste`](paste.md) event is fired when text is pasted into the computer through Ctrl-V (or ⌘V on Mac).

## Return values

1. [`string`](https://www.lua.org/manual/5.1/manual.html#5.4): The event name.
2. [`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The text that was pasted.

## Example

Prints pasted text:

```
while true do
  local event, text = [os.pullEvent](../module/os.md#v:pullEvent)("paste")
  print('"' .. text .. '" was pasted')
end
```

Last updated on 2026-04-07
