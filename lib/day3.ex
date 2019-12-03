defmodule Day3 do

  @type x :: integer
  @type y :: integer
  @type total_length :: integer
  @type vector :: {x, y, x, y, total_length}

  def run1(inputs) do
    inputs
    |> parse()
    |> find_intersections()
    |> Enum.min_by(&distance_to_center/1)
    |> distance_to_center()
  end

  def run2(inputs) do
    inputs
    |> parse()
    |> find_intersections()
    |> Enum.min_by(&distance_traveled/1)
    |> distance_traveled()
  end

  defp parse(inputs) do
    inputs
    |> String.split()
    |> Stream.map(fn path ->
      path
      |> String.split(",")
      |> Enum.scan({0, 0, 0, 0, 0}, &parse_vector/2)
    end)
    |> Enum.take(2)
  end

  defp find_intersections([first, second]) do
    first
    |> Stream.chunk_every(500)
    |> Task.async_stream(fn items ->
      for a <- items,
          b <- second,
          intersection = intersection(a, b),
          intersection != nil,
        do: intersection
    end)
    |> Stream.flat_map(fn {:ok, results} -> results end)
  end

  defp intersection({x11, y11, x12, y12, l1}, {x21, y21, x22, y22, l2}) do
    cond do
      # No intersections, if they are parallel to eachother
      x11 == x12 and x21 == x22 -> nil
      y11 == y12 and y21 == y22 -> nil

      # | -
      x11 == x12 and y21 == y22 ->
        {x2_min, x2_max} = order x21, x22
        {y1_min, y1_max} = order y11, y12

        if x2_min < x11 and x11 < x2_max and y1_min < y22 and y22 < y1_max do
          {x11, y22, l1 + l2 - abs(x11 - x22) - abs(y22 - y12)}
        end

      # - |
      y11 == y12 and x21 == x22 ->
        {x1_min, x1_max} = order x11, x12
        {y2_min, y2_max} = order y21, y22

        if y2_min < y11 and y11 < y2_max and x1_min < x22 and x22 < x1_max do
          {x22, y11, l1 + l2 - abs(y11 - y22) - abs(x22 - x12)}
        end

      true ->
        nil
    end
  end

  defp order(a, b) when a < b, do: {a, b}
  defp order(a, b), do: {b, a}

  defp distance_to_center({x, y, _}), do: abs(x) + abs(y)
  defp distance_traveled({_, _, l}), do: l

  defp parse_vector(<<direction::size(8), size::binary>>, {_, _, x, y, l}) do
    size = String.to_integer(size)

    case direction do
      ?R -> {x, y, x + size, y, l + size}
      ?L -> {x, y, x - size, y, l + size}
      ?U -> {x, y, x, y + size, l + size}
      ?D -> {x, y, x, y - size, l + size}
    end
  end
end
