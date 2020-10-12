# Mix Dependencies

Some harness packages write a `mix.exs` file which controls compilation,
configuration, testing, and dependency options.

## Installing/updating relay_commands and/or events

Instead of adding the events and relay_commands dependencies to the `mix.exs` 
file like we would normally do, we add it to the list of `explicit_dependencies` 
in the `harness.exs` file.

Example:

```elixir
config :harness_aggregate,
  ..
  explicit_dependencies: [
    {:relay_commands, "== 0.0.625", organization: "cuatro"},
    {:events, "== 0.0.900", organization: "cuatro"},
  ],
  ..
```

Then to get these dependencies:

```
mix harness
mix deps.get
```
