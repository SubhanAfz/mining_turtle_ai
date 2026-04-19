# pocket

Control the current pocket computer, adding or removing upgrades.

This API is only available on pocket computers. As such, you may use its presence to determine what kind of computer
you are using:

```
if [pocket ](pocket.md)then
 print("On a pocket computer")
else
 print("On something else")
end
```

## Recipes

**Pocket Computer**

![Stone](https://tweaked.cc/images/items/minecraft/stone.png)

![Stone](https://tweaked.cc/images/items/minecraft/stone.png)

![Stone](https://tweaked.cc/images/items/minecraft/stone.png)

![Stone](https://tweaked.cc/images/items/minecraft/stone.png)

![Golden Apple](https://tweaked.cc/images/items/minecraft/golden_apple.png)

![Stone](https://tweaked.cc/images/items/minecraft/stone.png)

![Stone](https://tweaked.cc/images/items/minecraft/stone.png)

![Glass Pane](https://tweaked.cc/images/items/minecraft/glass_pane.png)

![Stone](https://tweaked.cc/images/items/minecraft/stone.png)

![Pocket Computer](https://tweaked.cc/images/items/computercraft/pocket_computer_normal.png)

**Advanced Pocket Computer**

![Gold Ingot](https://tweaked.cc/images/items/minecraft/gold_ingot.png)

![Gold Ingot](https://tweaked.cc/images/items/minecraft/gold_ingot.png)

![Gold Ingot](https://tweaked.cc/images/items/minecraft/gold_ingot.png)

![Gold Ingot](https://tweaked.cc/images/items/minecraft/gold_ingot.png)

![Golden Apple](https://tweaked.cc/images/items/minecraft/golden_apple.png)

![Gold Ingot](https://tweaked.cc/images/items/minecraft/gold_ingot.png)

![Gold Ingot](https://tweaked.cc/images/items/minecraft/gold_ingot.png)

![Glass Pane](https://tweaked.cc/images/items/minecraft/glass_pane.png)

![Gold Ingot](https://tweaked.cc/images/items/minecraft/gold_ingot.png)

![Advanced Pocket Computer](https://tweaked.cc/images/items/computercraft/pocket_computer_advanced.png)

[equipBack()](#v:equipBack)  Search the player's inventory for another upgrade, replacing the existing one with that item if found. 

[unequipBack()](#v:unequipBack)  Remove the pocket computer's current upgrade. 

[](#v:equipBack)equipBack()[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/common/src/main/java/dan200/computercraft/shared/pocket/apis/PocketAPI.java#L63)

Search the player's inventory for another upgrade, replacing the existing one with that item if found.

This inventory search starts from the player's currently selected slot, allowing you to prioritise upgrades.

### Returns

1. `boolean` If an item was equipped.
2. [`string`](https://www.lua.org/manual/5.1/manual.html#5.4) | nil The reason an item was not equipped.

[](#v:unequipBack)unequipBack()[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/common/src/main/java/dan200/computercraft/shared/pocket/apis/PocketAPI.java#L94)

Remove the pocket computer's current upgrade.

### Returns

1. `boolean` If the upgrade was unequipped.
2. [`string`](https://www.lua.org/manual/5.1/manual.html#5.4) | nil The reason an upgrade was not unequipped.

Last updated on 2026-04-07
