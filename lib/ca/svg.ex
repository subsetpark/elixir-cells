defmodule Ca.Svg do
  alias Ca.Svg.Cell

  defstruct width: 0, height: 0, cells: []

  def add_cells(%__MODULE__{cells: cells} = svg, %{map: map}, offset) do
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

  def render(%__MODULE__{width: width, height: height, cells: cells}) do
    contents =
      cells
      |> Enum.map(&Cell.render/1)
      |> Enum.join("\n")

    """
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 11in 17in" width="#{width}" height="#{height}">
    #{contents}
    </svg>
    """
  end
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
