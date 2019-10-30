defmodule UberGen.MixProject do
  use Mix.Project

  @version "0.0.1"

  def project do
    [
      app: :uber_gen,
      version: @version,
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:version_tasks, "~> 0.3.3"}
    ]
  end
end
