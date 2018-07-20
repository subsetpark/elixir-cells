defmodule Grid do
  defstruct map: %{}, size: 0

  @moduledoc """
  Implement common NxN grid functions.
  """
  def size(grid), do: grid.size

  def new_grid(size) do
    map =
      for(
        y <- 0..(size - 1),
        x <- 0..(size - 1),
        do: {x, y}
      )
      |> Enum.reduce(%{}, fn k, m -> Map.put(m, k, 0) end)

    %Grid{map: map, size: size}
  end

  defp integer_to_coords(grid, n) do
    size = grid.size
    {rem(n, size), div(n, size)}
  end

  def get_neighborhood(grid, n) do
    {x, y} = integer_to_coords(grid, n)

    for {x2, y2} <- [{x, y}, {x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}] do
      get_cell(grid, x2, y2)
    end
  end

  defp to_index({x, y}, modulus) do
    {to_index(x, modulus), to_index(y, modulus)}
  end

  defp to_index(n, modulus) do
    case rem(n, modulus) do
      index when index < 0 -> modulus + index
      index -> index
    end
  end

  defp get_cell(grid, x, y) do
    Map.get(grid.map, to_index({x, y}, grid.size))
  end

  defp set_coords(grid, x, y, value) do
    map = Map.put(grid.map, to_index({x, y}, grid.size), value)
    %{grid | map: map}
  end

  def set_cell(grid, n, value) do
    {x, y} = integer_to_coords(grid, n)
    set_coords(grid, x, y, value)
  end

  defp get_row(grid, y) do
    for x <- 0..grid.size, do: get_cell(grid, x, y)
  end

  def rows(grid) do
    for y <- 0..grid.size, do: get_row(grid, y)
  end
end
