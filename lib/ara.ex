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

  def process( :help ) do
    IO.puts "Usage: ara -pr <owner> <repository>"
  end

  def process( { :pr, owner, repository} ) do
    fetch_user
    |> open_pull_requests( owner, repository )
  end

  defp fetch_user do
    Ara.GitHubUser.fetch
  end

  defp open_pull_requests( user, owner, repository ) do
    pull_requests = PullRequests.GitHubPullRequests.fetch( owner, repository )
    |> Enum.filter( fn pr -> assignee_login(pr.assignee) == user.login end )

    render_pull_requests( pull_requests )
    request_action_for_pull_requests( pull_requests )
  end

  defp render_pull_requests(pull_requests) when length(pull_requests) > 0 do
    header = ["#", "Title", "Author"]
    pull_requests
    |> Enum.map( fn pr -> [ pr.number, pr.title, pr.user.login ] end )
    |> TableRex.quick_render!(header)
    |> IO.puts
  end

  defp render_pull_requests(_) do
  end

  defp request_action_for_pull_requests ( pull_requests ) do
    answer = IO.gets "Checkout a pr? Choose a number to checkout, press q to exit: "
    case String.strip(answer) do
      "" -> IO.puts ("bye")
      "q" -> IO.puts ("bye")
      number -> checkout_pull_request_with_number(number, pull_requests)
    end
  end

  defp checkout_pull_request_with_number(number, pull_requests) do
    pull_requests
    |> Enum.filter( fn pr -> to_string(pr.number) == number end)
    |> Enum.at(0)
    |> checkout_pull_request
  end

  defp checkout_pull_request(pull_request) do
    branch = pull_request.head.ref
    url = pull_request.head.repo.ssh_url
    IO.puts ~s(git clone -b #{branch} #{url})
  end

  defp checkout(pull_request, number) do
    IO.inspect pull_request
  end

  defp assignee_login(assignee) do
    case assignee do
      a when is_nil(a) -> "None"
      _ -> assignee.login
    end
  end

end
