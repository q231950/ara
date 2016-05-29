defmodule PullRequests.GitHubPullRequests do

  require Logger

  @user_agent [ {"User-Agent" , "Kimochka"} ]

  def fetch(owner, repository) do
    Logger.info "Fetching pull requests for owner #{owner} of #{repository}"
    url(owner, repository)
    |> HTTPoison.get(@user_agent)
    |> handleResponse
  end

  defp url(owner, repository) do
    github_api_base_url = System.get_env( "ARA_GITHUB_API_BASE_URL")
    IO.puts github_api_base_url
    "#{ github_api_base_url }/repos/#{owner}/#{repository}/pulls"
  end

  defp handleResponse ( { :ok, response }) do
    Logger.info "Successfully received response"
    response.body
    # |> IO.inspect
    |> Poison.decode!(as: [ %Ara.PullRequest{ user: %Ara.User{}, assignee: %Ara.User{}, head: %Ara.Head{ repo: %Ara.Repository{} } } ] )
  end

  defp handleResponse ( {status, response} ) do
    Logger.error "Status #{status} while waiting for response. Received #{ response.inspect }"
  end

end
