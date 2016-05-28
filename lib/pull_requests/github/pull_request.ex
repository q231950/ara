defmodule PullRequests.PullRequest do
  @derive [Poison.Encoder]
  defstruct [ :number, :title, :user ]
end
