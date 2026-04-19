# energy_storage

Methods for interacting with blocks which store energy.

This works with energy storage blocks, as well as generators and machines which consume energy.

##### 🛈 note

Due to limitations with Forge's energy API, it is not possible to measure throughput (i.e. FE used/generated per
tick).

### Changes

- **New in version 1.94.0**

[getEnergy()](#v:getEnergy)  Get the energy of this block. 

[getEnergyCapacity()](#v:getEnergyCapacity)  Get the maximum amount of energy this block can store. 

[](#v:getEnergy)getEnergy()[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/common/src/main/java/dan200/computercraft/shared/peripheral/generic/methods/AbstractEnergyMethods.java#L42)

Get the energy of this block.

### Returns

1. `number` The energy stored in this block, in FE.

[](#v:getEnergyCapacity)getEnergyCapacity()[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/common/src/main/java/dan200/computercraft/shared/peripheral/generic/methods/AbstractEnergyMethods.java#L51)

Get the maximum amount of energy this block can store.

### Returns

1. `number` The energy capacity of this block.

Last updated on 2026-04-07
