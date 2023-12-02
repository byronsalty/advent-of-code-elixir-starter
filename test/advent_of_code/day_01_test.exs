defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.Day01

  @tag :skip
  test "part1 example" do
    input1 = """
    12
    1ab4
    """
    assert 26 == part1(input1)

    input2 = """
    12
    asdf7asdf0fff
    aaa1ab467
    """
    assert 99 == part1(input2)


    input3 = """
    2
    110
    """
    assert 32 == part1(input3)

  end

  @tag :skip
  test "part1 real" do
    input = File.read!("inputs/input01.txt")

    result = part1(input)

    IO.puts("Day 01 Part 1: #{result}")

    assert result
  end

  test "part2 units" do
    input1 = """
    two12
    1absix4
    two
    """
    assert 58 == part2(input1)

    input2 = """
    12three
    asdf7aeightsdf0fff
    aaa1fourab467
    """
    assert 100 == part2(input2)

    input3 = """
    12threefo
    uraaafour1fourab467nine
    """
    assert 62 == part2(input3)

    input4 = """
    eightwo
    nineightwone
    """
    assert (82 + 91) == part2(input4)

  end

  @tag :skip
  test "part2" do
    input = File.read!("inputs/input01.txt")

    result = part2(input)

    IO.puts("Day 01 Part 2: #{result}")

    assert result
  end
end
