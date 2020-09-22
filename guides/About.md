# About Harness

There are many ways to describe harness. Harness:

- simplifies writing tiny isolated services by dynamically generating
  unecessary boilerplate files
- makes it easy to version your _practices_
- lets you make a library out of anything!

But overall, harness is really about one thing: service chassis (plural).

## Services Chassis

What's a _service chassis_? A [service
chassis](https://microservices.io/patterns/microservice-chassis.html) is a
collection of tooling that sets the bar for what makes one of your services one
of your services. For example, in [our](https://github.com/NFIBrokerage) Elixir
shoppe, we have a service chassis that includes:

- [`asdf`](https://github.com/asdf-vm/asdf) for language version management
- [`excoveralls`](https://hex.pm/packages/excoveralls) for testing coverage
- [`credo`](https://hex.pm/packages/credo) for linting
- [`distillery`](https://hex.pm/packages/distillery) for release building
- [Appsignal](https://appsignal.com/) for error reporting and metrics

And more (I can't give _all_ our secrets away, can I? ;).

For these, we need a `.tool-versions`, a `.credo.exs`, a `coveralls.json`, a
`rel/config.exs` and `rel/.formatter.exs`, and configuration and
in-application-space code changes for Appsignal. Seems like a lot? Imagine all
the other configuration I'm not even mentioning like private tooling and
`Dockerfile`s!

If you have one service running your business, this isn't too big of a deal.
One times the aforementioned number of configuration files isn't too bad. It's
manageable. But what about if you have 10 services? 50? 100?

## Enter static code generation tooling

If your organization employs a micro-service architecture and you've developed
more than 20 services, you have probably used a static code generation tool.
They're great! Plug in X Y and Z like the repository name, application name,
and secret key-base, and you can have a fresh phoenix app up and running in no
time!

In our organization, we have a centralized static code generation tool called
GaaS (Git as a Service). A LiveView front-end plus a DSL for easy templates
equals a very nice user experience for generating new code.  [GitHub
templates](https://github.blog/2019-06-06-generate-new-repositories-with-repository-templates/)
are a free and ready-to-use alternative.
[`mix_generator`](https://github.com/pragdave/mix_generator) is another good
tool for Elixir projects in specific.

We used static code generation tools alone for a long time with great effect.

## Where static code generation tools fall short

So what's the big deal then if static code generation tools work so well? The
problem lies in how your organization adopts and alters _practices_ over time.

Consider this scenario: in an app, you add a new way of doing something that
may be useful for all apps, like using the (shameless plug)
[`bless`](https://hex.pm/packages/bless) library for running the gambit on
your testing/linting suite. It's a great practice, so let's add it to all our
services! To do so, we first modify our `mix.exs` generator(s) to depend on
and/or configure `bless`. Then we can either run the updated generator(s) over
existing codebases or manually change those services. With 10 or so services
either way is fine, but over 20 or 50 or 100 services? Even small changes start
to hurt.

## Enter Harness

Harness takes a different approach. Harness is more like a package manager
(think the mix+hex relationship or `npm`/`yarn` or `cargo` crates). Imagine if
you checked in all the `node_modules/` stuff from `npm`? Gross. Like red wine
in a white carpet. Finding any specific file in that mess? Impossible. Changing
that directory across hundreds of repositories? Herculean.

Instead, the harness approach is to describe everything a static code
generation tool does with a _manifest_, and then never check in the generated
files.

## Manifests

Manifests describe a _plan_. They don't detail the specifics like which
versions of dependencies we'll use exactly (think a `mix.lock`) but rather a
set of rules or guidelines to use to form a project.

For harness, this is the `harness.exs`.

Enough of the theory though, let's [Get Started!](guides/Getting Started.md)
