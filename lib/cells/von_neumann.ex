defmodule CA.VonNeumann do
  def bits, do: 5

  def produce(state, rules) do
    size = Grid.size(state)
    produce(state, rules, Grid.new_grid(size), size * size, 0)
  end

  defp produce(_, _, acc, n, n), do: acc

  defp produce(state, rules, acc, final_n, n) do
    production =
      state
      |> Grid.get_neighborhood(n)
      |> CA.Util.produce(rules)

    produce(state, rules, Grid.set_cell(acc, n, production), final_n, n + 1)
  end

  def make_state(n) do
    f = fn k, grid ->
      value = :rand.uniform(2) - 1
      Grid.set_cell(grid, k, value)
    end

    0..(n * n - 1)
    |> Enum.reduce(Grid.new_grid(n), f)
  end

  def render(state, render_fn) do
    IO.write([IO.ANSI.home(), IO.ANSI.clear()])
    IEx.dont_display_result()

    for row <- Grid.rows(state) do
      row
      |> Enum.map(render_fn)
      |> IO.puts()
    end

    Process.sleep(50)
    state
  end
end
