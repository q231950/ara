defmodule Ara do
  require Logger

  alias Ara.{ParameterError, InconsistencyError, PullRequests, GitHubUser, PullRequestCommand, WebhookCommand}

  def main(argv) do
    argv
    |> parse_args
    |> parse_options
    |> process
  end

  def parse_args(argv) do
    OptionParser.parse( argv, switches: [ help: :boolean,
      pullrequest: :boolean,
      webhook: :boolean,
      user: :string,
      owner: :string,
      repository: :string],
    aliases: [ h: :help,
      p: :pr,
      u: :user,
      o: :owner,
      r: :repository,
      wh: :webhook,
      pr: :pullrequest])
  end

  def parse_options(options) do
    parsed = case options do
      { params, _, _ }  -> commandsFromParams(params)
      _                 -> {:ok, :help}
    end
    parsed
  end

  defp commandsFromParams(params) do
    IO.inspect  params
    commands = []
    |> parse_pull_request_params(params)
    |> parse_webhook_params(params)
    |> put_help_when_no_commands()

    {:ok, commands}
  end

  defp put_help_when_no_commands(commands) do
    count = Enum.count(commands)
    commands = case count do
      0 -> Enum.concat(commands, [{:ok, :help}])
      _ -> commands
    end
    commands
  end

  defp parse_webhook_params(commands, [{:webhook, true}, {:owner, owner}, {:repository, repository}]) do
      command = %WebhookCommand{kind: :webhook, owner: owner, repository: repository}
      Enum.concat(commands, [command])
  end

  defp parse_webhook_params(commands, _) do
    commands
  end

  defp parse_pull_request_params(commands, [{:pullrequest, true}, {:user, user}, {:repository, repository}]) do
      command = %PullRequestCommand{kind: :pr, user: user, repository: repository}
      Enum.concat(commands, [command])
  end

  defp parse_pull_request_params(commands, _) do
    commands
  end

  def error_message_missing_parameter( user_repo_map ) do
    case user_repo_map do
      { user, repo } when is_nil(user) and is_nil(repo)
      -> {:error, "The user and repository name parameters -u <user> -r <repository name> are missing."}
      { user, _ } when is_nil( user )
      -> {:error, "The user parameter -u <user> is missing."}
      { _, repo } when is_nil( repo )
      -> {:error, "The repository parameter -r <repository name> is missing."}
      _ -> raise InconsistencyError, message: "Trying to generate an error reason for a valid user+repo map"
    end
  end

  defp process( {:ok, :help} ) do
    IO.puts "#{IO.ANSI.magenta() }
    \tara, a small application to give you a brief overview over your pull requests.#{IO.ANSI.default_color()}\n\n"
    IO.puts "\tUsage:\t./ara pr -u <user> -r <repository>\n\n\tTry:\t./ara pr -u q231950 -r ara\n"
  end

  defp process( { :error, msg } ) do
    raise ParameterError, message: msg
  end

  defp process( { :ok, commands }) when is_list(commands) do
    IO.inspect Enum.map(commands, fn command ->  process_command(command) end)
  end

  defp process (x) do
    IO.inspect x
    IO.puts "can't process unknown stuff"
  end

  defp process_command(%PullRequestCommand{user: user, repository: repository}) do
    GitHubUser.fetch
    |> PullRequests.open_pull_requests(user, repository)
  end

  defp process_command(%WebhookCommand{owner: owner, repository: repository}) do
    GitHubUser.fetch
    IO.puts "Fetch webhooks..."
    # |> PullRequests.open_pull_requests(user, repository)
  end

end
