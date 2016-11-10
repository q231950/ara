defmodule Ara do

  def main(argv) do
    argv
    |> parse_args
    |> parse_options
    |> process
  end

  def parse_args(argv) do
    options = OptionParser.parse( argv, switches: [ help: :boolean , pr: :boolean],
                                       aliases: [ h: :help])
  end

  defp parse_options(options) do
    case options do
      { params, ["pr"], _ }
        -> { :pr, params}

      { _, [repository], [{"-pr", owner}] }
        -> { :pr, [{:owner, owner}, {:repo, repository}] }

        _ -> :help
    end
  end

  defp process( :help ) do
    IO.puts "#{IO.ANSI.magenta() }🐥 ara, a small application to give you a brief overview over your pull requests.#{IO.ANSI.default_color()}\n\n"
    IO.puts "\tUsage: ara -pr <owner> <repository>"
  end

  defp process( { :pr, params} ) do
    owner = params[:owner]
    repository = params[:repo]

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
