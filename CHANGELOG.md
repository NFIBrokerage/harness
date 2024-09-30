# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a
Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 0.8.3 - 2024-09-25

### Fixed

- Makes sure all harness archive tasks are loaded and available to use

## 0.8.2 - 2024-03-18

### Changed

- Updated `actions/checkout@` from `v3` to `v4` in GH actions
- Updated `actions/cache@` from `v3` to `v4` in GH actions
- Updated `NFIBrokerage/create-release@` from `v3` to `v4` in GH actions

## 0.8.1 - 2023-08-24

### Changed

- Updated `actions/checkout@` from `v1` to `v3` in GH actions
- Updated `actions/cache@` from `v1` to `v3` in GH actions
- Updated `NFIBrokerage/create-release@` from `v2` to `v3` in GH actions
- Change `release_name` to `name` field in `NFIBrokerage/create-release@v3`
  action in GH actions
- Fixed credo warnings

## 0.8.0 - 2023-08-09

### Fixed

- This version fixes warnings and errors encountered when using `harness` with
  Elixir 1.15
    - added harness archive ebin path to VM path list because Elixir 1.15
      prunes code paths before compiling
    - `EEx.eval_string/3` is now used instead of `EEx.eval_file/3` when
      rendering templates with import of `Harness.Renderer.Helpers` functions
      being appended to every template binary because passing `:functions` in
      options is deprecated since Elixir 1.13

## 0.7.3 - 2023-04-05

### Changed

- Updated `hackney` from 1.16 to 1.18.1
- Pinned ubuntu runner to `ubuntu-20.04` in workflows because of OTP 22.3

## 0.7.2 - 2021-11-29

### Fixed

- Fixed compatibility with older elixir versions

## 0.7.1 - 2021-11-29

### Fixed

- Eliminated raise when harness packages were not yet compiled when calling `mix harness`

## 0.7.0 - 2021-11-26

### Added

- Added a `mix harness.loadpaths` Mix Task that mirrors `mix deps.loadpaths`
    - this task loads, compiles, and checks harness packages to ensure that
      they are up to date and can be installed
- Added `--no-compile` and `--no-deps-check` flags to `mix harness` task

## 0.6.2 - 2021-03-17

### Fixed

- Trimmed strings in the `inspect_or_interpolate/1` helper
    - this prevents formatting failures when a template does not expect a
      newline and a manifest declares a value with triple-quotes

## 0.6.1 - 2021-03-08

### Fixed

- Replaced usages of `Keyword.pop!/2` with `Keyword.pop/3`
    - This fixes compilation on Elixir 1.9

## 0.6.0 - 2021-03-03

### Added

- Added a `mix harness.check` task which checks that the harnessed files are
  up to date

## 0.5.0 - 2021-02-24

### Added

- Added support for hard linking to files in `.harness`
- Updated the `Harness.Pkg` behaviour to declare links with a tuple that
  includes the link type `:sym` or `:hard`
    - e.g. `{"mix.exs", :sym}` or `{".github/workflows/ci.yml", :hard}`

## 0.4.0 - 2021-02-19

### Added

- Added a `config :harness, :version` key which checks the version of harness
  and ensures that a manifest is only rendered if the harness version matches

## 0.3.0 - 2021-02-17

### Added

- Added a `:skip_files` key to the configuration of a manifest, allowing one
  to provide a list of regex which will be checked against while sourcing files.
  Any files found to match any of the regex will be excluded from generation.
    - this allows a service author to 'take the reins' for that file

## 0.2.9 - 2020-11-02

### Fixed

- Fixed a broken link to the Getting Started guide from the About guide

## 0.2.8 - 2020-10-15

### Added

- Added a `mix harness.update` task that mimics `mix deps.update`

## 0.2.7 - 2020-10-15

### Fixed

- Misc. documentation fixes including:
    - a broken link to the Getting Started guide
    - addition of GitHub and Changelog links to hex page
    - default documentation page is set to the README

## 0.2.6 - 2020-10-12

### Fixed

- Fixed a bug present when running `mix harness.compile` in Elixir 1.11+

## 0.2.5 - 2020-10-06

### Changed

- Harness now explicitly depends on `:eex` as an extra_application
    - this resolves compilation warnings on elixir 1.11+

## 0.2.4 - 2020-10-05

### Changed

- Generated files are now formatted to a column width of 80

## 0.2.3 - 2020-09-22

### Changed

- Harness is now published to public hex

## 0.2.2 - 2020-08-30

### Added

- `Kernel` functions are now imported for templates by default.
    - e.g. `==/2` or `inspect/2`

## 0.2.1 - 2020-08-27

### Fixed

- Fixed a bug where multiple copies of the same directory would show if the
  directory contained multiple files to be linked

## 0.2.0 - 2020-08-26

### Changed

- Manifests are now written with the [Config
  API](https://hexdocs.pm/elixir/1.10.4/Config.html#content)
    - therefore the manifest version has increased to v2.0.0
- As a result of the above, harness now requires at least Elixir 1.9 for
  compatibility

## 0.1.2 - 2020-08-25

### Added

- A function to interpolate or inspect items into a template

## 0.1.1 - 2020-08-25

### Added

- Elixir LS files are now ignored from generation

## 0.1.0 - 2020-08-25

### Added

- Improvements to display. First stable-ish release

## 0.0.1 - 2020-08-24

### Added

- Vim swap files are now ignored from template directories

### Fixed

- The harness project is reloaded after `mix harness.compile` when running `mix
  harness`
    - this fixes an issue where otp app atoms could not be determined on clean
      harness runs, as in CI

### Removed

- The `Harness.Cache` module has been removed
    - now harness caches packages by downloading them to the `deps/` directory
    - this behaviour mimics `mix`

## 0.0.0 - 2020-08-24

### Added

- Initial dependency management and generation abilities

## initial commit - 2020-08-19

### Added

- This project was generated by Gaas

<!-- # Generated by Elixir.Gaas.Generators.Simple.Library.Changelog -->
