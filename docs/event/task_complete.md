# task_complete

The [`task_complete`](task_complete.md) event is fired when an asynchronous task completes. This is usually handled inside the function call that queued the task; however, functions such as [`commands.execAsync`](../module/commands.md#v:execAsync) return immediately so the user can wait for completion.

## Return Values

1. [`string`](https://www.lua.org/manual/5.1/manual.html#5.4): The event name.
2. `number`: The ID of the task that completed.
3. `boolean`: Whether the command succeeded.
4. [`string`](https://www.lua.org/manual/5.1/manual.html#5.4): If the command failed, an error message explaining the failure. (This is not present if the command succeeded.)
5. …: Any parameters returned from the command.

## Example

Prints the results of an asynchronous command:

```
local taskID = [commands.execAsync](../module/commands.md#v:execAsync)("say Hello")
local event
repeat
    event = {[os.pullEvent](../module/os.md#v:pullEvent)("task_complete")}
until event[2] == taskID
if event[3] == true then
  print("Task " .. event[2] .. " succeeded:", table.unpack(event, 4))
else
  print("Task " .. event[2] .. " failed: " .. event[4])
end
```

### See also

- **[`commands.execAsync`](../module/commands.md#v:execAsync)** To run a command which fires a task_complete event.

Last updated on 2026-04-07
