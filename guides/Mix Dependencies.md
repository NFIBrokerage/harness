# Mix Dependencies

Many harness packages write a `mix.exs` file which controls compilation,
configuration, testing, and dependency options.

## Installing/updating relay_commands and/or events

Instead of adding the events and relay_commands dependencies to the `mix.exs` 
file like we would normally do, we add it to the list of `explicit_dependencies` 
in the `harness.exs` file.

Example:
```
config :harness_aggregate,
  app: :planning_schedule,
  aggregate_type: "planning.schedule",
  instance_id: :schedule_id,
  explicit_dependencies: [
    {:relay_commands, "== 0.0.625", organization: "cuatro"},
    {:events, "== 0.0.900", organization: "cuatro"},
  ]
```

Then, to get the `mix.lock` file to update, run `mix harness` followed by `mix deps.get`.  
Whenever you need to update these explicit deps, always run `mix harness` 
and then `mix deps.get`.
