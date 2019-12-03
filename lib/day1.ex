defmodule Day1 do
  def part1(inputs) do
    inputs
    |> parse()
    |> Stream.map(&fuel_for/1)
    |> Enum.sum()
  end

  def part2(inputs) do
    inputs
    |> parse()
    |> Stream.map(fn mass ->
      fuel = fuel_for(mass)

      fuel + rest_fuel(fuel)
    end)
    |> Enum.sum()
  end

  defp parse(inputs) do
    inputs
    |> String.split()
    |> Stream.map(&String.to_integer/1)
  end

  defp fuel_for(num), do: div(num, 3) - 2

  defp rest_fuel(num) do
    if (rest = fuel_for(num)) > 0 do
      rest + rest_fuel(rest)
    else
      0
    end
  end
end
