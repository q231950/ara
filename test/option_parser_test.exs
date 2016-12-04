defmodule AraOptionParserTest do
  use ExUnit.Case

  @doc ~S"""
   Description

  ## Examples

    iex> Ara.OptionParser.parse_args_to_options(["-pr", "-u", "q231950", "-r", "ara"])
    {:ok, [%Ara.PullRequestCommand{kind: :pr, repository: "ara", user: "q231950"}]}

    iex> Ara.OptionParser.parse_args_to_options(["-wh", "-o", "q231950", "-r", "ara"])
    {:ok, [%Ara.WebhookCommand{kind: :webhook, owner: "q231950", repository: "ara"}]}
  """
  test "pull request command is parsed from arguments" do
    assert {:ok, [%Ara.PullRequestCommand{kind: :pr, repository: "ara", user: "q231950"}]} = Ara.OptionParser.parse_args_to_options(["-pr", "-u", "q231950", "-r", "ara"])
  end

  test "webhook command is parsed from arguments" do
    assert {:ok, [%Ara.WebhookCommand{kind: :webhook, owner: "q231950", repository: "ara"}]} = Ara.OptionParser.parse_args_to_options(["-wh", "-o", "q231950", "-r", "ara"])
  end

end
