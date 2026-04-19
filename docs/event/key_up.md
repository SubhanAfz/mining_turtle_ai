# key_up

Fired whenever a key is released (or the terminal is closed while a key was being pressed).

This event returns a numerical "key code" (for instance, F1 is 290). This value may vary between versions and
so it is recommended to use the constants in the [`keys`](../module/keys.md) API rather than hard coding numeric values.

## Return values

1. [`string`](https://www.lua.org/manual/5.1/manual.html#5.4): The event name.
2. `number`: The numerical key value of the key pressed.

## Example

Prints each key released on the keyboard whenever a [`key_up`](key_up.md) event is fired.

```
while true do
  local event, key = [os.pullEvent](../module/os.md#v:pullEvent)("key_up")
  local name = [keys.getName](../module/keys.md#v:getName)(key) or "unknown key"
  print(name .. " was released.")
end
```

### See also

- **[`keys`](../module/keys.md)** For a lookup table of the given keys.

Last updated on 2026-04-07
