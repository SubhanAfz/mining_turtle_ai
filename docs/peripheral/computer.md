# computer

A computer or turtle wrapped as a peripheral.

This allows for basic interaction with adjacent computers. Computers wrapped as peripherals will have the type
`computer` while turtles will be `turtle`.

[turnOn()](#v:turnOn)  Turn the other computer on. 

[shutdown()](#v:shutdown)  Shutdown the other computer. 

[reboot()](#v:reboot)  Reboot or turn on the other computer. 

[getID()](#v:getID)  Get the other computer's ID. 

[isOn()](#v:isOn)  Determine if the other computer is on. 

[getLabel()](#v:getLabel)  Get the other computer's label. 

[](#v:turnOn)turnOn()[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/common/src/main/java/dan200/computercraft/shared/computer/blocks/ComputerPeripheral.java#L37)

Turn the other computer on.

[](#v:shutdown)shutdown()[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/common/src/main/java/dan200/computercraft/shared/computer/blocks/ComputerPeripheral.java#L50)

Shutdown the other computer.

[](#v:reboot)reboot()[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/common/src/main/java/dan200/computercraft/shared/computer/blocks/ComputerPeripheral.java#L63)

Reboot or turn on the other computer.

[](#v:getID)getID()[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/common/src/main/java/dan200/computercraft/shared/computer/blocks/ComputerPeripheral.java#L79)

Get the other computer's ID.

### Returns

1. `number` The computer's ID.

### See also

- **[`os.getComputerID`](../module/os.md#v:getComputerID)** To get your computer's ID.

[](#v:isOn)isOn()[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/common/src/main/java/dan200/computercraft/shared/computer/blocks/ComputerPeripheral.java#L90)

Determine if the other computer is on.

### Returns

1. `boolean` If the computer is on.

[](#v:getLabel)getLabel()[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/common/src/main/java/dan200/computercraft/shared/computer/blocks/ComputerPeripheral.java#L102)

Get the other computer's label.

### Returns

1. [`string`](https://www.lua.org/manual/5.1/manual.html#5.4) | nil The computer's label.

### See also

- **[`os.getComputerLabel`](../module/os.md#v:getComputerLabel)** To get your label.

Last updated on 2026-04-07
