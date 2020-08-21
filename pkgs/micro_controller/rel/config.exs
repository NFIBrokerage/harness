# Import all plugins from `rel/plugins`
# They can then be used by adding `plugin MyPlugin` to
# either an environment, or release definition, where
# `MyPlugin` is the name of the plugin module.
# Path.join(["rel", "plugins", "*.exs"])
# |> Path.wildcard()
# |> Enum.map(&Code.eval_file(&1))

use Distillery.Releases.Config,
  default_release: :default,
  default_environment: Mix.env()

environment :dev do
  set dev_mode: true
  set include_erts: false

  set cookie: :";~L4pfJu;dA@czCyF&|Uc|h(_Kblz;:9ZwDLAqX7/Wvg3vuZIC;QLJBd^eLH5[2u"
end

environment :prod do
  set include_erts: true
  set include_src: false

  set cookie: :"f@26R`W)mz?Pj;[YjV5P2_`T=y=7n,Zd_y&1N=9Xuc3$O]M}S[5EGrM[vAzq.[5:"

  set config_providers: [
        {Distillery.Releases.Config.Providers.Elixir,
         ["/etc/cuatro_secrets/config.exs"]}
      ]
end

release :<%= @app %> do
  {git_describe_version_raw, _} =
    System.cmd("git", ["describe", "--tags", "--long", "--always"])

  git_describe_version = String.trim(git_describe_version_raw)
  set version: git_describe_version

  set applications: [:runtime_tools]
end
