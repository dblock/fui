# Releasing Fui

There are no hard rules about when to release fui. Release bug fixes frequently, features not so frequently, and breaking changes rarely.

Releases use [ruby-gem-release](https://github.com/dblock/ruby-gem-release) 0.9.0 through a manually dispatched [Release workflow](.github/workflows/release.yml). Keep the `ruby-gem-release` gem in [Gemfile](Gemfile) and the reusable workflow in `release.yml` pinned to the same version. The workflow publishes through RubyGems Trusted Publishing, so no RubyGems API key or one-time password is needed. It only runs from `master` in `dblock/fui`. The local Bundler `rake release`, `release:rubygem_push`, and `release:source_control_push` tasks are disabled.

## One-Time Setup

The [trusted publisher for fui](https://rubygems.org/gems/fui/trusted_publishers) is configured as a GitHub Actions publisher with repository owner `dblock`, repository `fui`, workflow filename `release.yml`, environment `release`, and the separate workflow repository owner `dblock` and repository `ruby-gem-release`.

GitHub creates the `release` environment in `dblock/fui` on the first dispatch. Restrict its deployment branches to `master`, and add required reviewers to require maintainer approval before publication. Allow GitHub Actions to push release commits and `v*` tags to `master`. See the upstream [setup and permissions guidance](https://github.com/dblock/ruby-gem-release/blob/v0.9.0/RELEASING.md#one-time-setup).

Verify the setup without publishing with a [dry run](https://github.com/dblock/ruby-gem-release/blob/v0.9.0/docs/actions/release.md#dry-run), which never edits files, builds, pushes, or publishes:

```sh
gh workflow run release.yml --repo dblock/fui --ref master -f dry-run=true
```

## Prepare

Start with a clean, up-to-date `master` and verify that the latest [CI checks](https://github.com/dblock/fui/actions) pass for all supported Ruby versions. Follow semantic versioning: patch for fixes, minor for backward-compatible features, major for breaking changes. Check `VERSION` in [lib/fui/version.rb](lib/fui/version.rb) and the matching `(Next)` heading in [CHANGELOG.md](CHANGELOG.md), and change both in a pull request if needed, or pass a `version` override when dispatching.

The workflow dates the `(Next)` heading using `YYYY/MM/DD` and removes the `* Your contribution here.` placeholder; a section without notes cannot be released.

Release automation requires MRI Ruby 3.3 or newer; the release dependency and tasks are skipped on older Ruby versions and JRuby. Release specs in [spec/release](spec/release) run the actual release tasks against a local fixture with the [ruby-gem-release RSpec helpers](https://github.com/dblock/ruby-gem-release/blob/v0.9.0/docs/testing.md), without contacting RubyGems or GitHub.

## Publish

```sh
gh workflow run release.yml --repo dblock/fui --ref master
```

Pass `-f version=x.y.z` to release a different version. Dispatching starts a real release; do not merge into `master` while it runs. The workflow prepares the release commit, runs lint and specs on Ruby 3.3, builds the gem, preserves recovery artifacts, publishes to RubyGems, pushes the release commit and `v` tag, and creates a GitHub Release with the changelog notes and the gem attached. It then increments the patch version, adds a new `(Next)` section, and pushes the next development commit. Verify the published version on [RubyGems](https://rubygems.org/gems/fui), the tag, the [GitHub Release](https://github.com/dblock/fui/releases), and the next development commit.

## Recover a Partial Release

Inspect the failed run, RubyGems, remote commits and tags, and the GitHub Release before retrying. Publication may have succeeded even if a later step failed. Never move a published tag or republish a version with different contents. Use the run's retained recovery artifacts and the upstream [recovery instructions](https://github.com/dblock/ruby-gem-release/blob/v0.9.0/docs/actions/release.md#recovery-artifacts).
