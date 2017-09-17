defmodule Ara.OptionParser do

  alias Ara.{CommandParser}

  def parse_args_to_options(argv) do
    argv
    |> parse_args
    |> parse_options
  end

  def parse_args(argv) do
    OptionParser.parse!( argv, switches: [ help: :boolean,
      pullrequest: :boolean,
      webhook: :boolean,
      user: :string,
      owner: :string,
      repository: :string],
    aliases: [ h: :help,
      p: :pullrequest,
      u: :user,
      o: :owner,
      r: :repository,
      w: :webhook])
  end

  def parse_options(options) do
    IO.puts("Parse options.")
    parsed = case options do
      { params, _ }  -> CommandParser.commandsFromParams(params)
      _                 -> {:ok, :help}
    end
    parsed
  end
end
