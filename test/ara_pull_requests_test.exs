defmodule AraPullRequestTest do
  use ExUnit.Case
  doctest Ara

  test "pull request command is correctly parsed from vargs" do
    assert { [ {:pullrequest, true} ], [], [] } = Ara.parse_args (["--pullrequest"])
  end

  test "pr command is correctly parsed from vargs" do
    assert { [ {:pullrequest, true} ], [], [] } = Ara.parse_args (["-pr"])
  end

  test "-u shorthand command for --user is correctly parsed from vargs" do
    vargs = ["pr", "-u", "foo"]
    assert { [user: "foo"], ["pr"], [] } = Ara.parse_args (vargs)
  end

  test "-r shorthand command for --repository is correctly parsed from vargs" do
    vargs = ["pr", "-r", "bar"]
    assert { [repository: "bar"], ["pr"], [] } = Ara.parse_args (vargs)
  end

  test "user and repository are correctly parsed from vargs" do
    vargs = ["pr", "-u", "foo", "-r", "bar"]
    assert { [user: "foo", repository: "bar"], ["pr"], [] } = Ara.parse_args (vargs)
  end

  test "pr option is ok " do
    options = { [pullrequest: true, user: "foo", repository: "bar"], [], [] }
    expected = {:ok, [%Ara.PullRequestCommand{kind: :pr, user: "foo", repository: "bar"}]}
    assert expected == Ara.parse_options( options )
  end


end
