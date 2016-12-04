defmodule AraWebhookTest do
  use ExUnit.Case
  doctest Ara

  test "webhook command is correctly parsed from argv" do
    assert { [ {:webhook, true} ], [], [] } == Ara.OptionParser.parse_args([ "--webhook" ])
  end

  test "wh shorthand command is correctly parsed from argv" do
    assert { [{:webhook, true}], [], [] } == Ara.OptionParser.parse_args([ "-wh" ])
  end

  test "webhook command is correctly parsed from options" do
    options = { [webhook: true, owner: "foo", repository: "bar"], [], [] }
    expected = {:ok, [%Ara.WebhookCommand{kind: :webhook, owner: "foo", repository: "bar" }]}
    assert expected == Ara.OptionParser.parse_options(options)
  end
end
