# mouse_drag

This event is fired every time the mouse is moved while a mouse button is being held.

## Return values

1. [`string`](https://www.lua.org/manual/5.1/manual.html#5.4): The event name.
2. `number`: The [mouse button](mouse_click.md#Mouse_buttons) that is being pressed.
3. `number`: The X-coordinate of the mouse.
4. `number`: The Y-coordinate of the mouse.

## Example

Print the button and the coordinates whenever the mouse is dragged.

```
while true do
  local event, button, x, y = [os.pullEvent](../module/os.md#v:pullEvent)("mouse_drag")
  print(("The mouse button %s was dragged at %d, %d"):format(button, x, y))
end
```

### See also

- **[`mouse_click`](mouse_click.md)** For when a mouse button is initially pressed.

Last updated on 2026-04-07
