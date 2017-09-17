defmodule Ara.GitHubUser do

  require Logger

  @user_agent [ {"User-Agent" , "Kimochka"} ]

  def fetch do
    api_access_token = System.get_env( "ARA_GITHUB_API_ACCESS_TOKEN")
    Logger.info "Fetching user for access token #{ api_access_token }"
    url()
    |> HTTPoison.get(@user_agent, params: %{ access_token: api_access_token })
    |> handleResponse
  end

  defp url do
    github_api_base_url = System.get_env( "ARA_GITHUB_API_BASE_URL")
    "#{ github_api_base_url }/user"
  end

  defp handleResponse ( { :ok, response }) do
    Logger.info "Successfully received user response"
    response.body
    |> Poison.decode!(as: %Ara.User{} )
  end

  defp handleResponse ( {status, response} ) do
    Logger.error "Status #{status} while waiting for user response. Received #{ response.inspect }"
  end

end
