defmodule Ara.CommandParser do

  alias Ara.{ParameterError, InconsistencyError, PullRequestCommand, WebhookCommand}

  def commandsFromParams(params) do
    commands = []
    |> parse_pull_request_params(params)
    |> parse_webhook_params(params)
    |> put_help_when_no_commands()

    {:ok, commands}
  end

  defp put_help_when_no_commands(commands) do
    count = Enum.count(commands)
    commands = case count do
      0 -> :help
      _ -> commands
    end
    commands
  end

  defp parse_webhook_params(commands, [{:webhook, true}, {:owner, owner}, {:repository, repository}]) do
      IO.puts("parse_webhook_params.")
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

end
