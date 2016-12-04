defmodule AraWebhookTest do
  use ExUnit.Case
  doctest Ara

  test "webhook command is correctly parsed from argv" do
    assert { [ {:webhook, true} ], [], [] } == Ara.parse_args([ "--webhook" ])
  end

  test "wh shorthand command is correctly parsed from argv" do
    assert { [{:webhook, true}], [], [] } == Ara.parse_args([ "-wh" ])
  end

  test "wh shorthand command is correctly parsed from options" do
    options = { [wh: true, owner: "foo", repository: "bar"], [], [] }
    expected = {:ok, [%Ara.WebhookCommand{kind: :webhook, owner: "foo", repository: "bar" }]}
    assert expected == Ara.parse_options( options )
  end
end
