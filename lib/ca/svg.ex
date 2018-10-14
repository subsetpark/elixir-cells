defmodule Ca.Svg do
  # <rect width="100%" height="100%" fill="#fff"/>

  # <rect width="128" height="16" x="17" y="17" fill="#000"/>

  # <rect width="80" height="16" x="161" y="17" fill="#000"/>

  # <rect width="48" height="16" x="289" y="17" fill="#000"/>

  # <rect width="112" height="16" x="433" y="17" fill="#000"/>

  # <rect width="80" height="16" x="561" y="17" fill="#000"/>

  defstruct width: 0, height: 0, cells: []

  def add_cells(%__MODULE__{cells: cells} = svg, %{map: map}, offset) do
    %{
      svg
      | cells:
          cells ++
            (map
             |> Enum.filter(&match?({_, 1}, &1))
             |> Enum.map(&elem(&1, 0))
             |> Enum.map(&Ca.Svg.Cell.from_tuple/1)
             |> Enum.map(&Ca.Svg.Cell.offset(&1, offset)))
    }
  end

  def render(%__MODULE__{width: width, height: height, cells: cells}) do
    contents =
      cells
      |> Enum.map(&Ca.Svg.Cell.render/1)
      |> Enum.join("\n")

    ~s(<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 #{width} #{height}" width="#{width}" height="#{
      height
    }">#{contents}</svg>)
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
