# Harness

![Actions CI](https://github.com/NFIBrokerage/harness/workflows/Actions%20CI/badge.svg)

harness the boilerplate!

> N.B. harness is just a concept for now

Harness simplifies writing tiny isolated services by dynamically generating
unecssary boilerplate files.

You might have a git repo for a µ controller that looks like this:

```
$ tree -a
.
├── .github
│   └── workflows
│       └── ci.yml
├── .gitignore
├── harnessfile.exs
├── mix.lock
└── my_plug.ex

2 directories, 5 files
```

but expands to a fully featured phoenix project with cool stuff like

- necessary `mix.exs` setup
- supervision tree
- observalibity tooling
- release configuration (`rel/config.exs`, `Docefile`)
- testing configuration (`coveralls.js`, `.credo.exs`)

and more(!) with a simple `mix harness`.

## What does it do?

In a directory with a harness-file (`harness.exs`), a run of `mix harness` will
generate a `.harness/` directory containing generated boilerplate, with the
`mix.exs` symlinked to the root of the git repository.

For example, the above repository would expand to

```
$ mix harness
$ tree -a
.
├── .github
│   └── workflows
│       └── ci.yml
├── .gitignore
├── .harness
│   ├── config
│   ├── lib
│   ├── mix.exs
│   ├── rel
│   └── test
├── harnessfile.exs
├── mix.exs -> .harness/mix.exs
├── mix.lock
└── my_plug.ex

7 directories, 7 files

```

after `mix harness`. Since the `.gitignore` ignores unecessary files, the git
repository ends up being as clean as the first snippet.

## Rationale

Harness lives to make starting new projects easy. Harness provides a way to
describe a common
[chassis](https://microservices.io/patterns/microservice-chassis.html) between
services.

#### Why not just code generation?

Generating static boilerplate files in a git repo is good: all generated files
are likely to be consistent and fully-featured with minimal effort from the
service author(s).

As these generated files age, though, they become difficult to maintain across
many repositories. They suffer from the common DRY gripe: once code is
duplicated, you'll need to update it twice to be consistent.

Harness seeks to expand on static code generation by making it lazy and
dynamic.
