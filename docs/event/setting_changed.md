# setting_changed

The [`setting_changed`](setting_changed.md) event is fired when a setting is modified with the [`settings`](../module/settings.md) API.

## Return Values

1. [`string`](https://www.lua.org/manual/5.1/manual.html#5.4): The event name.
2. [`string`](https://www.lua.org/manual/5.1/manual.html#5.4): The name of the setting that was changed.
3. `any`: The value the setting was set to.
4. `any`: The previous value of the setting.

## Example

[Update a setting](../module/settings.md#v:set), and then wait for the corresponding
`setting_changed` event.

```
[settings.set](../module/settings.md#v:set)("my.setting", 123)
print([os.pullEvent](../module/os.md#v:pullEvent)("setting_changed"))
```

### See also

- **[`settings`](../module/settings.md)**

Last updated on 2026-04-07
