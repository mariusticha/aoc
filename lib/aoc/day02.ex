defmodule Day02 do
  def exec(mode \\ "gold", is_test \\ true) do
    list = parse_input(is_test)

    case mode do
        "silver" -> silver(list)
        "gold" -> gold(list)
    end
  end

  def silver(list) do
    filteredIds = list
      |> Enum.filter(fn id -> filter_for_invalid_silver_ids(id) end)

    IO.inspect(filteredIds)

    Enum.sum(filteredIds)
  end

  def gold(list) do
    filteredIds = list
      |> Enum.filter(fn id -> filter_for_invalid_gold_ids(id) end)

    IO.inspect(filteredIds)

    Enum.sum(filteredIds)
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
       true -> "inputs/day02-test.txt"
       false -> "inputs/day02.txt"
    end
  end

  def get_range(x) do
    first = List.first(x)
    last = List.last(x)

    list = []

    for x <- first..last, do: list ++ x
  end

  def filter_for_invalid_silver_ids(id) do
    stringLength = Integer.to_string(id)
      |> String.length()

    case Integer.mod(stringLength, 2) do
      1 -> nil
      0 -> is_invalid_silver(id, stringLength, 2)
    end
  end

  def is_invalid_silver(id, stringLength, divisor) do
    list = Integer.to_string(id)
      |> String.split_at(div(stringLength, divisor))
      |> Tuple.to_list()

    identicalFragments = Enum.uniq(list)
      |> Enum.count()

      if id === 111 do
        IO.inspect("id: #{id}")
        IO.inspect("list:")
        IO.inspect(list)
        IO.inspect("stringLength: #{stringLength}")
        IO.inspect("divisor: #{divisor}")
        IO.inspect("###")
      end

      identicalFragments === 1
  end

  def filter_for_invalid_gold_ids(id) do
    stringLength = Integer.to_string(id)
      |> String.length()

    case stringLength do
      1 -> nil
      _ -> find_invalid_gold(id, Multitool.Numbers.Factors.factors_of(stringLength))
    end
  end

  def find_invalid_gold(id, factors) do
    result = Enum.reduce(
      factors,
      false,
      fn divisor, acc -> acc || is_invalid_silver(id, Integer.to_string(id) |> String.length(), divisor) end
    )

    # IO.inspect(id)
    # IO.inspect(factors)
    # IO.inspect(result)
    # IO.inspect("- - - - -")

    result
  end
end
