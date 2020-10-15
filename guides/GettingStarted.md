# Getting Started

Let's get going!

First, you need a recent version of elixir (`~> 1.9`). Consider trying
[`asdf`](https://github.com/asdf-vm/asdf) as a language version management
tool. Now install harness:

```shell
mix archive.install hex harness --force
```

Run `mix help harness` to verify installation.

## Making a harness project

There are a few components that make up a harnessed repository.

Like a regular mix project, a harness project typically has:

- `lib/` containing your application-space code
- `test/` unit tests for application-space code in `lib/`
- `config/` configuration

But none of these are requirements for harness. For a harness project, all you
really need is a [harness manifest](guides/Manifests.md).

Once you have a manifest, a run of `mix harness.get` in that directory will
fetch harness packages (think dependencies), and then a run of `mix harness`
will render the project.

## Example: a micro controller

Say that we have a tiny service in our stack called a micro (µ) controller.
It's a single phoenix controller (in reality, just a plug) that handles a
request and performs some action. Setting up a whole service chassis for a
service this small might be annoying, but with a well-groomed harness micro
controller package, it can be quite simple.

Say you have a git repo for a µ controller that looks like this:

```shell
$ tree -a -I '.git'
.
├── .github
│   ├── settings.yml
│   ├── stale.yml
│   └── workflows
│       └── ci.yml
├── .gitignore
├── README.md
├── config
│   ├── config.exs
│   ├── dev.exs
│   ├── prod.exs
│   └── test.exs
├── harness.exs
├── lib
│   ├── access_token_controller.ex
│   ├── access_token_fetcher.ex
│   └── access_token_verifier.ex
├── mix.lock
└── test
    ├── access_token_controller_test.exs
    └── support
        └── mocks.ex

6 directories, 16 files
```

In a directory with a harness-file (`harness.exs`), a run of `mix harness` will
generate a `.harness/` directory containing generated boilerplate, with the
necessary symlinking and path adjusting to make the project run like a normal
phoenix project.

For example, the above repository would expand to something like:

```shell
$ mix harness
$ tree -a -I '.git|_build|deps|.elixir_ls|cover'
.
├── .credo.exs -> .harness/.credo.exs
├── .dockerignore -> .harness/.dockerignore
├── .formatter.exs -> .harness/.formatter.exs
├── .github
│   ├── settings.yml
│   ├── stale.yml
│   └── workflows
│       └── ci.yml
├── .gitignore
├── .harness
│   ├── .credo.exs
│   ├── .dockerignore
│   ├── .formatter.exs
│   ├── .tool-versions
│   ├── Dockerfile
│   ├── config
│   │   ├── config.exs
│   │   ├── dev.exs
│   │   ├── prod.exs
│   │   └── test.exs
│   ├── coveralls.json
│   ├── lib
│   │   ├── authentication_service_access_token_controller
│   │   │   └── application.ex
│   │   ├── authentication_service_access_token_controller_web
│   │   │   ├── channels
│   │   │   ├── controllers
│   │   │   │   └── version_controller.ex
│   │   │   ├── endpoint.ex
│   │   │   ├── gettext.ex
│   │   │   ├── router.ex
│   │   │   └── views
│   │   │       ├── error_helpers.ex
│   │   │       └── error_view.ex
│   │   └── authentication_service_access_token_controller_web.ex
│   ├── mix.exs
│   ├── rel
│   │   └── config.exs
│   └── test
│       ├── authentication_service_access_token_controller_web
│       │   ├── controllers
│       │   │   └── version_controller_test.exs
│       │   ├── live
│       │   └── views
│       │       └── error_view_test.exs
│       ├── support
│       │   ├── conn_case.ex
│       │   └── mock_release_handler.ex
│       └── test_helper.exs
├── .tool-versions -> .harness/.tool-versions
├── README.md
├── config
│   ├── config.exs
│   ├── dev.exs
│   ├── prod.exs
│   └── test.exs
├── coveralls.json -> .harness/coveralls.json
├── harness.exs
├── lib
│   ├── access_token_controller.ex
│   ├── access_token_fetcher.ex
│   └── access_token_verifier.ex
├── mix.exs -> .harness/mix.exs
├── mix.lock
└── test
    ├── access_token_controller_test.exs
    ├── support
    │   └── mocks.ex
    └── test_helper.exs -> ../.harness/test/test_helper.exs

21 directories, 48 files
```

Generally the workflow for a run of `mix harness` is

1. read the configuration in `harness.exs`
1. determine a data structure that satisfies the configuration
1. run that configuration through template generators
1. store the generated files in `.harness/`
1. create any necessary symlinks from `.harness/` to `./`
