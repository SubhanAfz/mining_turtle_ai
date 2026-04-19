# websocket_failure

The [`websocket_failure`](websocket_failure.md) event is fired when a WebSocket connection request fails.

This event is normally handled inside [`http.websocket`](../module/http.md#v:websocket), but it can still be seen when using [`http.websocketAsync`](../module/http.md#v:websocketAsync).

## Return Values

1. [`string`](https://www.lua.org/manual/5.1/manual.html#5.4): The event name.
2. [`string`](https://www.lua.org/manual/5.1/manual.html#5.4): The URL of the site requested.
3. [`string`](https://www.lua.org/manual/5.1/manual.html#5.4): An error describing the failure.

## Example

Prints an error why the website cannot be contacted:

```
local myURL = "wss://example.tweaked.cc/not-a-websocket"
[http.websocketAsync](../module/http.md#v:websocketAsync)(myURL)
local event, url, err
repeat
    event, url, err = [os.pullEvent](../module/os.md#v:pullEvent)("websocket_failure")
until url == myURL
print("The URL " .. url .. " could not be reached: " .. err)
```

### See also

- **[`http.websocketAsync`](../module/http.md#v:websocketAsync)** To send an HTTP request.

Last updated on 2026-04-07
