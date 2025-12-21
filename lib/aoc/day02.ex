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

    identicalFragments === 1
  end

  def filter_for_invalid_gold_ids(id) do
    stringLength = Integer.to_string(id)
      |> String.length()

    case stringLength do
      1 -> nil
      _ -> find_invalid_gold(id, stringLength)
    end
  end

  def find_invalid_gold(id, stringLength) do
    fragments = Multitool.Numbers.Factors.factors_of(stringLength)
      |> Enum.map(fn factor -> get_index_to_cut(stringLength, factor) end)
      |> Enum.map(fn index -> cut_stringed_id_into_fragments(Integer.to_string(id), index) end)
      |> Enum.filter(fn fragments -> is_list(fragments) end)

    isInvalid = Enum.reduce(fragments, false, fn fragments, acc -> acc || is_invalid_fragement(fragments) end)

    # IO.inspect(id)
    # IO.inspect(fragments)
    # IO.inspect(isInvalid)
    # IO.inspect("- - - - -")

    isInvalid
  end

  def get_index_to_cut(stringLength, factor) do
    div(stringLength, factor)
  end

  def cut_stringed_id_into_fragments(string, index) do
      [head | tail] = String.split_at(string, index)
        |> Tuple.to_list()

      rest = Enum.at(tail, 0)

      case String.length(rest) do
        0 -> head
        _ -> List.flatten([head, cut_stringed_id_into_fragments(rest, index)])
      end
  end

  def is_invalid_fragement(fragments) do
    case is_list(fragments) do
      false -> false
      true -> (Enum.uniq(fragments) |> Enum.count()) === 1
    end
  end
end
