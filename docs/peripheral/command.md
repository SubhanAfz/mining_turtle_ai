# command

This peripheral allows you to interact with command blocks.

Command blocks are only wrapped as peripherals if the `enable_command_block` option is true within the
config.

This API is *not* the same as the [`commands`](../module/commands.md) API, which is exposed on command computers.

[getCommand()](#v:getCommand)  Get the command this command block will run. 

[setCommand(command)](#v:setCommand)  Set the command block's command. 

[runCommand()](#v:runCommand)  Execute the command block once. 

[](#v:getCommand)getCommand()[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/common/src/main/java/dan200/computercraft/shared/peripheral/commandblock/CommandBlockPeripheral.java#L40)

Get the command this command block will run.

### Returns

1. [`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The current command.

[](#v:setCommand)setCommand(command)[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/common/src/main/java/dan200/computercraft/shared/peripheral/commandblock/CommandBlockPeripheral.java#L50)

Set the command block's command.

### Parameters

1. command[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The new command.

[](#v:runCommand)runCommand()[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/common/src/main/java/dan200/computercraft/shared/peripheral/commandblock/CommandBlockPeripheral.java#L63)

Execute the command block once.

### Returns

1. `boolean` If the command completed successfully.
2. [`string`](https://www.lua.org/manual/5.1/manual.html#5.4) | nil A failure message.

Last updated on 2026-04-07
