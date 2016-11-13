defmodule AraWebhookTest do
  use ExUnit.Case
  doctest Ara

  test "webhook command is command is correctly parsed from argv" do
    assert { [], ["webhook"], [] } == Ara.parse_args([ "webhook" ])
  end

  test "wh shorthand command is correctly parsed from argv" do
    #assert { [], ["webhook"], [] } == Ara.parse_args([ "wh" ])
  end

end
