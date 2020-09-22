# Manifests

TL;DR: `harness.exs` describes how a harness project should be rendered.

What's a manifest anyways? A manifest typically describes a _plan_. A `mix.exs`
is a kind of manifest. It describes which dependencies a project relies on,
how it should be compiled, configured, tested, documented, and published.
Notice, though, what a `mix.exs` _doesn't_ describe:

- an exact list of files to compile, test, or document
- an exact specification on dependency versions

For that information, you might have other more specific manifests or
_lockfiles_: files which lock exact information into place.

## Manifest Configuration

The harness manifest API piggy-backs off the elixir 1.9+ [Config
API](https://hexdocs.pm/elixir/master/Config.html).

A minimal `harness.exs` looks like so:

```elixir
import Config

config :harness,
  manifest_version: "2.0.0",
  generators: [],
  deps: []
```
