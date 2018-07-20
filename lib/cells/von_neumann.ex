defmodule CA.VonNeumann do
  @moduledoc """
  Von Neumann (2-dimensional) cellular automata.
  """

  @spec bits :: integer
  def bits, do: 5

  defp produce(_, _, acc, n, n), do: acc

  defp produce(state, rules, acc, final_n, n) do
    production =
      state
      |> Grid.get_neighborhood(n)
      |> CA.Util.produce(rules)

    produce(state, rules, Grid.set_cell(acc, n, production), final_n, n + 1)
  end

  @doc """
  Produce one new generation from `state`, given `rules`.
  """
  @spec produce(Grid.t(), [CA.rule(CA.bit())]) :: Grid.t()
  def produce(state, rules) do
    size = Grid.size(state)
    produce(state, rules, Grid.new_grid(size), size * size, 0)
  end

  @doc """
  Generate a random bit grid of size `n`.
  """
  @spec make_state(integer) :: Grid.t()
  def make_state(n) do
    f = fn k, grid ->
      value = :rand.uniform(2) - 1
      Grid.set_cell(grid, k, value)
    end

    0..(n * n - 1)
    |> Enum.reduce(Grid.new_grid(n), f)
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
      |> Enum.map(&CA.Util.render_cell/1)
      |> IO.puts()
    end

    Process.sleep(50)
    state
  end
end
