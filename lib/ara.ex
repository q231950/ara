defmodule Ara do

  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  def parse_args(argv) do
    OptionParser.parse( argv, switches: [ help: :boolean , pullrequests: :boolean],
                                       aliases: [ h: :help , pr: :pullrequests])
    |> parse_options
  end

  defp parse_options(options) do
    case options do
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
    header = ["#", "Title", "Author"]
    PullRequests.GitHubPullRequests.fetch("q231950", "ara")
    |> Enum.filter( fn pr -> assignee_login(pr.assignee) == "q231950" end )
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
