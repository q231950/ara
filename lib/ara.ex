defmodule Ara do

  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  def parse_args(argv) do
    parse = OptionParser.parse( argv, switches: [ help: :boolean , pullrequests: :boolean],
                                       aliases: [ h: :help , pr: :pullrequests])

     case parse do
        { [ help: true ], _, _ }
          -> :help

        { [pullrequests: true ], _, _ }
          -> :pullrequests

          { _, ["pr"], _ }
            -> :pullrequests

         _ -> :help
     end
  end

  defp process( :help ) do
    IO.puts "Usage: ara [-pr | -h]"
  end

  defp process( :pullrequests ) do
    open_pull_requests
  end

  def open_pull_requests do
    header = ["#", "Title", "User"]
    PullRequests.GitHubPullRequests.fetch("elixir-lang", "elixir")
    |> Enum.map( fn pr -> [ pr.number, pr.title, pr.user["login"] ] end )
    |> TableRex.quick_render!(header)
    |> IO.puts
  end

end
