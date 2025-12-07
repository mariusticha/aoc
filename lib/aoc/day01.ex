defmodule Day01 do
  def exec(mode, is_test \\ true) do
    list = parse_input(is_test)

    case mode do
        "silver" -> silver(list)
        "gold" -> gold(list)
    end
  end

  def silver(list) do
    result = Enum.reduce(
      list,
      %{
        "value" => 50,
        "landing_on_zero_count" => 0
      },
      fn x, acc ->
        %{
            "value" => acc["value"] + x,
            "landing_on_zero_count"  => acc["landing_on_zero_count"] + is_zero(acc["value"] + x),
        }
      end
    )

    result["landing_on_zero_count"]
  end

  def gold(list) do
    result = Enum.reduce(
      list,
      %{
        "value" => 50,
        "landing_on_zero_count" => 0,
        "passing_zero_count" => 0,
      },
      fn x, acc ->
        follow_value = get_follow_value(acc["value"], x)

        %{
            "value" => follow_value,
            "landing_on_zero_count"  => acc["landing_on_zero_count"] + is_zero(follow_value),
            "passing_zero_count"  => acc["passing_zero_count"] + passed_zeros(acc["value"], x),
        }
      end
    )

    result["landing_on_zero_count"] + result["passing_zero_count"]
  end

  def parse_input(is_test) do
    get_file_name(is_test)
    |> File.read!()
    |> String.trim_trailing()
    |> String.split("\n", trim: true)
    |> Enum.map(fn x -> case String.first(x) do
            "L" -> String.replace(x, "L", "-")
            "R" -> String.replace(x, "R", "+")
        end
    |> String.to_integer() end)
  end

  def get_file_name(is_test) do
    case is_test do
       true -> "inputs/day01-test.txt"
       false -> "inputs/day01.txt"
    end
  end

  def get_follow_value(acc_value, x) do
    Integer.mod(acc_value + x, 100)
  end

  def is_zero(value) do
    case Integer.mod(value, 100) === 0 do
      true -> 1
      false -> 0
    end
  end

  def passed_zeros(acc_value, x) do
    summed_value = acc_value + x

    acc_value_hundreds = div(acc_value, 100)
    summed_value_hundreds = div(summed_value, 100)

    has_passed_zero = has_passed_zero(acc_value, summed_value)

    return = passed_hundreds(summed_value_hundreds,acc_value_hundreds, summed_value) + has_passed_zero

    IO.inspect([acc_value, x, summed_value, acc_value_hundreds, summed_value_hundreds, return])

    return
  end

  def has_passed_zero(acc_value, summed_value) do
    if acc_value * summed_value < 0,
        do: 1,
        else: 0
  end

  def passed_hundreds(summed_value_hundreds,acc_value_hundreds, summed_value) do
    diff = abs(summed_value_hundreds - acc_value_hundreds)

    if Integer.mod(summed_value, 100) === 0 && diff > 0,
        do: diff - 1,
        else: diff
  end
end
