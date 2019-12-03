defmodule Day2 do
  def run(commands) do
    commands
    |> parse()
    |> step(0)
  end

  def part1(commands) do
    commands
    |> parse()
    |> step_with(12, 2)
  end

  def part2(commands, goal) do
    int_codes = parse(commands)

    for a <- 0..100,
        b <- 0..100 do
      case step_with(int_codes, a, b) do
        {:ok, ^goal} -> throw({a, b})
        _ -> nil
      end
    end

    nil
  catch
    {a, b} -> {a, b}
  end

  defp step_with(commands, second, third) do
    case step(%{commands | 1 => second, 2 => third}, 0) do
      {:ok, int_codes} -> {:ok, int_codes[0]}
      other -> other
    end
  end

  defp parse(command) do
    command
    |> String.split(",")
    |> Stream.map(&elem(Integer.parse(&1), 0))
    |> Stream.with_index()
    |> Stream.map(fn {code, index} -> {index, code} end)
    |> Enum.into(Map.new())
  end

  def step(int_codes, position) do
    case int_codes[position] do
      1 ->
        [first, second, third] = take(int_codes, position, 3)

        int_codes
        |> Map.put(third, int_codes[first] + int_codes[second])
        |> step(position + 4)

      2 ->
        [first, second, third] = take(int_codes, position, 3)

        int_codes
        |> Map.put(third, int_codes[first] * int_codes[second])
        |> step(position + 4)

      99 ->
        {:ok, int_codes}

      other ->
        {:error, {position, other}}
    end
  end

  defp take(int_codes, position, count, acc \\ [])
  defp take(_int_codes, _position, 0, acc), do: acc

  defp take(int_codes, position, offset, acc) do
    take(int_codes, position, offset - 1, [int_codes[position + offset] | acc])
  end

  def int_codes_to_list(int_codes, position \\ 0, acc \\ [])

  def int_codes_to_list(int_codes, position, acc) do
    case Map.pop(int_codes, position) do
      {nil, _rest} -> Enum.reverse(acc)
      {num, map} when map == %{} -> Enum.reverse([num | acc])
      {num, rest} -> int_codes_to_list(rest, position + 1, [num | acc])
    end
  end
end
