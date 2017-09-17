defmodule Ara.Webhooks do
  require Logger

  @derive [Poison.Encoder]
  defstruct [:id, :url, :type, :name, :active, :events, :config, :created_at, :updated_at, :test_url, :ping_url, :last_response]

  @user_agent [ {"User-Agent" , "Kimochka"} ]

  def fetch(owner, repository) do
    Logger.info "Fetching webhooks for owner #{owner} of #{repository}"
    api_access_token = System.get_env( "ARA_GITHUB_API_ACCESS_TOKEN")
    Logger.info api_access_token
    url(owner, repository)
    |> HTTPoison.get(@user_agent, params: %{ access_token: api_access_token })
    |> handleResponse
  end

  defp url(owner, repository) do
    github_api_base_url = System.get_env( "ARA_GITHUB_API_BASE_URL")

    Logger.info "#{ github_api_base_url }/repos/#{owner}/#{repository}/hooks"
    "#{ github_api_base_url }/repos/#{owner}/#{repository}/hooks"
  end

  defp handleResponse ( { :ok, response }) do
    Logger.info response.body
    Logger.info "Successfully received response"
    response.body
    |> Poison.decode!(as: [ %Ara.Webhooks{} ] )
  end

  defp handleResponse ( {status, response} ) do
    Logger.error "Status #{status} while waiting for response. Received #{ response.inspect }"
  end
end

defmodule Ara.Webhook do

end
