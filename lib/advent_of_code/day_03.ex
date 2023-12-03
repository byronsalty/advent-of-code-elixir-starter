defmodule AdventOfCode.Day03 do

  def create_map(input) do
    input
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    # |> Enum.map(&String.graphemes/1)
  end

  def scan_line(line) do
    r = ~r/\d+/

    if Regex.match?(r, line) do
      groups =
        Regex.scan(r, line)
        |> List.flatten
        |> Enum.map(&String.to_integer/1)

      inds =
        Regex.scan(r, line, return: :index)
        |> List.flatten
        |> Enum.map(fn {i, _} -> i end)

      Enum.zip(inds, groups)
    else
      []
    end
  end


  def scan_line_asterisk(line) do
    r = ~r/\*/

    if Regex.match?(r, line) do
      groups =
        Regex.scan(r, line)
        |> List.flatten

      inds =
        Regex.scan(r, line, return: :index)
        |> List.flatten
        |> Enum.map(fn {i, _} -> i end)

      Enum.zip(inds, groups)
    else
      []
    end
  end

  def get_range(i, width, max) do
    [bottom, top] = [i - 1, i + width]
    bottom = if bottom < 0, do: 0, else: bottom
    top = if top > (max-1), do: (max-1), else: top

    bottom..top
  end

  def find_surrounding_points(map, {x, y}) do
    y_range = get_range(y, 1, Enum.count(map))
    x_range = get_range(x, 1, String.length(Enum.at(map, 0)))

    Enum.flat_map(y_range, fn y ->
      line = Enum.at(map, y)
      Enum.map(x_range, fn x ->
        {x, y, String.at(line, x)}
      end)
    end)
  end

  def reduce_surrounding_numbers(numbers) do
    if Enum.count(numbers) <= 1 do
      0
    else
      Enum.product(numbers)
    end
  end

  def scan_left(line, {x, y}, {gx, gy, acc} \\ {nil, nil, []}) do
    chr = String.at(line, x)
    if Regex.match?(~r/\d/, chr) and x >= 0 do
      scan_left(line, {x-1, y}, {x, y, [chr | acc]})
    else
      # IO.inspect(acc, label: "acc in scan left")
      {gx, gy, Enum.join(acc)}
    end
  end

  def scan_right(_, _, {nil, _, _}), do: nil
  def scan_right(line, {x, y}, {gx, gy, acc}) do
    rest = String.slice(line, gx..-1)
    # IO.inspect(rest, label: "rest in scan right")
    [_, num] = Regex.run(~r/^(\d+)\D?.*$/, rest)
    {gx, gy, num}
  end

  def find_surrounding(map, {x, y, val}) do
    width = String.length("#{val}")
    y_range = get_range(y, 1, Enum.count(map))
    x_range = get_range(x, width, String.length(Enum.at(map, 0)))

    Enum.map(y_range, fn y ->
      line = Enum.at(map, y)
      String.slice(line, x_range)
    end)
  end

  def get_numbers(map) do
    map
    |> Enum.with_index()
    |> Enum.map(fn {line, y} ->
      scan_line(line)
      |> Enum.map(fn {x, val} -> {x, y, val} end)
    end)
    |> List.flatten()
  end

  def get_asterisks(map) do
    map
    |> Enum.with_index()
    |> Enum.map(fn {line, y} ->
      scan_line_asterisk(line)
      |> Enum.map(fn {x, val} -> {x, y, val} end)
    end)
    |> List.flatten()
  end

  def find_gears(map, asterisks) do
    Enum.map(asterisks, fn {x, y, val} ->
      find_surrounding_points(map, {x, y})
      |> Enum.map(fn {x, y, val} ->
        left = scan_left(Enum.at(map, y), {x, y})
        scan_right(Enum.at(map, y), {x, y}, left)
      end)
      |> Enum.filter(fn el -> not is_nil(el) end)
      |> Enum.dedup()
      |> Enum.map(fn {_, _, val} -> String.to_integer(val) end)
      |> reduce_surrounding_numbers()
    end)
    # |> IO.inspect(label: "find_gears")
  end


  def part1(input) do
    map = create_map(input)

    numbers = get_numbers(map)

    Enum.map(numbers, fn {x, y, val} ->
      surrounding =
        find_surrounding(map, {x, y, val})
        |> Enum.reduce("", fn s, acc -> acc <> s end)


      if Regex.match?(~r/^[\.\d]*$/, surrounding) do
        0
      else
        val
      end
    end)
    |> Enum.sum()
  end

  def part2(input) do
    map = create_map(input)

    ast = get_asterisks(map)

    find_gears(map, ast)
    |> Enum.sum()
  end
end
