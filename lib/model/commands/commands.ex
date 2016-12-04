defmodule Ara.PullRequestCommand do
  defstruct kind: "", user: "", repository: ""
end

defmodule Ara.WebhookCommand do
  defstruct kind: "", owner: "", repository: ""
end
