defmodule Ara do
  require Logger

  alias Ara.{ParameterError, GitHubUser, PullRequests, CommandParser, PullRequestCommand, WebhookCommand, Webhooks}

  def main(argv) do
    argv
    |> Ara.OptionParser.parse_args_to_options
    |> process
  end

  defp process( {:ok, :help} ) do
    IO.puts "#{IO.ANSI.magenta() }
    \tara, a small application to give you a brief overview over your pull requests.#{IO.ANSI.default_color()}\n\n"
    IO.puts "\tUsage:\t./ara --pullrequest --user <user> --repository <repository>\n\n\tTry:\t./ara -p -u q231950 -r ara\n"
  end

  defp process( { :error, msg } ) do
    IO.puts("process error")
    raise ParameterError, message: msg
  end

  defp process( { :ok, commands }) when is_list(commands) do
    IO.puts("process commands")
    IO.inspect Enum.map(commands, fn command ->  process_command(command) end)
  end

  defp process_command(%PullRequestCommand{user: user, repository: repository}) do
    GitHubUser.fetch
    |> PullRequests.open_pull_requests(user, repository)
  end

  defp process_command(%WebhookCommand{owner: owner, repository: repository}) do
    IO.puts "Fetch webhooks..."
    Webhooks.fetch(owner, repository)
  end

end
