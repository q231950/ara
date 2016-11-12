defmodule Ara.PullRequests do
  def open_pull_requests( user, owner, repository ) do
    header = ["#", "Title", "Author"]
    PullRequests.GitHubPullRequests.fetch( owner, repository )
    |> Enum.filter( fn pr -> assignee_login(pr.assignee) == user.login end )
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
