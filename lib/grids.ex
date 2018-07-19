defmodule Grid do
  def new_grid(size) do
    0
    |> Tuple.duplicate(size)
    |> Tuple.duplicate(size)
  end

  def get_neighborhood(grid, n) do
    {x, y} = integer_to_coords(grid, n)

    for {x2, y2} <- [{x, y}, {x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}] do
      get_cell(grid, x2, y2)
    end
  end

  defp to_index(n, modulus) do
    index = rem(n, modulus)

    cond do
      index < 0 -> modulus + index
      true -> index
    end
  end

  defp get_cell(grid, x, y) do
    size = tuple_size(grid)

    grid
    |> elem(to_index(y, size))
    |> elem(to_index(x, size))
  end

  def set_cell(grid, n, value) do
    {x, y} = integer_to_coords(grid, n)
    set_coords(grid, x, y, value)
  end

  defp set_coords(grid, x, y, value) do
    size = tuple_size(grid)
    x_index = to_index(x, size)
    y_index = to_index(y, size)

    updated_row =
      grid
      |> elem(y_index)
      |> put_elem(x_index, value)

    put_elem(grid, y_index, updated_row)
  end

  defp integer_to_coords(grid, n) do
    size = tuple_size(grid)
    {rem(n, size), div(n, size)}
  end
end
