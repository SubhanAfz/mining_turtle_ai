# ![CC: Tweaked](https://tweaked.cc/logo-42c40e20.png)

CC: Tweaked is a mod for Minecraft which adds programmable computers, turtles and more to the game. A fork of the
much-beloved [ComputerCraft](https://github.com/dan200/ComputerCraft), it continues its legacy with improved performance and stability, along with a wealth of
new features.

CC: Tweaked can be installed from [Modrinth](https://modrinth.com/mod/gu7yAYhd). It runs on both [Minecraft Forge](https://files.minecraftforge.net/) and [Fabric](https://fabricmc.net/use/installer/).

## Features

Controlled using the [Lua programming language](https://www.lua.org/), CC: Tweaked's computers provides all the tools you need to start
writing code and automating your Minecraft world.

![A ComputerCraft terminal open and ready to be programmed.](https://tweaked.cc/basic-terminal-45a33440.png)

While computers are incredibly powerful, they're rather limited by their inability to move about. *Turtles* are the
solution here. They can move about the world, placing and breaking blocks, swinging a sword to protect you from zombies,
or whatever else you program them to!

![A turtle tunneling in Minecraft.](https://tweaked.cc/turtle-1b1e3370.png)

Not all problems can be solved with a pickaxe though, and so CC: Tweaked also provides a bunch of additional peripherals
for your computers. You can play a tune with speakers, display text or images on a monitor, connect all your
computers together with modems, and much more.

Computers can now also interact with inventories such as chests, allowing you to build complex inventory and item
management systems.

![A chest's contents being read by a computer and displayed on a monitor.](https://tweaked.cc/peripherals-d5df11cc.png)

## Getting Started

While ComputerCraft is lovely for both experienced programmers and for people who have never coded before, it can be a
little daunting getting started. Thankfully, there's several fantastic tutorials out there:

- [Direwolf20's ComputerCraft tutorials](https://www.youtube.com/watch?v=wrUHUhfCY5A)
- [Sethbling's ComputerCraft series](https://www.youtube.com/watch?v=DSsx4VSe-Uk)
- [Lyqyd's Computer Basics 1](https://ccf.squiddev.cc/forums2/index.php?/topic/15033-computer-basics-i/)

Once you're a little more familiar with the mod, the sidebar and links below provide more detailed documentation on the
various APIs and peripherals provided by the mod.

## Community

If you need help getting started with CC: Tweaked, want to show off your latest project, or just want to chat about
ComputerCraft, do check out our [GitHub discussions page](https://github.com/cc-tweaked/CC-Tweaked/discussions)! There's also a fairly populated,
albeit quiet IRC channel on [EsperNet](https://www.esper.net/), if that's more your cup of tea. You can join `#computercraft` through your
desktop client, or online using [KiwiIRC](https://kiwiirc.com/nextclient/#irc://irc.esper.net:+6697/#computercraft).

## Get Involved

CC: Tweaked lives on [GitHub](https://github.com/cc-tweaked/CC-Tweaked/). If you've got any ideas, feedback or bugs please do [create an issue](https://github.com/cc-tweaked/CC-Tweaked/issues/new/choose).

## Globals

[_G](module/_G.md)  Functions in the global environment, defined in `bios.lua`. 

[colors](module/colors.md)  Constants and functions for colour values, suitable for working with [`term`](module/term.md) and [`redstone`](module/redstone.md). 

[colours](module/colours.md)  An alternative version of [`colors`](module/colors.md) for lovers of British spelling. 

[commands](module/commands.md)  Execute Minecraft commands and gather data from the results from a command computer. 

[disk](module/disk.md)  Interact with disk drives. 

[fs](module/fs.md)  Interact with the computer's files and filesystem, allowing you to manipulate files, directories and paths. 

[gps](module/gps.md)  Use [modems](peripheral/modem.md) to locate the position of the current turtle or computers. 

[help](module/help.md)  Find help files on the current computer. 

[http](module/http.md)  Make HTTP requests, sending and receiving data to a remote web server. 

[io](module/io.md)  Emulates Lua's standard io library. 

[keys](module/keys.md)  Constants for all keyboard "key codes", as queued by the [`key`](event/key.md) event. 

[multishell](module/multishell.md)  Multishell allows multiple programs to be run at the same time. 

[os](module/os.md)  The [`os`](module/os.md) API allows interacting with the current computer. 

[paintutils](module/paintutils.md)  Utilities for drawing more complex graphics, such as pixels, lines and images. 

[parallel](module/parallel.md)  A simple way to run several functions at once. 

[peripheral](module/peripheral.md)  Find and control peripherals attached to this computer. 

[pocket](module/pocket.md)  Control the current pocket computer, adding or removing upgrades. 

[rednet](module/rednet.md)  Communicate with other computers by using [modems](peripheral/modem.md). 

[redstone](module/redstone.md)  Get and set redstone signals adjacent to this computer. 

[settings](module/settings.md)  Read and write configuration options for CraftOS and your programs. 

[shell](module/shell.md)  The shell API provides access to CraftOS's command line interface. 

[term](module/term.md)  Interact with a computer's terminal or monitors, writing text and drawing ASCII graphics. 

[textutils](module/textutils.md)  Helpful utilities for formatting and manipulating strings. 

[turtle](module/turtle.md)  Turtles are a robotic device, which can break and place blocks, attack mobs, and move about the world. 

[vector](module/vector.md)  A basic 3D vector type and some common vector operations. 

[window](module/window.md)  A [terminal redirect](module/term.md#ty:Redirect) occupying a smaller area of an existing terminal. 

## Modules

[cc.audio.dfpwm](library/cc.audio.dfpwm.md)  Convert between streams of DFPWM audio data and a list of amplitudes. 

[cc.completion](library/cc.completion.md)  A collection of helper methods for working with input completion, such as that require by [`_G.read`](module/_G.md#v:read). 

[cc.expect](library/cc.expect.md)  The [`cc.expect`](library/cc.expect.md) library provides helper functions for verifying that function arguments are well-formed and of the correct type. 

[cc.image.nft](library/cc.image.nft.md)  Read and draw nft ("Nitrogen Fingers Text") images. 

[cc.pretty](library/cc.pretty.md)  A pretty printer for rendering data structures in an aesthetically pleasing manner. 

[cc.require](library/cc.require.md)  A pure Lua implementation of the builtin [`require`](https://www.lua.org/manual/5.1/manual.html#pdf-require) function and [`package`](https://www.lua.org/manual/5.1/manual.html#5.3) library. 

[cc.shell.completion](library/cc.shell.completion.md)  A collection of helper methods for working with shell completion. 

[cc.strings](library/cc.strings.md)  Various utilities for working with strings and text. 

## Peripherals

[command](peripheral/command.md)  This peripheral allows you to interact with command blocks. 

[computer](peripheral/computer.md)  A computer or turtle wrapped as a peripheral. 

[drive](peripheral/drive.md)  Disk drives are a peripheral which allow you to read and write to floppy disks and other "mountable media" (such as computers or turtles). 

[modem](peripheral/modem.md)  Modems allow you to send messages between computers over long distances. 

[monitor](peripheral/monitor.md)  Monitors are a block which act as a terminal, displaying information on one side. 

[printer](peripheral/printer.md)  The printer peripheral allows printing text onto pages. 

[redstone_relay](peripheral/redstone_relay.md)  The redstone relay is a peripheral that allows reading and outputting redstone signals. 

[speaker](peripheral/speaker.md)  The speaker peripheral allows your computer to play notes and other sounds. 

## Generic Peripherals

[energy_storage](generic_peripheral/energy_storage.md)  Methods for interacting with blocks which store energy. 

[fluid_storage](generic_peripheral/fluid_storage.md)  Methods for interacting with tanks and other fluid storage blocks. 

[inventory](generic_peripheral/inventory.md)  Methods for interacting with inventories. 

## Events

[alarm](event/alarm.md)  The [`alarm`](event/alarm.md) event is fired when an alarm started with [`os.setAlarm`](module/os.md#v:setAlarm) completes. 

[char](event/char.md)  The [`char`](event/char.md) event is fired when a character is typed on the keyboard. 

[computer_command](event/computer_command.md)  The [`computer_command`](event/computer_command.md) event is fired when the `/computercraft queue` command is run for the current computer. 

[disk](event/disk.md)  The [`disk`](module/disk.md) event is fired when a disk is inserted into an adjacent or networked disk drive. 

[disk_eject](event/disk_eject.md)  The [`disk_eject`](event/disk_eject.md) event is fired when a disk is removed from an adjacent or networked disk drive. 

[file_transfer](event/file_transfer.md)  The [`file_transfer`](event/file_transfer.md) event is queued when a user drags-and-drops a file on an open computer. 

[http_check](event/http_check.md)  The [`http_check`](event/http_check.md) event is fired when a URL check finishes. 

[http_failure](event/http_failure.md)  The [`http_failure`](event/http_failure.md) event is fired when an HTTP request fails. 

[http_success](event/http_success.md)  The [`http_success`](event/http_success.md) event is fired when an HTTP request returns successfully. 

[key](event/key.md)  This event is fired when any key is pressed while the terminal is focused. 

[key_up](event/key_up.md)  Fired whenever a key is released (or the terminal is closed while a key was being pressed). 

[modem_message](event/modem_message.md)  The [`modem_message`](event/modem_message.md) event is fired when a message is received on an open channel on any [`modem`](peripheral/modem.md). 

[monitor_resize](event/monitor_resize.md)  The [`monitor_resize`](event/monitor_resize.md) event is fired when an adjacent or networked [monitor's](peripheral/monitor.md) size is changed. 

[monitor_touch](event/monitor_touch.md)  The [`monitor_touch`](event/monitor_touch.md) event is fired when an adjacent or networked [Advanced Monitor](peripheral/monitor.md) is right-clicked. 

[mouse_click](event/mouse_click.md)  This event is fired when the terminal is clicked with a mouse. 

[mouse_drag](event/mouse_drag.md)  This event is fired every time the mouse is moved while a mouse button is being held. 

[mouse_scroll](event/mouse_scroll.md)  This event is fired when a mouse wheel is scrolled in the terminal. 

[mouse_up](event/mouse_up.md)  This event is fired when a mouse button is released or a held mouse leaves the computer's terminal. 

[paste](event/paste.md)  The [`paste`](event/paste.md) event is fired when text is pasted into the computer through Ctrl-V (or ⌘V on Mac). 

[peripheral](event/peripheral.md)  The [`peripheral`](module/peripheral.md) event is fired when a peripheral is attached on a side or to a modem. 

[peripheral_detach](event/peripheral_detach.md)  The [`peripheral_detach`](event/peripheral_detach.md) event is fired when a peripheral is detached from a side or from a modem. 

[rednet_message](event/rednet_message.md)  The [`rednet_message`](event/rednet_message.md) event is fired when a message is sent over Rednet. 

[redstone](event/redstone.md)  The [`redstone`](event/redstone.md) event is fired whenever any redstone inputs on the computer or [relay](peripheral/redstone_relay.md) change. 

[setting_changed](event/setting_changed.md)  The [`setting_changed`](event/setting_changed.md) event is fired when a setting is modified with the [`settings`](module/settings.md) API. 

[speaker_audio_empty](event/speaker_audio_empty.md)  Return Values 

[task_complete](event/task_complete.md)  The [`task_complete`](event/task_complete.md) event is fired when an asynchronous task completes. 

[term_resize](event/term_resize.md)  The [`term_resize`](event/term_resize.md) event is fired when the main terminal is resized. 

[terminate](event/terminate.md)  The [`terminate`](event/terminate.md) event is fired when Ctrl-T is held down. 

[timer](event/timer.md)  The [`timer`](event/timer.md) event is fired when a timer started with [`os.startTimer`](module/os.md#v:startTimer) completes. 

[turtle_inventory](event/turtle_inventory.md)  The [`turtle_inventory`](event/turtle_inventory.md) event is fired when a turtle's inventory is changed. 

[websocket_closed](event/websocket_closed.md)  The [`websocket_closed`](event/websocket_closed.md) event is fired when an open WebSocket connection is closed. 

[websocket_failure](event/websocket_failure.md)  The [`websocket_failure`](event/websocket_failure.md) event is fired when a WebSocket connection request fails. 

[websocket_message](event/websocket_message.md)  The [`websocket_message`](event/websocket_message.md) event is fired when a message is received on an open WebSocket connection. 

[websocket_success](event/websocket_success.md)  The [`websocket_success`](event/websocket_success.md) event is fired when a WebSocket connection request returns successfully. 

## Guides

[Setting up GPS](guide/gps_setup.md)  The [`gps`](module/gps.md) API allows a computer to find its current position using a [wireless modem](peripheral/modem.md). 

[Allowing access to local IPs](guide/local_ips.md)  By default, ComputerCraft blocks access to local IP addresses for security. 

[Playing audio with speakers](guide/speaker_audio.md)  CC: Tweaked's speaker peripheral provides a powerful way to play any audio you like with the [`speaker.playAudio`](peripheral/speaker.md#v:playAudio) method. 

[Reusing code with require](guide/using_require.md)  A library is a collection of useful functions and other definitions which is stored separately to your main program. 

## Reference

[Block details](reference/block_details.md)  Several functions in CC: Tweaked, such as [`turtle.inspect`](module/turtle.md#v:inspect) and [`commands.getBlockInfo`](module/commands.md#v:getBlockInfo) provide a way to get information about a block in the world. 

[Incompatibilities between versions](reference/breaking_changes.md)  CC: Tweaked tries to remain as compatible between versions as possible, meaning most programs written for older versions... 

[The /computercraft command](reference/computercraft_command.md)  CC: Tweaked provides a `/computercraft` command for server owners to manage running computers on a server. 

[Lua 5.2/5.3 features in CC: Tweaked](reference/feature_compat.md)  CC: Tweaked is based off of the Cobalt Lua runtime, which uses Lua 5. 

[Item details](reference/item_details.md)  Several functions in CC: Tweaked, such as [`turtle.getItemDetail`](module/turtle.md#v:getItemDetail) and [`inventory.getItemDetail`](generic_peripheral/inventory.md#v:getItemDetail) provide a way to get information about an item stack. 

Last updated on 2026-04-07
