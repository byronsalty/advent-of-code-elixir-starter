defmodule AdventOfCode.Day02Test do
  use ExUnit.Case

  import AdventOfCode.Day02

  test "parse line" do
    line = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
    expected = {1, [%{blue: 3, red: 4}, %{red: 1, green: 2, blue: 6}, %{green: 2}]}

    assert parse_game(line) == expected
  end

  test "part1 unit tests" do
    input = """
    Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    """

    expected_games =
      [
        {1, [%{blue: 3, red: 4}, %{red: 1, green: 2, blue: 6}, %{green: 2}]},
        {2, [%{blue: 1, green: 2}, %{green: 3, blue: 4, red: 1}, %{green: 1, blue: 1}]}
      ]

    assert parse_games(input) == expected_games
  end

  @tag :skip
  test "part2 unit tests" do
    input = """
    Game 1: 7 blue, 4 red, 11 green; 2 red, 2 blue, 7 green; 2 red, 13 blue, 8 green; 18 blue, 7 green, 5 red
    Game 2: 3 green, 4 red, 4 blue; 6 red, 4 green, 4 blue; 2 blue, 4 green, 3 red
    Game 3: 1 red, 2 green, 3 blue; 1 red, 2 green; 2 green, 3 red; 1 blue, 2 red
    Game 4: 1 red, 15 green; 1 green, 2 blue; 12 green, 1 red, 2 blue; 14 green; 2 green, 1 blue, 2 red
    Game 5: 8 red; 7 red; 11 red, 4 green; 1 blue, 8 red; 6 red, 2 green, 1 blue; 8 green, 13 red, 1 blue
    """

    limits = %{red: 10, green: 10, blue: 10}

    games = parse_games(input)

    filtered_games = filter_games(games, limits)

    assert filtered_games == [
      {2,
       [
         %{green: 3, red: 4, blue: 4},
         %{green: 4, red: 6, blue: 4},
         %{green: 4, red: 3, blue: 2}
       ]},
      {3,
       [
         %{green: 2, red: 1, blue: 3},
         %{green: 2, red: 1},
         %{green: 2, red: 3},
         %{red: 2, blue: 1}
       ]}
    ]

    minimum_sets = Enum.map(filtered_games, fn {_, pulls} -> get_minimum_set(pulls) end)

    assert minimum_sets == [%{green: 4, red: 6, blue: 4}, %{green: 2, red: 3, blue: 3}]

    scores = Enum.map(minimum_sets, fn set -> score_set(set) end)

    assert scores == [96, 18]

    assert part2(games, limits) == 114

  end

  test "get minimum set" do
    game = [%{blue: 3, red: 4}, %{red: 1, green: 2, blue: 6}, %{green: 2}]
    expected = %{blue: 6, red: 4, green: 2}

    assert get_minimum_set(game) == expected
  end

  test "score set" do
    set = %{blue: 6, red: 4, green: 2}
    expected = 6 * 4 * 2

    assert score_set(set) == expected

    set = %{blue: 6, red: 4}
    expected = 6 * 4 * 1

    assert score_set(set) == expected
  end

  test "filter pull" do
    pull = %{blue: 3, red: 4}
    limits = %{blue: 2}

    assert keep_pull(pull, limits) == false


    pull = %{blue: 3, red: 4}
    limits = %{blue: 4}

    assert keep_pull(pull, limits) == true
  end

  test "filter games unit" do
    games = [
      {1, [%{blue: 3, red: 4}, %{red: 1, green: 2, blue: 6}, %{green: 2}]},
      {2, [%{blue: 1, green: 2}, %{green: 3, blue: 4, red: 1}, %{green: 1, blue: 1}]}
    ]

    expected = [
      {2, [%{blue: 1, green: 2}, %{green: 3, blue: 4, red: 1}, %{green: 1, blue: 1}]}
    ]

    limits = %{blue: 5}

    assert filter_games(games, limits) == expected
  end

  test "count games unit" do
    games = [
      {1, [%{blue: 3, red: 4}, %{red: 1, green: 2, blue: 6}, %{green: 2}]},
      {2, [%{blue: 1, green: 2}, %{green: 3, blue: 4, red: 1}, %{green: 1, blue: 1}]}
    ]

    limits = %{blue: 5}

    assert part1(games, limits) == 2
  end

  @tag :skip
  test "count games and score" do
    games = [
      {1, [%{blue: 3, red: 4}, %{red: 1, green: 2, blue: 6}, %{green: 2}]},
      {2, [%{blue: 1, green: 2}, %{green: 3, blue: 4, red: 1}, %{green: 1, blue: 1}]}
    ]

    limits = %{blue: 5}

    # minimum set for game 1 is %{blue: 4, red: 1, green: 3}

    assert part2(games, limits) == 12
  end

  @tag :skip
  test "part1" do
    input = File.read!("inputs/input02.txt")
    games = parse_games(input)

    limits = %{red: 12, green: 13, blue: 14}
    result = part1(games, limits)

    IO.puts("Day 02 Part 1: #{result}")

    assert result
  end

  test "part2" do
    input = File.read!("inputs/input02.txt")
    games = parse_games(input)

    limits = %{red: 12, green: 13, blue: 14}
    result = part2(games, limits)

    IO.puts("Day 02 Part 2: #{result}")

    assert result
  end
end
