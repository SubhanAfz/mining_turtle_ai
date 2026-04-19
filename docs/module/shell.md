# shell

The shell API provides access to CraftOS's command line interface.

It allows you to [start programs](shell.md#v:run), [add completion for a
program](shell.md#v:setCompletionFunction), and much more.

[`shell`](shell.md) is not a "true" API. Instead, it is a standard program, which injects
its API into the programs that it launches. This allows for multiple shells to
run at the same time, but means that the API is not available in the global
environment, and so is unavailable to other [APIs](os.md#v:loadAPI).

## Programs and the program path

When you run a command with the shell, either from the prompt or
[from Lua code](shell.md#v:run), the shell API performs several steps to work out
which program to run:

1. 

Firstly, the shell attempts to resolve [aliases](shell.md#v:aliases). This allows
us to use multiple names for a single command. For example, the `list`
program has two aliases: `ls` and `dir`. When you write `ls /rom`, that's
expanded to `list /rom`.

2. 

Next, the shell attempts to find where the program actually is. For this, it
uses the [program path](shell.md#v:path). This is a colon separated list of
directories, each of which is checked to see if it contains the program.

`list` or `list.lua` doesn't exist in `.` (the current directory), so the
shell now looks in `/rom/programs`, where `list.lua` can be found!

3. 

Finally, the shell reads the file and checks if the file starts with a
`#!`. This is a [hashbang](https://en.wikipedia.org/wiki/Shebang_(Unix)), which says that this file shouldn't be treated
as Lua, but instead passed to *another* program, the name of which should
follow the `#!`.

### Changes

- **Changed in version 1.103.0:** Added support for hashbangs.

[execute(command, ...)](#v:execute)  Run a program with the supplied arguments. 

[run(...)](#v:run)  Run a program with the supplied arguments. 

[exit()](#v:exit)  Exit the current shell. 

[dir()](#v:dir)  Return the current working directory. 

[setDir(dir)](#v:setDir)  Set the current working directory. 

[path()](#v:path)  Get the path where programs are located. 

[setPath(path)](#v:setPath)  Set the [current program path](shell.md#v:path). 

[resolve(path)](#v:resolve)  Resolve a relative path to an absolute path. 

[resolveProgram(command)](#v:resolveProgram)  Resolve a program, using the [program path](shell.md#v:path) and list of [aliases](shell.md#v:aliases). 

[programs([include_hidden])](#v:programs)  Return a list of all programs on the [path](shell.md#v:path). 

[complete(sLine)](#v:complete)  Complete a shell command line. 

[completeProgram(program)](#v:completeProgram)  Complete the name of a program. 

[setCompletionFunction(program, complete)](#v:setCompletionFunction)  Set the completion function for a program. 

[getCompletionInfo()](#v:getCompletionInfo)  Get a table containing all completion functions. 

[getRunningProgram()](#v:getRunningProgram)  Returns the path to the currently running program. 

[setAlias(command, program)](#v:setAlias)  Add an alias for a program. 

[clearAlias(command)](#v:clearAlias)  Remove an alias. 

[aliases()](#v:aliases)  Get the current aliases for this shell. 

[openTab(...)](#v:openTab)  Open a new [`multishell`](multishell.md) tab running a command. 

[switchTab(id)](#v:switchTab)  Switch to the [`multishell`](multishell.md) tab with the given index. 

[](#v:execute)execute(command, ...)[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/resources/data/computercraft/lua/rom/programs/shell.lua#L209)

Run a program with the supplied arguments.

Unlike [`shell.run`](shell.md#v:run), each argument is passed to the program verbatim. While
`shell.run("echo", "b c")` runs `echo` with `b` and `c`,
`shell.execute("echo", "b c")` runs `echo` with a single argument `b c`.

### Parameters

1. command[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The program to execute.
2. ...[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) Arguments to this program.

### Returns

1. `boolean` Whether the program exited successfully.

### Usage

- 

Run `paint my-image` from within your program:

```
[shell.execute](shell.md#v:execute)("paint", "my-image")
```

### Changes

- **New in version 1.88.0**

[](#v:run)run(...)[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/resources/data/computercraft/lua/rom/programs/shell.lua#L263)

Run a program with the supplied arguments.

All arguments are concatenated together and then parsed as a command line. As
a result, `shell.run("program a b")` is the same as `shell.run("program", "a", "b")`.

### Parameters

1. ...[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The program to run and its arguments.

### Returns

1. `boolean` Whether the program exited successfully.

### Usage

- 

Run `paint my-image` from within your program:

```
[shell.run](shell.md#v:run)("paint", "my-image")
```

### See also

- **[`shell.execute`](shell.md#v:execute)** Run a program directly without parsing the arguments.

### Changes

- **Changed in version 1.80pr1:** Programs now get their own environment instead of sharing the same one.
- **Changed in version 1.83.0:**`arg` is now added to the environment.

[](#v:exit)exit()[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/resources/data/computercraft/lua/rom/programs/shell.lua#L277)

Exit the current shell.

This does *not* terminate your program, it simply makes the shell terminate
after your program has finished. If this is the toplevel shell, then the
computer will be shutdown.

[](#v:dir)dir()[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/resources/data/computercraft/lua/rom/programs/shell.lua#L287)

Return the current working directory. This is what is displayed before the
`> ` of the shell prompt, and is used by [`shell.resolve`](shell.md#v:resolve) to handle relative
paths.

### Returns

1. [`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The current working directory.

### See also

- **[`setDir`](shell.md#v:setDir)** To change the working directory.

[](#v:setDir)setDir(dir)[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/resources/data/computercraft/lua/rom/programs/shell.lua#L298)

Set the current working directory.

### Parameters

1. dir[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The new working directory.

### Throws

- 

If the path does not exist or is not a directory.

### Usage

- 

Set the working directory to "rom"

```
[shell.setDir](shell.md#v:setDir)("rom")
```

[](#v:path)path()[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/resources/data/computercraft/lua/rom/programs/shell.lua#L315)

Get the path where programs are located.

The path is composed of a list of directory names in a string, each separated
by a colon (`:`). On normal turtles will look in the current directory (`.`),
`/rom/programs` and `/rom/programs/turtle` folder, making the path
`.:/rom/programs:/rom/programs/turtle`.

### Returns

1. [`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The current shell's path.

### See also

- **[`setPath`](shell.md#v:setPath)** To change the current path.

[](#v:setPath)setPath(path)[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/resources/data/computercraft/lua/rom/programs/shell.lua#L326)

Set the [current program path](shell.md#v:path).

Be careful to prefix directories with a `/`. Otherwise they will be searched
for from the [current directory](shell.md#v:dir), rather than the computer's root.

### Parameters

1. path[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The new program path.

### Changes

- **New in version 1.2**

[](#v:resolve)resolve(path)[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/resources/data/computercraft/lua/rom/programs/shell.lua#L343)

Resolve a relative path to an absolute path.

The [`fs`](fs.md) and [`io`](io.md) APIs work using absolute paths, and so we must convert
any paths relative to the [current directory](shell.md#v:dir) to absolute ones. This
does nothing when the path starts with `/`.

### Parameters

1. path[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The path to resolve.

### Usage

- 

Resolve `startup.lua` when in the `rom` folder.

```
[shell.setDir](shell.md#v:setDir)("rom")
print([shell.resolve](shell.md#v:resolve)("startup.lua"))
-- => rom/startup.lua
```

[](#v:resolveProgram)resolveProgram(command)[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/resources/data/computercraft/lua/rom/programs/shell.lua#L374)

Resolve a program, using the [program path](shell.md#v:path) and list of [aliases](shell.md#v:aliases).

### Parameters

1. command[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The name of the program

### Returns

1. [`string`](https://www.lua.org/manual/5.1/manual.html#5.4) | nil The absolute path to the program, or `nil` if it could
not be found.

### Usage

- 

Locate the `hello` program.

```
[ shell.resolveProgram](shell.md#v:resolveProgram)("hello")
 -- => rom/programs/fun/hello.lua
```

### Changes

- **New in version 1.2**
- **Changed in version 1.80pr1:** Now searches for files with and without the `.lua` extension.

[](#v:programs)programs([include_hidden])[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/resources/data/computercraft/lua/rom/programs/shell.lua#L419)

Return a list of all programs on the [path](shell.md#v:path).

### Parameters

1. include_hidden?`boolean` Include hidden files. Namely, any which
start with `.`.

### Returns

1. { [`string`](https://www.lua.org/manual/5.1/manual.html#5.4) } A list of available programs.

### Usage

- 

```
[textutils.tabulate](textutils.md#v:tabulate)([shell.programs](shell.md#v:programs)())
```

### Changes

- **New in version 1.2**

[](#v:complete)complete(sLine)[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/resources/data/computercraft/lua/rom/programs/shell.lua#L533)

Complete a shell command line.

This accepts an incomplete command, and completes the program name or
arguments. For instance, `l` will be completed to `ls`, and `ls ro` will be
completed to `ls rom/`.

Completion handlers for your program may be registered with
[`shell.setCompletionFunction`](shell.md#v:setCompletionFunction).

### Parameters

1. sLine[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The input to complete.

### Returns

1. { [`string`](https://www.lua.org/manual/5.1/manual.html#5.4) } | nil The list of possible completions.

### See also

- **[`_G.read`](_G.md#v:read)** For more information about completion.
- **[`shell.completeProgram`](shell.md#v:completeProgram)**
- **[`shell.setCompletionFunction`](shell.md#v:setCompletionFunction)**
- **[`shell.getCompletionInfo`](shell.md#v:getCompletionInfo)**

### Changes

- **New in version 1.74**

[](#v:completeProgram)completeProgram(program)[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/resources/data/computercraft/lua/rom/programs/shell.lua#L575)

Complete the name of a program.

### Parameters

1. program[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The name of a program to complete.

### Returns

1. { [`string`](https://www.lua.org/manual/5.1/manual.html#5.4) } A list of possible completions.

### See also

- **[`cc.shell.completion.program`](../library/cc.shell.completion.md#v:program)**

[](#v:setCompletionFunction)setCompletionFunction(program, complete)[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/resources/data/computercraft/lua/rom/programs/shell.lua#L609)

Set the completion function for a program. When the program is entered on
the command line, this program will be called to provide auto-complete
information.

The completion function accepts four arguments:

1. The current shell. As completion functions are inherited, this is not
guaranteed to be the shell you registered this function in.
2. The index of the argument currently being completed.
3. The current argument. This may be the empty string.
4. A list of the previous arguments.

For instance, when completing `pastebin put rom/st` our pastebin completion
function will receive the shell API, an index of 2, `rom/st` as the current
argument, and a "previous" table of `{ "put" }`. This function may then wish
to return a table containing `artup.lua`, indicating the entire command
should be completed to `pastebin put rom/startup.lua`.

You completion entries may also be followed by a space, if you wish to
indicate another argument is expected.

### Parameters

1. program[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The path to the program. This should be an absolute path
*without* the leading `/`.
2. completefunction(shell: [`table`](https://www.lua.org/manual/5.1/manual.html#5.5), index: `number`, argument: [`string`](https://www.lua.org/manual/5.1/manual.html#5.4), previous: { [`string`](https://www.lua.org/manual/5.1/manual.html#5.4) }):{ [`string`](https://www.lua.org/manual/5.1/manual.html#5.4) } | nil The completion function.

### See also

- **[`cc.shell.completion`](../library/cc.shell.completion.md)** Various utilities to help with writing completion functions.
- **[`shell.complete`](shell.md#v:complete)**
- **[`_G.read`](_G.md#v:read)** For more information about completion.

### Changes

- **New in version 1.74**

[](#v:getCompletionInfo)getCompletionInfo()[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/resources/data/computercraft/lua/rom/programs/shell.lua#L624)

Get a table containing all completion functions.

This should only be needed when building custom shells. Use
[`setCompletionFunction`](shell.md#v:setCompletionFunction) to add a completion function.

### Returns

1. { [[`string`](https://www.lua.org/manual/5.1/manual.html#5.4)] = { fnComplete = `function` } } A table mapping the
absolute path of programs, to their completion functions.

[](#v:getRunningProgram)getRunningProgram()[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/resources/data/computercraft/lua/rom/programs/shell.lua#L632)

Returns the path to the currently running program.

### Returns

1. [`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The absolute path to the running program.

### Changes

- **New in version 1.3**

[](#v:setAlias)setAlias(command, program)[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/resources/data/computercraft/lua/rom/programs/shell.lua#L647)

Add an alias for a program.

### Parameters

1. command[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The name of the alias to add.
2. program[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The name or path to the program.

### Usage

- 

Alias `vim` to the `edit` program

```
[shell.setAlias](shell.md#v:setAlias)("vim", "edit")
```

### Changes

- **New in version 1.2**

[](#v:clearAlias)clearAlias(command)[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/resources/data/computercraft/lua/rom/programs/shell.lua#L656)

Remove an alias.

### Parameters

1. command[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The alias name to remove.

[](#v:aliases)aliases()[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/resources/data/computercraft/lua/rom/programs/shell.lua#L672)

Get the current aliases for this shell.

Aliases are used to allow multiple commands to refer to a single program. For
instance, the `list` program is aliased to `dir` or `ls`. Running `ls`, `dir`
or `list` in the shell will all run the `list` program.

### Returns

1. { [[`string`](https://www.lua.org/manual/5.1/manual.html#5.4)] = [`string`](https://www.lua.org/manual/5.1/manual.html#5.4) } A table, where the keys are the names of
aliases, and the values are the path to the program.

### See also

- **[`shell.setAlias`](shell.md#v:setAlias)**
- **[`shell.resolveProgram`](shell.md#v:resolveProgram)** This uses aliases when resolving a program name to
an absolute path.

[](#v:openTab)openTab(...)[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/resources/data/computercraft/lua/rom/programs/shell.lua#L698)

Open a new [`multishell`](multishell.md) tab running a command.

This behaves similarly to [`shell.run`](shell.md#v:run), but instead returns the process
index.

This function is only available if the [`multishell`](multishell.md) API is.

### Parameters

1. ...[`string`](https://www.lua.org/manual/5.1/manual.html#5.4) The command line to run.

### Returns

1. `number` The ID of the new tab that was opened.

### Usage

- 

Launch the Lua interpreter and switch to it.

```
local id = [shell.openTab](shell.md#v:openTab)("lua")
[shell.switchTab](shell.md#v:switchTab)(id)
```

### See also

- **[`shell.run`](shell.md#v:run)**
- **[`multishell.launch`](multishell.md#v:launch)**

### Changes

- **New in version 1.6**

[](#v:switchTab)switchTab(id)[Source](https://github.com/cc-tweaked/CC-Tweaked/blob/db32ddfec5e8c2bdefb3232b471328a3e92cc43f/projects/core/src/main/resources/data/computercraft/lua/rom/programs/shell.lua#L718)

Switch to the [`multishell`](multishell.md) tab with the given index.

### Parameters

1. id`number` The tab to switch to.

### See also

- **[`multishell.setFocus`](multishell.md#v:setFocus)**

### Changes

- **New in version 1.6**

Last updated on 2026-04-07
