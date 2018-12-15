Fui
==========

[![Gem Version](https://badge.fury.io/rb/fui.svg)](https://badge.fury.io/rb/fui)
[![Build Status](https://travis-ci.org/dblock/fui.svg)](https://travis-ci.org/dblock/fui)

Find unused Objective-C imports.

## Usage

```
gem install fui
```

#### Get Help

```
fui help
```

#### Find Unused Classes in the Current Directory

```
fui find
```

The `find` command lists all the files that contain unused imports and exits with the number of files found.

#### Find Unused Classes in a Path

```
fui --path=~/source/project/Name find
```

#### Find Unused Classes in a Path Skipping Interface Builder (.xib) Files

Running `fui` with `-x` (or `--ignore-xib-files`) will, for example, mark `Foo.h` as unused when `Foo.xib` holds a reference to the `Foo` class and no other references to Foo.h exist.

```
fui -x --path=~/source/project/Name find
```

#### Find Unused Classes in a Path Ignoring Local (quotation syntax) Imports

Running `fui` with `-l` (or `--ignore-local-imports`) will, for example, mark `Foo.h` as unused when `Bar.h` contains a local import of `Foo.h` (`#import Foo.h`)

```
fui -l --path=~/source/project/Name find
```

#### Find Unused Classes in a Path Ignoring Global (bracket syntax) Imports

Running `fui` with `-g` (or `--ignore-global-imports`) will, for example, mark `Foo.h` as unused when `Bar.h` contains a global import of `Foo.h` (`#import <Framework/Foo.h>`)

```
fui -g --path=~/source/project/Name find
```

#### Find Unused Classes in a Path And Also Ignoring a Path

Running `fui` with `-i` (or `--ignore-path`) will, for example, ignore a `Pods` folder when searching for headers or referencing files

```
fui --path=~/source/project/Name --ignore-path=Pods find
```

#### Find Unused Classes in a Path And Also Ignoring Multiple Paths

Running `fui` with `-i` (or `--ignore-path`) can ignore multiple folders when searching for headers or referencing files

```
fui --path=~/source/project/Name --ignore-path=Pods --ignore-path=Libraries find
```

#### Delete All Unused Class Files w/ Prompt

```
fui --path=~/source/project/Name delete --perform --prompt
```

#### Xcode Plugin

Use [xcfui](https://github.com/jcavar/xcfui) for integration with Xcode.

## Contributing

There're [a few feature requests and known issues](https://github.com/dblock/fui/issues). Please contribute! See [CONTRIBUTING](CONTRIBUTING.md).

## Copyright and License

Copyright (c) 2014-2018, Daniel Doubrovkine, [Artsy](http://artsy.github.io), based on code by [Dustin Barker](https://github.com/dstnbrkr).

This project is licensed under the [MIT License](LICENSE.md).
