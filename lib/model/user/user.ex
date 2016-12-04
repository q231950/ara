defmodule Ara.User do
  @derive [Poison.Encoder]
  defstruct [:login, :id]
end
