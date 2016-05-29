defmodule Ara.Head do
  @derive [Poison.Encoder]
  defstruct [ :label, :ref, :repo ]
end
