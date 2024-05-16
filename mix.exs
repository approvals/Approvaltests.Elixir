defmodule ExApprovalss.MixProject do
  use Mix.Project

  @code_url "https://github.com/BigTom/approvaltest.elixir"

  def project do
    [
      app: :ex_approval,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      source_url: @code_url,
      hompepage_url: @code_url,
      aliases: aliases()
    ]
  end

  defp description do
    "Elixir package implementing the approval test pattern. see: https://approvaltests.com/"
  end

  defp package do
    [
      maintainers: ["Tom Ayerst"],
      licenses: ["MIT"],
      links: %{"GitHub" => @code_url}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:diff_match_patch, "~> 0.2.0"},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false}
    ]
  end

  defp aliases do
    [
      check: ["deps.get", "format", "test", "credo --format=sarif --strict"],
      push_check: ["deps.get", "test", "credo --format=sarif --strict"]
    ]
  end

  def cli do
    [preferred_envs: [push_check: :test, check: :test]]
  end
end
