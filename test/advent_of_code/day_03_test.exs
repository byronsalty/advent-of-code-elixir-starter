defmodule AdventOfCode.Day03Test do
  use ExUnit.Case

  import AdventOfCode.Day03

  test "test create_map" do
    input = """
    467.
    ...*
    """
    map = create_map(input)

    # assert map == [["4", "6", "7", "."], [".", ".", ".", "*"]]
    assert map == ["467.", "...*"]
  end

  test "find surrounding" do
    input = """
    123
    456
    789
    """

    map = create_map(input)
    assert find_surrounding(map, {1, 1, 5}) == ["123", "456", "789"]

    assert find_surrounding(map, {0, 0, 1}) == ["12", "45"]

    assert find_surrounding(map, {0, 1, 4}) == ["12", "45", "78"]

    assert find_surrounding(map, {0, 1, 45}) == ["123", "456", "789"]
  end

  test "find surrounding points" do
    input = """
    123
    456
    789
    """

    map = create_map(input)
    assert find_surrounding_points(map, {1, 1}) == [{0,0,"1"}, {1,0,"2"}, {2,0,"3"}, {0,1,"4"}, {1,1,"5"}, {2,1,"6"}, {0,2,"7"}, {1,2,"8"}, {2,2,"9"}]

    assert find_surrounding_points(map, {0, 0}) == [{0,0,"1"}, {1,0,"2"}, {0,1,"4"}, {1,1,"5"}]

    assert find_surrounding_points(map, {0, 1}) == [{0,0,"1"}, {1,0,"2"}, {0,1,"4"}, {1,1,"5"}, {0,2,"7"}, {1,2,"8"}]

    assert find_surrounding_points(map, {2, 2}) == [{1,1,"5"}, {2,1,"6"}, {1,2,"8"}, {2,2,"9"}]
  end

  test "scan left" do
    line = "..124...333"

    y = 3

    assert scan_left(line, {0, y}) == {nil, nil, ""}
    assert scan_left(line, {2, y}) == {2, y, "1"}
    assert scan_left(line, {3, y}) == {2, y, "12"}
    assert scan_left(line, {9, y}) == {8, y, "33"}
  end

  test "scan right" do
    line = "..124...333"

    y = 3

    assert scan_right(line, {0, y}, {nil, nil, ""}) == nil
    assert scan_right(line, {2, y}, {2, y, "1"}) == {2, y, "124"}
    assert scan_right(line, {3, y}, {2, y, "12"}) == {2, y, "124"}
    assert scan_right(line, {9, y}, {8, y, "33"}) == {8, y, "333"}


    line = "..124...333."
    assert scan_right(line, {9, y}, {8, y, "33"}) == {8, y, "333"}

  end

  test "get boundaries" do
    max = 10
    assert get_range(0, 1, max) == 0..1
    assert get_range(1, 1, max) == 0..2
    assert get_range(8, 1, max) == 7..9
    assert get_range(9, 1, max) == 8..9
  end

  test "test scan_line" do
    line = "....*"
    assert [] == scan_line(line)

    line = "7...*"
    assert [{0, 7}] == scan_line(line)

    line = "73...*"
    assert [{0, 73}] == scan_line(line)

    line = ".73...*"
    assert [{1, 73}] == scan_line(line)

    line = ".73..11.*"
    assert [{1, 73}, {5, 11}] == scan_line(line)

    line = ".73..11.*11"
    assert [{1, 73}, {5, 11}, {9, 11}] == scan_line(line)
  end

  test "get numbers" do
    input = """
    467.
    ...*
    """
    map = create_map(input)
    numbers = get_numbers(map)

    assert numbers == [{0,0,467}]
  end

  test "get asterisks" do
    input = """
    467.
    ...*
    """
    map = create_map(input)
    ast = get_asterisks(map)

    assert ast == [{3,1,"*"}]
  end

  test "find gears" do
    input = """
    4*3
    """
    map = create_map(input)
    ast = [{1,0,"*"}]

    assert find_gears(map, ast) == [12]

    input = """
    3.
    *3
    """
    map = create_map(input)
    ast = [{0,1,"*"}]

    assert find_gears(map, ast) == [9]


    input = """
    4..
    .*.
    ..4
    """
    map = create_map(input)
    ast = [{1,1,"*"}]

    assert find_gears(map, ast) == [16]

  end


  test "part1 examples" do
    input = """
    467..
    ....*
    """
    assert 0 == part1(input)

    input = """
    467.
    ...*
    """
    assert 467 == part1(input)
  end

  test "part2 examples" do

    input = """
    4*4...
    ...5..
    .12*..
    """
    assert 76 == part2(input)


    input = """
    4*4..*
    ...5.2
    .12*..
    """
    assert 76 == part2(input)

    input = """
    4*4...
    ...5..
    .12*2.
    """
    assert 136 == part2(input)
  end

  test "part1" do
    input = File.read!("inputs/input03.txt")
    result = part1(input)

    IO.puts("Day 03 Part 1: #{result}")

    assert result
  end

  test "part2" do
    input = File.read!("inputs/input03.txt")
    result = part2(input)

    IO.puts("Day 03 Part 2: #{result}")

    assert result
  end
end
