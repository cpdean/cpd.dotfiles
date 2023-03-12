Implementing `sd` in python.

Originally from [this post](https://ianthehenry.com/posts/a-cozy-nest-for-your-scripts/).


# Installation

1. Put it somewhere you'll remember it (and hopefully keep under vcs).

```
mkdir -p ~/.config/sd/
mv sd ~/.config/sd/
```

2. add it into your path. (linking it will save scripts to your bin dir. might mess up your vcs strategy)

```
export PATH=~/.config/sd/:$PATH
```

# Usage

It runs scripts found in `$(sd --bin-path)/bin/`.

```
> sd something foo bar

# runs ~/.config/sd/bin/something/foo/bar
```

You can edit (or add) a script.

```
> sd something foo bar --edit

# runs `$EDITOR $(sd --bin-path)/bin/something/foo/bar`
```

# Tutorial

Open a new script.

```
> sd whatever --edit
```

```
#!/usr/bin/env bash
echo running: $0 "\"$@\""
```

Run your new script.

```
> sd whatever
running: /../../sd/bin/whatever ""
```

Your script can take long-form arguments

```
> sd whatever --hello --there
running: /../../sd/bin/whatever "--hello --there"
```

## TODO
1. sd snapshot name of new command "!!"
2. sd --help : all the sd-level commands, followed by a tree-print of the sub commands and their docstring
3. fish completions
