# Harness

![Actions CI](https://github.com/NFIBrokerage/harness/workflows/Actions%20CI/badge.svg)

harness the boilerplate!

> N.B. harness is just a concept for now

Harness simplifies writing tiny isolated services by dynamically generating
unecssary boilerplate files.

Whoa that's a lotta words. Can you gimme the tl;dr?

Sure! Harness lets you version your practices.

...

What, not enough? Lemme try again.

## Rationale

Harness provides an easy interface for creating a verisonable service
[chassis](https://microservices.io/patterns/microservice-chassis.html). For
example, in your Elixir shoppe, you might use excoveralls for coverage testing,
credo for linting, distillery for releasing, and Appsignal for metricing.

That's a lot of boilerplate configuration to setup though. You have to add
a `coveralls.json` file for coverage, `.credo.exs` for linting, `Dockerfile`
and `rel/config.exs` for releasing, and in-app changes for Appsignal metric
gathering and shipping. Stand-alone services are file-expensive. You need
**lots** of config files to setup the service chassis.

So to combat the ridiculous amount of work you need to do to setup a service
from scratch, you make a static code generator like
[NFIBrokerage/gaas](https://github.com/NFIBrokerage/gaas). GaaS works out great
for creating new services, small or large, and adding to existing ones. So
what's the problem?

Consider adding a new practice to an app. In one app, you add a new way of
doing something that might be useful for all apps, like propagating trace
headers. Now that you've added it to one service, you should add it to all
of them, but how are you gonna do that? First you update the generator for all
new projects and then you use that generator on all existing projects. Maybe
you have to do some manual work like click merge buttons, but in the end things
could be worse. This doesn't sound like the end of the world, so why do I need
harness? Well maybe a small change isn't so bad across 5 repos. You could turn
that out in a half-hour maybe. 10 repos is starting to push it. Across a
hundred repos a change is herculean. It's simply too much work to apply a new
practice across so many repos. And let's not even talk about difficult changes
like changes requiring manual intervention.

To a harness project, static code generation is like running `npm install` and
then committing the resulting `node_modules/` folder. Good luck getting _that_
out of your git repo. It's easier to get red wine out of a white carpet.
Harness combats this boilerplate by hiding it. If you don't commit a file, it
never existed, and it's awfully easy to change the contents of files that never
existed. Sounds dangerous? Read on.

## What does it actually do?

Say you have a git repo for a µ controller that looks like this:

```
$ tree -a
.
├── .github
│   └── workflows
│       └── ci.yml
├── .gitignore
├── harness.exs
├── mix.lock
└── my_plug.ex

2 directories, 5 files
```

In a directory with a harness-file (`harness.exs`), a run of `mix harness` will
generate a `.harness/` directory containing generated boilerplate, with the
necessary symlinking and path adjusting to make the project run like a normal
phoenix project.

For example, the above repository would expand to something like:

```
$ mix harness
$ tree -a
.
├── .github
│   └── workflows
│       └── ci.yml
├── .gitignore
├── .harness
│   ├── config/..
│   ├── lib/..
│   ├── mix.exs
│   ├── rel
│   └── test/..
├── config/..
├── harness.exs
├── mix.exs -> .harness/mix.exs
├── mix.lock
└── my_plug.ex

7 directories, 7 files
```

Generally the workflow for a run of `mix harness` is

1. read the configuration in `harness.exs`
1. determine a data structure that satisfies the configuration
1. run that configuration through template generators
1. store the generated files in `.harness/`
1. create any necessary symlinks from `.harness/` to `./`

## Roadmap

1. v0.0.1: generate a µ controller on demand
  - templates for this µ controller will be _in_ the harness repository
1. v1.0.0: move templates out of the harness repository
