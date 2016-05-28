defmodule Ara do
  require Issues

  def issues do
    Issues.CLI.main ["erlang", "rebar3", "10"]
  end

  def open_pull_requests do
    header = ["#", "Title", "User"]
    PullRequests.GitHubPullRequests.fetch("elixir-lang", "elixir")
    |> Enum.map( fn pr -> [ pr.number, pr.title, pr.user["login"] ] end )
    |> TableRex.quick_render!(header)
    |> IO.puts
  end
end
