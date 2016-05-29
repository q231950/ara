defmodule Ara.Repository do
  @derive [Poison.Encoder]
  defstruct [:id, :name, :clone_url, :ssh_url]
end
