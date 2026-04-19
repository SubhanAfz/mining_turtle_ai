# http_failure

The [`http_failure`](http_failure.md) event is fired when an HTTP request fails.

This event is normally handled inside [`http.get`](../module/http.md#v:get) and [`http.post`](../module/http.md#v:post), but it can still be seen when using [`http.request`](../module/http.md#v:request).

## Return Values

1. [`string`](https://www.lua.org/manual/5.1/manual.html#5.4): The event name.
2. [`string`](https://www.lua.org/manual/5.1/manual.html#5.4): The URL of the site requested.
3. [`string`](https://www.lua.org/manual/5.1/manual.html#5.4): An error describing the failure.
4. [`http.Response`](../module/http.md#ty:Response)|`nil`: A response handle if the connection succeeded, but the server's
response indicated failure.

## Example

Prints an error why the website cannot be contacted:

```
local myURL = "https://does.not.exist.tweaked.cc"
[http.request](../module/http.md#v:request)(myURL)
local event, url, err
repeat
    event, url, err = [os.pullEvent](../module/os.md#v:pullEvent)("http_failure")
until url == myURL
print("The URL " .. url .. " could not be reached: " .. err)
```

Prints the contents of a webpage that does not exist:

```
local myURL = "https://tweaked.cc/this/does/not/exist"
[http.request](../module/http.md#v:request)(myURL)
local event, url, err, handle
repeat
    event, url, err, handle = [os.pullEvent](../module/os.md#v:pullEvent)("http_failure")
until url == myURL
print("The URL " .. url .. " could not be reached: " .. err)
print(handle.getResponseCode())
handle.close()
```

### See also

- **[`http.request`](../module/http.md#v:request)** To send an HTTP request.

Last updated on 2026-04-07
