# alarm

The [`alarm`](alarm.md) event is fired when an alarm started with [`os.setAlarm`](../module/os.md#v:setAlarm) completes.

## Return Values

1. [`string`](https://www.lua.org/manual/5.1/manual.html#5.4): The event name.
2. `number`: The ID of the alarm that finished.

## Example

Starts a timer and then waits for it to complete.

```
local alarm_id = [os.setAlarm](../module/os.md#v:setAlarm)([os.time](../module/os.md#v:time)() + 0.05)
local event, id
repeat
    event, id = [os.pullEvent](../module/os.md#v:pullEvent)("alarm")
until id == alarm_id
print("Alarm with ID " .. id .. " was fired")
```

### See also

- **[`os.setAlarm`](../module/os.md#v:setAlarm)** To start an alarm.

Last updated on 2026-04-07
