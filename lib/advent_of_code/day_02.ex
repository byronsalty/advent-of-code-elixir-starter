defmodule AdventOfCode.Day02 do
  def part1(games, limits) do
    games
    |> filter_games(limits)
    |> Enum.map(fn {game_number, _} -> game_number end)
    |> Enum.sum()
  end

  def part2(games, limits) do
    games
    # |> filter_games(limits)
    |> IO.inspect()
    |> Enum.map(fn {_, pulls} -> get_minimum_set(pulls) end)
    |> IO.inspect()
    |> Enum.map(fn set -> score_set(set) end)
    |> Enum.sum()
  end


  def parse_games(input) do
    input
    |> String.split("\n")
    |> Enum.reject(&String.trim(&1) == "")
    |> Enum.map(&parse_game/1)
  end

  def parse_game(line) do

    [[_, game_number, game_str]] = Regex.scan(~r/Game (\d+): (.*)/, line)

    pulls =
      game_str
      |> String.split(";")
      |> Enum.map(fn pull ->
        pull
        |> String.trim()
        |> String.split(",")
        |> Enum.map(&String.trim/1)
        |> Enum.reduce(%{}, fn chunk, acc ->
          [[_, count, color]] = Regex.scan(~r/(\d+) (\w+)/, chunk)
          Map.put(acc, String.to_atom(color), String.to_integer(count))
        end)
      end)

    {String.to_integer(game_number), pulls}
  end

  def filter_games(games, limits) do
    Enum.filter(games, fn {_, pulls} ->
      Enum.all?(pulls, fn pull ->
        keep_pull(pull, limits)
      end)
    end)
  end

  def keep_pull(pull, limits) do
    Enum.all?(pull, fn {color, count} ->
      Map.get(limits, color, 1000000) >= count
    end)
  end

  def get_minimum_set(game) do
    game
    |> Enum.reduce(%{red: 1, green: 1, blue: 1}, fn pull, acc ->
      Enum.reduce(pull, acc, fn {color, count}, acc2 ->
        if Map.get(acc2, color) < count do
          Map.put(acc2, color, count)
        else
          acc2
        end
      end)
    end)
  end

  def score_set(set) do
    set
    |> Enum.reduce(1, fn {_, count}, acc ->
      acc * count
    end)
  end
end
