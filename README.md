Fui
==========

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

#### Delete All Unused Class Files w/ Prompt

```
fui --path=~/source/project/Name delete --perform --prompt
```

#### XCode Plugin

Use [xcfui](https://github.com/jcavar/xcfui) for integration with XCode.

## Contributing

There're [a few feature requests and known issues](https://github.com/dblock/fui/issues). Please contribute! See [CONTRIBUTING](CONTRIBUTING.md).

## Copyright and License

Copyright (c) 2014, Daniel Doubrovkine, [Artsy](http://artsy.github.io), based on code by [Dustin Barker](https://github.com/dstnbrkr).

This project is licensed under the [MIT License](LICENSE.md).
