defmodule Ca.Svg do
  alias Ca.Svg.Cell

  defstruct width: 0, height: 0, cells: []

  @width 40
  @offset 10

  def generate(state, col_num, row_num, begin_at, step, run_for) do
    svg = %__MODULE__{
      width: @width * col_num + @offset * (col_num + 1),
      height: @width * row_num + @offset * (row_num + 1)
    }

    state = run_for.(state, begin_at)

    for(n <- 0..(col_num - 1), m <- 0..(row_num - 1), do: {col(n), col(m)})
    |> Enum.sort()
    |> Enum.reduce({state, svg}, fn offset, {state, svg} ->
      state = run_for.(state, step)
      svg = add_cells(svg, state, offset)

      {state, svg}
    end)
    |> elem(1)
  end

  def render(%__MODULE__{width: width, height: height, cells: cells}) do
    contents =
      cells
      |> Enum.map(&Cell.render/1)
      |> Enum.join("\n")

    """
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 11in 17in" width="#{width}" height="#{
      height
    }">
    #{contents}
    </svg>
    """
  end

  defp add_cells(%__MODULE__{cells: cells} = svg, %{map: map}, offset) do
    %{
      svg
      | cells:
          cells ++
            (map
             |> Enum.filter(&match?({_, 1}, &1))
             |> Enum.map(&elem(&1, 0))
             |> Enum.map(&Cell.from_tuple/1)
             |> Enum.map(&Cell.offset(&1, offset)))
    }
  end

  defp col(n), do: @offset + (@width + @offset) * n
end

defmodule Ca.Svg.Cell do
  defstruct size: 1, x: 0, y: 0

  def from_tuple({x, y}), do: %__MODULE__{x: x, y: y}

  def offset(%__MODULE__{x: x, y: y} = cell, {dx, dy}) do
    %__MODULE__{cell | x: x + dx, y: y + dy}
  end

  def render(%__MODULE__{size: size, x: x, y: y}) do
    ~s(<rect width="#{size}" height="#{size}" x="#{x}" y="#{y}" fill="#000" />)
  end
end
