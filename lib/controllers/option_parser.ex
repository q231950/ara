defmodule Ara.OptionParser do

  alias Ara.{CommandParser}

  def parse_args_to_options(argv) do
    argv
    |> parse_args
    |> parse_options
  end

  def parse_args(argv) do
    OptionParser.parse( argv, switches: [ help: :boolean,
      pullrequest: :boolean,
      webhook: :boolean,
      user: :string,
      owner: :string,
      repository: :string],
    aliases: [ h: :help,
      p: :pr,
      u: :user,
      o: :owner,
      r: :repository,
      wh: :webhook,
      pr: :pullrequest])
  end

  def parse_options(options) do
    parsed = case options do
      { params, _, _ }  -> CommandParser.commandsFromParams(params)
      _                 -> {:ok, :help}
    end
    parsed
  end
end
