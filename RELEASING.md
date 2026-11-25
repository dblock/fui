# Releasing Fui

There are no hard rules about when to release fui. Release bug fixes frequently, features not so frequently, and breaking changes rarely.

## Release

Run tests, check that all tests succeed locally.

```sh
bundle install
bundle exec rake
```

Check that the last build succeeded in [GitHub Actions](https://github.com/dblock/fui/actions).

Change "Next" in [CHANGELOG.md](CHANGELOG.md) to the current date.

```markdown
### 0.4.0 (2016/5/14)
```

Remove the line with "Your contribution here.", since there will be no more contributions to this release.

Commit your changes.

```sh
git add CHANGELOG.md
git commit -m "Preparing for release, 0.4.0."
git push origin master
```

Release.

```text
$ rake release

fui 0.4.0 built to pkg/fui-0.4.0.gem.
Tagged v0.4.0.
Pushed git commits and tags.
Pushed fui 0.4.0 to rubygems.org.
```

## Prepare for the Next Version

Add the next release to [CHANGELOG.md](CHANGELOG.md).

```markdown
### 0.4.1 (Next)

* Your contribution here.
```

Increment the third version number in [lib/fui/version.rb](lib/fui/version.rb).

Commit your changes.

```sh
git add CHANGELOG.md lib/fui/version.rb
git commit -m "Preparing for next development iteration, 0.4.1."
git push origin master
```
