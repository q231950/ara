defmodule Ara do
  require Logger

  alias Ara.{ParameterError, InconsistencyError, PullRequests, GitHubUser}

  def main(argv) do
    argv
    |> parse_args
    |> parse_options
    |> process
  end

  def parse_args(argv) do
    OptionParser.parse( argv, switches: [ help: :boolean,
      pullrequest: :boolean,
      webhook: :string,
      user: :string,
      repository: :string],
    aliases: [ h: :help,
      p: :pr,
      u: :user,
      r: :repository,
      wh: :webhook,
      pr: :pullrequest])
  end

  def parse_options(options) do
    case options do
      { params, _, _ }
      -> if params[:pullrequest] == true do
          parse_pull_request_params(params)
         else
          :help
         end
        _ -> :help
    end
  end

  defp parse_pull_request_params(params) do
    if is_nil(params[:user]) or is_nil(params[:repository]) do
      error_message_missing_parameter( { params[:user], params[:repository] } )
    else
      { :pr, [{:user, params[:user]}, {:repository, params[:repository]}]}
    end
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

  defp process( :help ) do
    IO.puts "#{IO.ANSI.magenta() }
    \tara, a small application to give you a brief overview over your pull requests.#{IO.ANSI.default_color()}\n\n"
    IO.puts "\tUsage:\t./ara pr -u <user> -r <repository>\n\n\tTry:\t./ara pr -u q231950 -r ara\n"
  end

  defp process( { :error, msg } ) do
    raise ParameterError, message: msg
  end

  defp process( { :pr, params} ) do
    owner = params[:user]
    repository = params[:repository]

    GitHubUser.fetch
    |> PullRequests.open_pull_requests( owner, repository )
  end


end
