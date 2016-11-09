defmodule Ara.Mixfile do
  use Mix.Project

  def project do
    [app: :ara,
     version: "0.0.1",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     escript: [main_module: Ara],
     deps: deps]
  end

  def application do
    [applications: [:logger, :httpoison, :table_rex]]
  end

  defp deps do
    [
      { :httpoison, "~> 0.10" },
      { :poison, "~> 3.0" },
      { :table_rex, "~> 0.8.3" }
    ]
  end
end
