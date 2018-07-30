defmodule CA.VonNeumann do
  @moduledoc """
  Von Neumann (2-dimensional) cellular automata.
  """

  @spec bits(:moore | :von_neumann) :: integer
  def bits(:von_neumann), do: 5
  def bits(:moore), do: 9

  defp produce(state, rules, coords) do
    production =
      state
      |> Grid.get_neighborhood(coords)
      |> CA.produce(rules)

    Grid.set_coords(state, coords, production)
  end

  @doc """
  Produce one new generation from `state`, given `rules`.
  """
  @spec produce(Grid.t(), [CA.rule(CA.bit())]) :: Grid.t()
  def produce(state, rules) do
    Enum.reduce(Grid.coords(state), state, fn coord_pair, acc ->
      produce(acc, rules, coord_pair)
    end)
  end

  @doc """
  Generate a random binary grid of size `n`.
  """
  @spec make_state(integer, atom) :: Grid.t()
  def make_state(n, neighborhood_type) do
    grid = Grid.new_grid(n, neighborhood_type)

    f = fn coord_pair, acc ->
      value = :rand.uniform(2) - 1
      Grid.set_coords(acc, coord_pair, value)
    end

    Enum.reduce(Grid.coords(grid), grid, f)
  end

  @doc """
  Clear the screen and print a single generation.
  """
  @spec render(Grid.t()) :: Grid.t()
  def render(state) do
    IO.write([IO.ANSI.home(), IO.ANSI.clear()])
    IEx.dont_display_result()

    for row <- Grid.rows(state) do
      row
      |> Enum.map(&CA.render_cell/1)
      |> IO.puts()
    end

    Process.sleep(50)
    state
  end
end
