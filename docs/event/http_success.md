# http_success

The [`http_success`](http_success.md) event is fired when an HTTP request returns successfully.

This event is normally handled inside [`http.get`](../module/http.md#v:get) and [`http.post`](../module/http.md#v:post), but it can still be seen when using [`http.request`](../module/http.md#v:request).

## Return Values

1. [`string`](https://www.lua.org/manual/5.1/manual.html#5.4): The event name.
2. [`string`](https://www.lua.org/manual/5.1/manual.html#5.4): The URL of the site requested.
3. [`http.Response`](../module/http.md#ty:Response): The successful HTTP response.

## Example

Prints the content of a website (this may fail if the request fails):

```
local myURL = "https://tweaked.cc/"
[http.request](../module/http.md#v:request)(myURL)
local event, url, handle
repeat
    event, url, handle = [os.pullEvent](../module/os.md#v:pullEvent)("http_success")
until url == myURL
print("Contents of " .. url .. ":")
print(handle.readAll())
handle.close()
```

### See also

- **[`http.request`](../module/http.md#v:request)** To make an HTTP request.

Last updated on 2026-04-07
