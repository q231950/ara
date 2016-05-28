defmodule Ara.PullRequest do
  @derive [Poison.Encoder]
  defstruct [ :number, :title, :user, :body ]
end
