defmodule Day4 do
  def run1(a, b) do
    stream_digits(a, b)
    |> Stream.filter(&one_duplicate?/1)
    |> Enum.count()
  end

  def run2(a, b) do
    stream_digits(a, b)
    |> Stream.filter(&exact_duplicate?/1)
    |> Enum.count()
  end

  defp stream_digits(a, b) do
    a..b
    |> Stream.map(&Integer.digits/1)
    |> Stream.filter(&always_increasing?/1)
  end

  defp always_increasing?(list, min \\ 0)
  defp always_increasing?([h | t], min) when h >= min, do: always_increasing?(t, h)
  defp always_increasing?([], _), do: true
  defp always_increasing?(_, _), do: false

  defp one_duplicate?(list) do
    list
    |> Enum.chunk_by(& &1)
    |> Enum.any?(&(length(&1) >= 2))
  end

  defp exact_duplicate?(list) do
    list
    |> Enum.chunk_by(& &1)
    |> Enum.any?(&(length(&1) == 2))
  end
end
