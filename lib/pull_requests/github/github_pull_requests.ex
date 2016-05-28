defmodule PullRequests.GitHubPullRequests do

  require Logger

  @github_url "https://api.github.com"
  @user_agent [ {"User-Agent" , "Kimochka"} ]

  def fetch(owner, repository) do
    Logger.info "Fetching pull requests for owner #{owner} of #{repository}"
    url(owner, repository)
    |> HTTPoison.get(@user_agent)
    |> handleResponse
  end

  defp url(owner, repository) do
    "#{@github_url}/repos/#{owner}/#{repository}/pulls"
  end

  defp handleResponse ( { :ok, response }) do
    Logger.info "Successfully received response"
    response.body
    |> Poison.decode!(as: [ %Ara.PullRequest{ user: %Ara.User{}, assignee: %Ara.User{} } ] )
  end

  defp handleResponse ( {status, response} ) do
    Logger.error "Status #{status} while waiting for response. Received #{ response.inspect }"
  end

end
