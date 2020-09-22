# Harness

A command line tool for harnessing Elixir boilerplate.

![Actions CI](https://github.com/NFIBrokerage/harness/workflows/Actions%20CI/badge.svg)

See the [hex guides](https://hexdocs.pm/harness/welcome.html#content)
for detail documentation.

## Development

Interested in developing harness? Currently it's in a tight spot because it
doesn't have any test cases. Your best bet for blessing harness is to build
and install harness archives locally and use the local installation to harness
packages like `harness_micro_controller`.

```
mix archive.uninstall harness --force
MIX_ENV=prod mix archive.build
mix archive.install harness-0.0.0.ez --force
```

## Installation

Harness is installed as an archive:

```
mix archive.install hex harness --force
```
