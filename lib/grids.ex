defmodule Grid do
  defstruct map: %{}, size: 0, type: :von_neumann

  @moduledoc """
  Implement common NxN grid functions.
  """

  @type t :: %Grid{
          map: %{required({integer, integer}) => CA.bit()},
          size: integer,
          type: :moore | :von_neumann
        }

  @spec new_grid(integer, atom) :: t
  def new_grid(length, neighborhood_type) do
    map =
      for(
        y <- 0..(length - 1),
        x <- 0..(length - 1),
        do: {x, y}
      )
      |> Enum.reduce(%{}, fn k, m -> Map.put(m, k, 0) end)

    %Grid{map: map, size: length, type: neighborhood_type}
  end

  defp von_neumann_coords({x, y}) do
    [
      {x, y - 1},
      {x - 1, y},
      {x, y},
      {x + 1, y},
      {x, y + 1}
    ]
  end

  defp moore_coords({x, y} = c) do
    [n, w, c, e, s] = von_neumann_coords(c)

    [
      {x - 1, y - 1},
      n,
      {x + 1, y - 1},
      w,
      c,
      e,
      {x - 1, y + 1},
      s,
      {x + 1, y + 1}
    ]
  end

  defp get_cell(grid, x, y) do
    Map.get(grid.map, to_index({x, y}, grid.size))
  end

  @spec get_neighborhood(t, {integer, integer}) :: CA.word()[CA.bit()]
  def get_neighborhood(grid, coords) do
    neighborhood_fn =
      case grid.type do
        :moore -> &moore_coords/1
        :von_neumann -> &von_neumann_coords/1
      end

    for {x2, y2} <- neighborhood_fn.(coords) do
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

  def set_coords(grid, {x, y}, value) do
    map = Map.replace!(grid.map, to_index({x, y}, grid.size), value)
    %{grid | map: map}
  end

  defp get_row(grid, y) do
    for x <- 0..grid.size, do: get_cell(grid, x, y)
  end

  @spec rows(t) :: [[CA.bit()]]
  def rows(grid) do
    for y <- 0..grid.size, do: get_row(grid, y)
  end

  def coords(grid) do
    Map.keys(grid.map)
  end
end
