Fui
==========

[![Gem Version](https://badge.fury.io/rb/fui.svg)](https://badge.fury.io/rb/fui)
[![Build Status](https://travis-ci.org/dblock/fui.svg)](https://travis-ci.org/dblock/fui)

Find unused Objective-C imports.

# Table of Contents

- [Usage](#usage)
  - [Get Help](#get-help)
  - [Find Unused Classes in the Current Directory](#find-unused-classes-in-the-current-directory)
  - [Find Unused Classes in any Path](#find-unused-classes-in-any-path)
  - [Skip Interface Builder (.xib) Files](#skip-interface-builder-xib-files)
  - [Ignore Local Imports](#ignore-local-imports)
  - [Ignore Global Imports](#ignore-global-imports)
  - [Ignore a Path](#ignore-a-path)
  - [Ignore Multiple Paths](#ignore-multiple-paths)
  - [Delete All Unused Class Files with Prompt](#delete-all-unused-class-files-with-prompt)
- [Xcode Plugin](#xcode-plugin)
- [Contributing](#contributing)
- [Copyright and License](#copyright-and-license)

## Usage

```sh
gem install fui
```

### Get Help

```sh
fui help
```

### Find Unused Classes in the Current Directory

```sh
fui find
```

The `find` command lists all the files that contain unused imports and exits with the number of files found.

### Find Unused Classes in any Path

```sh
fui --path=~/source/project/Name find
```

### Skip Interface Builder (.xib) Files

Running `fui` with `-x` (or `--ignore-xib-files`) will, for example, mark `Foo.h` as unused when `Foo.xib` holds a reference to the `Foo` class and no other references to Foo.h exist.

```sh
fui -x --path=~/source/project/Name find
```

### Ignore Local Imports

Running `fui` with `-l` (or `--ignore-local-imports`) will, for example, mark `Foo.h` as unused when `Bar.h` contains a local (quotation syntax) import of `Foo.h` (eg. `#import Foo.h`).

```sh
fui -l --path=~/source/project/Name find
```

### Ignore Global Imports

Running `fui` with `-g` (or `--ignore-global-imports`) will, for example, mark `Foo.h` as unused when `Bar.h` contains a global (bracket syntax) import of `Foo.h` (eg. `#import <Framework/Foo.h>`).

```sh
fui -g --path=~/source/project/Name find
```

### Ignore a Path

Running `fui` with `-i` (or `--ignore-path`) will, for example, ignore a `Pods` folder when searching for headers or referencing files.

```sh
fui --path=~/source/project/Name --ignore-path=Pods find
```

### Ignore Multiple Paths

Running `fui` with `-i` (or `--ignore-path`) can ignore multiple folders when searching for headers or referencing files.

```sh
fui --path=~/source/project/Name --ignore-path=Pods --ignore-path=Libraries find
```

### Delete All Unused Class Files with Prompt

```sh
fui --path=~/source/project/Name delete --perform --prompt
```

## Xcode Plugin

Use [xcfui](https://github.com/jcavar/xcfui) for integration with Xcode.

## Contributing

There're [a few feature requests and known issues](https://github.com/dblock/fui/issues). Please contribute! See [CONTRIBUTING](CONTRIBUTING.md).

## Copyright and License

Copyright (c) 2014-2018, Daniel Doubrovkine, [Artsy](http://artsy.github.io), based on code by [Dustin Barker](https://github.com/dstnbrkr).

This project is licensed under the [MIT License](LICENSE.md).
