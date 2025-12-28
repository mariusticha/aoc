defmodule Day03 do
  def exec(mode \\ "gold", is_test \\ true) do
    list = parse_input(is_test)

    case mode do
        "silver" -> silver(list)
        "gold" -> gold(list)
    end
  end

  def silver(list) do
    list
  end

  def gold(list) do
    list
  end

  def parse_input(is_test) do
    get_file_name(is_test)
      |> File.read!()
      |> String.trim_trailing()
      |> String.split(",", trim: true)
      |> Enum.map(fn x ->
          String.split(x, "-", trim: true)
          |> Enum.map(fn x -> String.to_integer(x) end)
        end)
      |> Enum.flat_map(fn x -> get_range(x) end)
  end

  def get_file_name(is_test) do
    case is_test do
       true -> "inputs/day03-test.txt"
       false -> "inputs/day03.txt"
    end
  end

  def get_range(x) do
    first = List.first(x)
    last = List.last(x)

    list = []

    for x <- first..last, do: list ++ x
  end
end
