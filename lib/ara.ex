defmodule Ara do

  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  def parse_args(argv) do
    OptionParser.parse( argv, switches: [ help: :boolean , pr: :boolean],
                                       aliases: [ h: :help])
    |> parse_options
  end

  defp parse_options(options) do
    IO.inspect options
    case options do
       { [ help: true ], _, _ }
         -> :help

       { _, [repository], [{"-pr", owner}] }
         -> { :pr, owner, repository}

        _ -> :help
    end
  end

  defp process( :help ) do
    IO.puts "Usage: ara -pr <owner> <repository>"
  end

  defp process( { :pr, owner, repository} ) do
    fetch_user
    |> open_pull_requests( owner, repository )
  end

  def fetch_user do
    Ara.GitHubUser.fetch
    |> IO.inspect
  end

  def open_pull_requests( user, owner, repository ) do
    header = ["#", "Title", "Author"]
    PullRequests.GitHubPullRequests.fetch( owner, repository )
    |> Enum.filter( fn pr -> assignee_login(pr.assignee) == user.login end )
    |> Enum.map( fn pr -> [ pr.number, pr.title, pr.user.login ] end )
    |> TableRex.quick_render!(header)
    |> IO.puts
  end

  defp assignee_login(assignee) do
    case assignee do
      a when is_nil(a) -> "None"
      _ -> assignee.login
    end
  end

end
