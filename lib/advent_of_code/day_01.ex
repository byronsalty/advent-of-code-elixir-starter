defmodule AdventOfCode.Day01 do
  def part1(input_str) do
    input_str
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [[_, first]] = Regex.scan(~r/^\D*(\d).*$/, line)
      [[_, last]] = Regex.scan(~r/^.*(\d)\D*$/, line)
      first <> last
    end)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  @digits [
    {"one", "o1e"},
    {"two", "t2o"},
    {"three", "t3e"},
    {"four", "f4r"},
    {"five", "f5e"},
    {"six", "s6x"},
    {"seven", "s7n"},
    {"eight", "e8t"},
    {"nine", "n9e"}
  ]

  def part2(input_str) do
    Enum.reduce(@digits, input_str, fn {word, digit}, acc ->
      String.replace(acc, word, digit)
    end)
    |> part1()
  end
end
